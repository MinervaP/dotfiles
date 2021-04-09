" -------------------------
" options
" -------------------------
set number
set cmdheight=2
set showmatch
set matchtime=1
set helpheight=999
set list
set listchars=tab:▸\ ,trail:-,nbsp:%,extends:>,precedes:<,eol:¬
set whichwrap=b,s,h,l,<,>,[,]
set scrolloff=8
set hidden
set confirm
set noswapfile
set ignorecase
set smartcase
set gdefault
set expandtab
set tabstop=2
set shiftwidth=0
set smartindent
set clipboard=unnamed
set mouse=a
set wildmode=list:longest,full
set pumheight=10
set inccommand=split

" -------------------------
" plugins by dein.vim
" -------------------------
let s:plugin_dir = $HOME . '/.cache/dein'
let s:dein_dir = s:plugin_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_dir)
  call mkdir(s:dein_dir, 'p')
  execute printf('!git clone %s %s', 'https://github.com/Shougo/dein.vim', s:dein_dir)
endif

execute 'set runtimepath^=' . s:dein_dir

call dein#begin(s:plugin_dir)

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
call dein#add('Shougo/deoplete.nvim')

call dein#add('altercation/vim-colors-solarized')
call dein#add('itchyny/lightline.vim')

call dein#add('jiangmiao/auto-pairs')
call dein#add('tpope/vim-endwise')
call dein#add('bronson/vim-trailing-whitespace')

call dein#add('Shougo/unite.vim')
call dein#add('Shougo/vimfiler.vim')

call dein#add('tpope/vim-fugitive')
call dein#add('airblade/vim-gitgutter')

call dein#add('lervag/vimtex')

call dein#end()

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

" -------------------------
" key bindings
" -------------------------
let mapleader = "\<Space>"
nnoremap Y y$
noremap <silent> <ESC><ESC> :<C-u>noh<CR>
inoremap <silent> jj <ESC>
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap x "_x

" -------------------------
" themes
" -------------------------
colorscheme solarized

let g:lightline = {
        \ 'colorscheme': 'solarized',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'LightLineModified',
        \   'readonly': 'LightLineReadonly',
        \   'fugitive': 'LightLineFugitive',
        \   'filename': 'LightLineFilename',
        \   'fileformat': 'LightLineFileformat',
        \   'filetype': 'LightLineFiletype',
        \   'fileencoding': 'LightLineFileencoding',
        \   'mode': 'LightLineMode',
        \ },
        \ 'separator': { 'left': '', 'right': '' },
        \ 'subseparator': { 'left': '', 'right': '' }
        \ }

function! LightLineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '' : ''
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return empty(fugitive#head()) ? '' : ' ' . fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" -------------------------
" deoplete.nvim
" -------------------------
let g:deoplete#enable_at_startup = 1
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><BS> deoplete#smart_close_popup()."\<BS>"
if !exists('g:deoplete#sources#omni#input_patterns')
  let g:deoplete#sources#omni#input_patterns = {}
endif

" -------------------------
" vim-trailing-whitespace
" -------------------------
function! TrailingWhitespace()
  if &filetype != "markdown"
    FixWhitespace
  endif
endfunction
autocmd BufWrite * call TrailingWhitespace()

" -------------------------
" vimfiler.vim
" -------------------------
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
noremap <silent><C-e> :VimFiler -toggle<CR>
let g:vimfiler_ignore_pattern = ['^\.$', '^\.\.$', '^\.git$', '^\.DS_Store$']
autocmd VimEnter * if !(argc() || exists('g:vimpager')) | VimFilerExplorer | endif

" -------------------------
" vim-gitgutter
" -------------------------
let g:gitgutter_map_keys = 0

" -------------------------
" vimtex
" -------------------------
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

