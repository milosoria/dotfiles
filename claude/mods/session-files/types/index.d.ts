export type FileOp = 'write' | 'edit' | 'notebook'
export type FileStatus = 'running' | 'done' | 'error'
export type AgentRow = {
  id: string
  description: string
  type: string
  status: string
}
export type TouchedFile = {
  path: string
  op: FileOp
  count: number
  status: FileStatus
  firstAt: number
  touchedAt: number
}

declare module 'claude-code' {
  interface PluginState {
    'session-files': { files: Shaped<TouchedFile[]>; tick: number; scrollTop: number; agents: Shaped<AgentRow[]> }
  }
}
