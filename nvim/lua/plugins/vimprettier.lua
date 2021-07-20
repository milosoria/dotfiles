local function init()
    vim.g.prettier.autoformat_require_pragma = 0
    --vim.cmd([[autocmd BufWritePre *js,*ts,*jsx,*tsx,*.graphql,*.json,*.md,*.mdx,*.svelte,*.yml,*yaml :Prettier]])
end

return {
    init = init
}
