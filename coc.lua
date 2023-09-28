-- Installing coc-nvim plugins
plugins  = {
  'yaml',
  'snippets',
  'yaml',
  'tsserver',
  'rust-analyzer',
  'json',
  'go',
  'docker',
  'deno',
}

for k,v in pairs(plugins) do
  vim.cmd('CocInstall ' .. 'coc-' .. v)
end