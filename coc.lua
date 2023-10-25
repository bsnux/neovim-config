-- Installing coc-nvim plugins
plugins  = {
  'deno',
  'docker',
  'go',
  'json',
  'prettier',
  'rust-analyzer',
  'sh',
  'snippets',
  'tsserver',
  'yaml',
}

for k,v in pairs(plugins) do
  vim.cmd('CocInstall ' .. 'coc-' .. v)
end
