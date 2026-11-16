import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { AgentRow, FileOp, TouchedFile } from '../types'

const PANE = 'session-files'
const TITLE = 'Sesión'
const AGENT_POLL_MS = 1000
const LIVE_AGENT = new Set(['pending', 'running', 'waiting'])
const FRAME_MS = 90
const REVEAL_MS = 600
const GLOW_MS = 2600
const LEADER_MS = 1000
const SPINNER = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏']

const files = atom({ plugin: 'session-files', key: 'files' } as const, [], {
  shape: 'files-1',
})
const tick = atom({ plugin: 'session-files', key: 'tick' } as const, 0)
const scrollTop = atom({ plugin: 'session-files', key: 'scrollTop' } as const, 0)
const agents = atom({ plugin: 'session-files', key: 'agents' } as const, [], { shape: 'agents-1' })
// the person closed the pane with <space>e: auto-open stays off until they reopen it
let isHidden = false
// per-agent stats the pane shows, fed by turn.step (model, effort, usage) and the poll (start time)
type AgentStats = { startedAt: number; model?: string; effort?: string; context: number; output: number }
const stats = new Map<string, AgentStats>()
const CLAUDE_GLYPHS = ['·', '✢', '✳', '✶', '✻', '✽', '✻', '✶', '✳', '✢']

const statsOf = (id: string, now: number): AgentStats => {
  let s = stats.get(id)
  if (!s) stats.set(id, (s = { startedAt: now, context: 0, output: 0 }))
  return s
}
const shortModel = (m?: string): string => {
  if (!m) return '…'
  const hit = m.match(/(fable|opus|sonnet|haiku)-(\d+)-(\d+)/)
  return hit ? `${hit[1]} ${hit[2]}.${hit[3]}` : m.replace(/^claude-/, '')
}
const shortTokens = (n: number): string =>
  n >= 1e6 ? `${(n / 1e6).toFixed(1)}M` : n >= 1e3 ? `${(n / 1e3).toFixed(1)}k` : String(n)
const shortTime = (ms: number): string => {
  const sec = Math.floor(ms / 1000)
  return sec < 60 ? `${sec}s` : `${Math.floor(sec / 60)}m ${String(sec % 60).padStart(2, '0')}s`
}
// last scroll bound the render measured, so a scroll clamps without re-measuring
let maxScroll = 0
// when a leader space was typed into an empty prompt, for the <space>e chord
let leaderAt = 0

type TreeNode = {
  name: string
  dirs: Map<string, TreeNode>
  files: TouchedFile[]
  lastAt: number
}

type Row = {
  prefix: string
  name: string
  file?: TouchedFile
  lastAt: number
}

const newNode = (name: string): TreeNode => ({ name, dirs: new Map(), files: [], lastAt: 0 })

const relative = (path: string, root: string): string =>
  path.startsWith(root + '/') ? path.slice(root.length + 1) : path

const buildTree = (list: TouchedFile[], root: string): TreeNode => {
  const top = newNode('')
  for (const file of list) {
    const parts = relative(file.path, root).split('/').filter(Boolean)
    if (file.path.startsWith('/') && !file.path.startsWith(root + '/')) parts[0] = '/' + parts[0]
    let node = top
    node.lastAt = Math.max(node.lastAt, file.touchedAt)
    for (const dir of parts.slice(0, -1)) {
      let child = node.dirs.get(dir)
      if (!child) {
        child = newNode(dir)
        node.dirs.set(dir, child)
      }
      child.lastAt = Math.max(child.lastAt, file.touchedAt)
      node = child
    }
    node.files.push({ ...file, path: parts[parts.length - 1] ?? file.path })
  }
  return top
}

// Folds chains of single-child directories into one row: `src/app/api`.
const compact = (node: TreeNode): TreeNode => {
  let cur = node
  while (cur.files.length === 0 && cur.dirs.size === 1) {
    const only = [...cur.dirs.values()][0]!
    cur = { ...only, name: cur.name ? `${cur.name}/${only.name}` : only.name }
  }
  return cur
}

const flatten = (node: TreeNode, prefix: string, rows: Row[]): void => {
  const dirs = [...node.dirs.values()].map(compact).sort((a, b) => a.name.localeCompare(b.name))
  const leaves = [...node.files].sort((a, b) => a.path.localeCompare(b.path))
  const total = dirs.length + leaves.length
  let i = 0
  for (const dir of dirs) {
    const isLast = ++i === total
    rows.push({ prefix: prefix + (isLast ? '└─ ' : '├─ '), name: dir.name + '/', lastAt: dir.lastAt })
    flatten(dir, prefix + (isLast ? '   ' : '│  '), rows)
  }
  for (const file of leaves) {
    const isLast = ++i === total
    rows.push({ prefix: prefix + (isLast ? '└─ ' : '├─ '), name: file.path, file, lastAt: file.touchedAt })
  }
}

const OP_MARK: Record<FileOp, { mark: string; color: string }> = {
  write: { mark: 'A', color: 'success' },
  edit: { mark: 'M', color: 'warning' },
  notebook: { mark: 'N', color: 'suggestion' },
}

let timer: { cancel: () => void } | undefined

function isAnimating(list: TouchedFile[], now: number): boolean {
  return list.some(f => f.status === 'running' || now - f.touchedAt < GLOW_MS)
}

// Ticks the frame atom while a file spins or glows, then stops itself.
function animate($: EngineInterface): void {
  if (timer) return
  timer = $.clock.every(FRAME_MS, async () => {
    const isLive = isAnimating(await read($, files), await $.clock.now()) || (await read($, agents)).length > 0
    if (!isLive) {
      timer?.cancel()
      timer = undefined
    }
    await update($, tick, n => n + 1)
  })
}

const openPane = ($: EngineInterface) => $.ui.open({ id: PANE, title: TITLE, backgroundColor: 'transparent' })

// The pane shows only while there is something in it: edited files or live agents.
async function syncPane($: EngineInterface): Promise<void> {
  const hasContent = (await read($, files)).length > 0 || (await read($, agents)).length > 0
  const isOpen = (await $.ui.panes()).some(p => p.id === PANE)
  if (hasContent && !isOpen && !isHidden) await openPane($)
  else if (!hasContent && isOpen) await $.ui.close({ id: PANE })
}

// Mirrors the session's live agents into the atom, polled: no event fires as one ends.
async function syncAgents($: EngineInterface): Promise<void> {
  const live: AgentRow[] = (await $.agent.list())
    .filter(a => LIVE_AGENT.has(a.status))
    .map(a => ({ id: a.id, description: a.description, type: a.type, status: a.status }))
  const now = await $.clock.now()
  for (const a of live) statsOf(a.id, now)
  for (const id of stats.keys()) if (!live.some(a => a.id === id)) stats.delete(id)
  const prev = await read($, agents)
  if (JSON.stringify(prev) !== JSON.stringify(live)) {
    await update($, agents, () => live)
    if (live.length > 0) animate($)
  }
  // every poll, not only on change: a pane restored at startup with nothing in it must close
  await syncPane($)
}

// --- shell highlighting for Bash rows, mirroring nvim's gruvbox-material bash treesitter ---
type Tok = { text: string; color?: string; bold?: boolean; italic?: boolean }

const KEYWORDS = new Set([
  'if', 'then', 'else', 'elif', 'fi', 'for', 'while', 'until', 'do', 'done', 'case', 'esac',
  'in', 'function', 'select', 'time', 'export', 'local', 'return', 'sudo', 'exec', 'source',
])
const MAX_LINES = 4

const tokenize = (src: string): Tok[] => {
  const out: Tok[] = []
  let i = 0
  let atCommand = true // next word is a command name
  const push = (text: string, style: Omit<Tok, 'text'> = {}) => out.push({ text, ...style })
  while (i < src.length) {
    const c = src[i]!
    const rest = src.slice(i)
    if (c === '#' && (i === 0 || /\s/.test(src[i - 1]!))) {
      const end = src.indexOf('\n', i)
      const stop = end === -1 ? src.length : end
      push(src.slice(i, stop), { color: 'inactive', italic: true })
      i = stop
      continue
    }
    if (c === '\n') { push(c); i++; atCommand = true; continue }
    if (/\s/.test(c)) {
      const m = rest.match(/^[ \t]+/)![0]
      push(m); i += m.length; continue
    }
    const op = rest.match(/^(\|\||&&|;;|\|&|\||;|&|>>|<<<|<<|>&|<&|>|<|\(|\)|\{|\}|\\\n)/)
    if (op) {
      // brackets stay plain as in nvim's bash treesitter; real operators go orange
      push(op[0], /^[(){}]$/.test(op[0]) ? {} : { color: 'claude' })
      i += op[0].length
      if (!/^[<>]/.test(op[0])) atCommand = true
      continue
    }
    if (c === "'") {
      const end = src.indexOf("'", i + 1)
      const stop = end === -1 ? src.length : end + 1
      push(src.slice(i, stop), { color: 'remember' })
      i = stop; atCommand = false; continue
    }
    if (c === '"') {
      let j = i + 1
      while (j < src.length && src[j] !== '"') j += src[j] === '\\' ? 2 : 1
      push(src.slice(i, Math.min(j + 1, src.length)), { color: 'remember' })
      i = Math.min(j + 1, src.length); atCommand = false; continue
    }
    if (c === '$') {
      const v = rest.match(/^\$(\{[^}]*\}|\(\(?|[A-Za-z_][A-Za-z0-9_]*|[0-9@#?$!*-])/)
      if (v) {
        // nvim: the $ (and ${ }) is punctuation.special blue, the name plain text
        const body = v[0].slice(1)
        if (body.startsWith('{')) {
          push('${', { color: 'suggestion' }); push(body.slice(1, -1)); push('}', { color: 'suggestion' })
        } else if (body.startsWith('(')) {
          push('$', { color: 'suggestion' }); push(body)
        } else {
          push('$', { color: 'suggestion' }); push(body)
        }
        i += v[0].length
        if (v[0].startsWith('$(')) atCommand = true
        continue
      }
    }
    const word = rest.match(/^[^\s|&;<>(){}'"$#]+(#[^\s|&;<>(){}'"$]*)?/)?.[0] ?? c
    if (atCommand && /^[A-Za-z_][A-Za-z0-9_]*=/.test(word)) {
      push(word) // VAR=value prefix keeps the command slot open
    } else if (KEYWORDS.has(word)) {
      push(word, { color: 'error' })
      atCommand = word !== 'in'
    } else if (atCommand) {
      push(word, { color: 'success' })
      atCommand = false
    } else if (/^\d+$/.test(word)) {
      push(word, { color: 'permission' })
    } else {
      push(word)
    }
    i += word.length
  }
  return out
}

export const register: Register = on => {
  // Groups that hold a Bash call unfold, so every command shows as its own row.
  on('ui.render', { component: 'ToolGroup', plugin: '*' }, async ($, e, next) => {
    const props = e.props as { calls: ReadonlyArray<{ tool: string }>; isExpanded: boolean }
    if (props.isExpanded || !props.calls.some(c => c.tool === 'Bash')) return next(e)
    return next({ ...e, props: { ...e.props, isExpanded: true } } as typeof e)
  })

  // render hooks hear only their own plugin's drawings by default: '*' reaches the engine's rows
  on('ui.render', { component: 'ToolUse', plugin: '*' }, async ($, e, next) => {
    const props = e.props as { tool: string; input: unknown; isRunning: boolean; isErrored: boolean; isExpanded?: boolean }
    const command = (props.input as { command?: unknown } | undefined)?.command
    if (props.tool !== 'Bash' || typeof command !== 'string') return next(e)

    const { Box, Text } = $.ui.resolve(e)
    // the card spans the transcript up to the side pane; long commands break at operators
    const width = Math.max(30, (e.viewport?.columns ?? 100) - 4)
    const inner = width - 4 // "│ " + content + " │"

    // tokens -> logical lines (source newlines), then break long lines after top-level operators
    const logical: Tok[][] = [[]]
    for (const t of tokenize(command.replace(/\s+$/, ''))) {
      t.text.split('\n').forEach((part, k) => {
        if (k > 0) logical.push([])
        if (part) logical[logical.length - 1]!.push({ ...t, text: part })
      })
    }
    const len = (row: Tok[]) => row.reduce((n, t) => n + t.text.length, 0)
    const BREAK_AFTER = new Set(['&&', '||', ';', '|'])
    const lines: Tok[][] = []
    for (const row of logical) {
      if (len(row) <= inner) { lines.push(row); continue }
      let cur: Tok[] = []
      for (const t of row) {
        if (cur.length === 0 && !t.text.trim()) continue // no leading blanks on a broken line
        cur.push(t)
        if (t.color === 'claude' && BREAK_AFTER.has(t.text)) { lines.push(cur); cur = [{ text: '  ' }] }
      }
      if (cur.some(t => t.text.trim())) lines.push(cur)
    }
    // hard-wrap anything still wider than the card
    const rows: Tok[][] = []
    for (const line of lines) {
      let cur: Tok[] = []
      let used = 0
      for (const t of line) {
        let text = t.text
        while (used + text.length > inner) {
          const room = inner - used
          if (room > 0) cur.push({ ...t, text: text.slice(0, room) })
          rows.push(cur); cur = [{ text: '  ' }]; used = 2
          text = text.slice(Math.max(room, 0))
        }
        if (text) { cur.push({ ...t, text }); used += text.length }
      }
      rows.push(cur)
    }
    const limit = props.isExpanded ? rows.length : 8
    const shown = rows.slice(0, limit)
    if (rows.length > limit) shown.push([{ text: `… +${rows.length - limit} líneas (ctrl+o)`, color: 'inactive' }])

    const status = props.isRunning ? 'warning' : props.isErrored ? 'error' : 'success'
    const label = props.isRunning ? ' Bash · corriendo… ' : ' Bash '
    const top = '╭─' + label + '─'.repeat(Math.max(0, width - 3 - label.length)) + '╮'
    const pad = (row: Tok[]) => ' '.repeat(Math.max(0, inner - len(row)))
    return (
      <Box flexDirection="row">
        <Text color={status}>● </Text>
        <Box flexDirection="column" width={width}>
          <Text color="inactive">{top}</Text>
          {shown.map(row => (
            <Text>
              <Text color="inactive">│ </Text>
              {row.map(t => <Text color={t.color} italic={t.italic}>{t.text}</Text>)}
              {pad(row)}
              <Text color="inactive"> │</Text>
            </Text>
          ))}
          <Text color="inactive">{'╰' + '─'.repeat(width - 2) + '╯'}</Text>
        </Box>
      </Box>
    )
  })

  on('session.start', async ($, e, next) => {
    timer = undefined
    await $.command.register({
      name: 'files',
      description: 'Muestra el árbol de archivos modificados en esta sesión',
    })
    isHidden = false
    $.clock.every(AGENT_POLL_MS, () => void syncAgents($).catch(() => {}))
    return next(e)
  })

  // A subagent's steps carry its model, effort and token usage.
  on('turn.step', async function* ($, e, next) {
    if (!e.agentId) return yield* next(e)
    const st = statsOf(e.agentId, await $.clock.now())
    st.model = e.model
    if (e.effort !== undefined) st.effort = String(e.effort)
    const r = yield* next(e)
    if (r.usage) {
      st.model = r.usage.model
      st.context = r.usage.input_tokens + r.usage.cache_read_input_tokens + r.usage.cache_creation_input_tokens
      st.output += r.usage.output_tokens
    }
    return r
  })

  on('command.run', { command: 'files' }, async $ => {
    isHidden = false
    const opened = await openPane($)
    return { text: opened.isPlaced ? 'Panel de archivos abierto.' : `Panel en espera: ${opened.reason}` }
  })

  // <space>e on an empty prompt toggles the pane. Vim normal-mode keys never reach mods
  // (only edits do), so the leader is a space typed into an empty box, then e within 1s.
  on('prompt.edit', async ($, e, next) => {
    // cheap string checks first: this hook runs on every keystroke under a 50ms budget
    const isLeader = e.text === '' && e.inputText === ' '
    const maybeChord = e.text === ' ' && e.cursor === 1 && e.inputText === 'e' && leaderAt > 0
    if (!isLeader && !maybeChord) {
      leaderAt = 0
      return next(e)
    }
    const now = await $.clock.now()
    if (isLeader) {
      leaderAt = now
      return next(e)
    }
    const isChord = now - leaderAt < LEADER_MS
    leaderAt = 0
    if (!isChord) return next(e)
    const isOpen = (await $.ui.panes()).some(p => p.id === PANE)
    isHidden = isOpen
    if (isOpen) await $.ui.close({ id: PANE })
    else await openPane($)
    return { text: '', cursor: 0 }
  })

  on('tool.call', async ($, e, next) => {
    let path: string | undefined
    let op: FileOp | undefined
    if (e.tool === 'Edit') [path, op] = [e.file_path, 'edit']
    else if (e.tool === 'Write') [path, op] = [e.file_path, 'write']
    else if (e.tool === 'NotebookEdit') [path, op] = [e.notebook_path, 'notebook']
    if (!path || !op) return next(e)

    const filePath = path
    const fileOp = op
    const startedAt = await $.clock.now()
    let wasKnown = false
    await update($, files, list => {
      const found = list.find(f => f.path === filePath)
      wasKnown = found !== undefined
      if (found) {
        return list.map(f => (f.path === filePath ? { ...f, status: 'running' as const, touchedAt: startedAt } : f))
      }
      return [...list, { path: filePath, op: fileOp, count: 0, status: 'running' as const, firstAt: startedAt, touchedAt: startedAt }]
    })
    animate($)
    await syncPane($)

    const ran = await next(e)
    const endedAt = await $.clock.now()
    const isDenied = ran.deny !== undefined
    const isError = !isDenied && ran.isError === true
    await update($, files, list =>
      isDenied && !wasKnown
        ? list.filter(f => f.path !== filePath)
        : list.map(f =>
            f.path === filePath
              ? {
                  ...f,
                  status: isError ? 'error' as const : 'done' as const,
                  count: isDenied || isError ? f.count : f.count + 1,
                  touchedAt: endedAt,
                }
              : f,
          ),
    )
    animate($)
    await syncPane($)
    return ran
  }).catch(($, e, next) => next(e))

  // The pane body scrolls only inside the card: the engine's own scroll is replaced by ours.
  on('ui.scroll', { component: 'Pane', requestId: PANE }, async ($, e) => {
    await update($, scrollTop, n => Math.min(maxScroll, Math.max(0, n + e.by)))
    return {}
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    // exact pane size, so the card neither widens the dock nor overflows its height
    const width = Math.max(8, e.props.bodyColumns)
    const height = Math.max(5, e.props.scroll.bodyRows)
    // rounded card drawn with box glyphs: the Box API restyles borders but cannot add one
    const rule = (left: string, right: string) => (
      <Text color="inactive">{left + '─'.repeat(width - 2) + right}</Text>
    )
    const side = (child: any) => (
      <Box flexDirection="row" width={width} flexShrink={0}>
        <Text color="inactive">│ </Text>
        <Box width={width - 4} overflow="hidden">{child}</Box>
        <Text color="inactive"> │</Text>
      </Box>
    )
    // header stays fixed; body is a window of `room` rows starting at the scroll offset
    const card = (header: any[], body: any[], offset: number, cardHeight: number) => {
      const room = Math.max(1, cardHeight - 2 - header.length)
      const shown = body.slice(offset, offset + room)
      const below = body.length - offset - shown.length
      if (below > 0) shown[shown.length - 1] = <Text dimColor>↓ {below + 1} más</Text>
      if (offset > 0) shown[0] = <Text dimColor>↑ {offset + 1} más</Text>
      while (shown.length < room) shown.push(<Text> </Text>)
      return (
        <Box flexDirection="column" width={width} height={cardHeight} flexShrink={0}>
          {rule('╭', '╮')}
          {header.map(side)}
          {shown.map(side)}
          {rule('╰', '╯')}
        </Box>
      )
    }
    const frame = await read($, tick)
    const list = await read($, files)
    const live = await read($, agents)
    const now = await $.clock.now()
    const root = await $.session.root()

    // files on top, agents below; each only when it has something, half and half when both
    const filesHeight = live.length === 0 ? height : list.length === 0 ? 0 : Math.ceil(height / 2)
    const agentsHeight = height - filesHeight
    const cards: any[] = []

    if (list.length === 0) maxScroll = 0
    else {
      const rows: Row[] = []
      flatten(buildTree(list, root), '', rows)
      const added = list.filter(f => f.op === 'write').length
      const edits = list.reduce((sum, f) => sum + f.count, 0)
      const rootName = root.split('/').pop() ?? root
      const header = [
        <Text wrap="truncate-end">
          <Text weight="bold">{list.length}</Text>
          <Text dimColor> archivos · </Text>
          <Text color="success">+{added}</Text>
          <Text dimColor> · {edits} cambios</Text>
        </Text>,
        <Text color="claude" weight="bold" wrap="truncate-end">{rootName}/</Text>,
      ]
      const body = rows.map(row => {
        const age = now - row.lastAt
        const isGlowing = age < GLOW_MS
        if (!row.file) {
          return (
            <Text wrap="truncate-end">
              <Text dimColor>{row.prefix}</Text>
              <Text color={isGlowing ? 'suggestion' : 'subtle'} weight={isGlowing ? 'bold' : 'regular'}>
                {row.name}
              </Text>
            </Text>
          )
        }
        const file = row.file
        const sinceFirst = now - file.firstAt
        const reveal = sinceFirst < REVEAL_MS
          ? row.name.slice(0, Math.max(1, Math.ceil((row.name.length * sinceFirst) / REVEAL_MS)))
          : row.name
        const { mark, color } = OP_MARK[file.op]
        const badge =
          file.status === 'running'
            ? <Text color="warning">{SPINNER[frame % SPINNER.length]} </Text>
            : file.status === 'error'
              ? <Text color="error">✗ </Text>
              : isGlowing
                ? <Text color={frame % 4 < 2 ? 'claude' : 'success'}>● </Text>
                : <Text color={color}>{mark} </Text>
        const nameColor =
          file.status === 'running' ? 'warning'
            : file.status === 'error' ? 'error'
              : age < 500 ? 'claude'
                : isGlowing ? 'success'
                  : 'text'
        return (
          <Text wrap="truncate-end">
            <Text dimColor>{row.prefix}</Text>
            {badge}
            <Text color={nameColor} weight={isGlowing ? 'bold' : 'regular'} inverse={age < 250 && file.status === 'done'}>
              {reveal}
            </Text>
            {sinceFirst < REVEAL_MS && <Text color="claude">▌</Text>}
            {file.count > 1 && <Text dimColor> ×{file.count}</Text>}
          </Text>
        )
      })
      const room = Math.max(1, filesHeight - 2 - header.length)
      maxScroll = Math.max(0, body.length - room)
      const offset = Math.min(maxScroll, await read($, scrollTop))
      cards.push(card(header, body, offset, filesHeight))
    }

    if (live.length > 0) {
      const header = [
        <Text wrap="truncate-end">
          <Text weight="bold">{live.length}</Text>
          <Text dimColor> {live.length === 1 ? 'agente corriendo' : 'agentes corriendo'}</Text>
        </Text>,
      ]
      const glyph = CLAUDE_GLYPHS[Math.floor(frame / 2) % CLAUDE_GLYPHS.length]
      const body = live.flatMap(a => {
        const st = stats.get(a.id)
        const meta = [
          shortModel(st?.model),
          st?.effort,
          st ? shortTime(now - st.startedAt) : undefined,
          st && st.context + st.output > 0 ? `${shortTokens(st.context + st.output)} tok` : undefined,
        ].filter(Boolean).join(' · ')
        return [
          <Text wrap="truncate-end">
            <Text color={a.status === 'running' ? 'claude' : 'warning'}>{glyph} </Text>
            <Text weight="bold">{a.description}</Text>
            <Text dimColor> · {a.type}</Text>
          </Text>,
          <Text dimColor wrap="truncate-end">  {meta}</Text>,
        ]
      })
      cards.push(card(header, body, 0, agentsHeight))
    }

    if (cards.length === 0) return <Text> </Text>
    return <Box flexDirection="column" width={width} height={height}>{cards}</Box>
  })
}
