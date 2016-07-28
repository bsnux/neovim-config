"---- Plugins

" vim-plug: https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

" Plugins list
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'neomake/neomake'
Plug 'majutsushi/tagbar'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'
Plug 'terryma/vim-multiple-cursors'
Plug 'altercation/vim-colors-solarized'
Plug 'mileszs/ack.vim'
Plug 'airblade/vim-gitgutter'

" Plugins functions
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

" Add plugins to &runtimepath
call plug#end()

"---- Personal config

" `yy` will copy to system clipboard
set clipboard+=unnamedplus

set background=dark
let g:solarized_termcolors=256
"colorscheme molokai
"colorscheme two-firewatch
" colorscheme jellybeans
colorscheme solarized


set nu

" Vertical line after line 80
set colorcolumn=81

" Simple Emacs keybindings for insert mode
imap <C-e> <esc>$a
imap <C-a> <esc>0i

" `leader` key is `,`
let mapleader = ','


"---- Plugins config

let g:deoplete#enable_at_startup = 1
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" run Neomake on the current file on every write
autocmd! BufWritePost * Neomake

" NerdTree
map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>

" fugitive
nnoremap <silent> <leader>gs :Gstatus<CR>

" Highlight problematic whitespace
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. 

" Removing trailing whitespaces automatically
autocmd FileType c,cpp,python,ruby,java autocmd BufWritePre <buffer> :%s/\s\+$//e

" Refresh file when it was changed externally
set autoread
au CursorHold * checktime  