return {
  'vimwiki/vimwiki',
  config = function()
    -- Configure vimwiki to use markdown in ~/notes
    vim.g.vimwiki_list = {
      {
        path = '~/notes',
        syntax = 'markdown',
        ext = '.md'
      }
    }
    -- Map Ctrl+Space to toggle checkbox
    vim.keymap.set('n', '<C-Space>', '<Plug>VimwikiToggleListItem')
  end
}