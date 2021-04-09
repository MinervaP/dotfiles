set nocompatible
" -------------------------------------
"  vimのオプション
" -------------------------------------
set number
set ruler
set laststatus=2
set cmdheight=2
set showmatch
set matchtime=1
set helpheight=999
set list
set listchars=tab:▸\ ,trail:-,nbsp:%,extends:>,precedes:<,eol:¬
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]
set scrolloff=8
set sidescrolloff=16
set sidescroll=1
set wrap
set display=lastline
set hidden
set confirm
set autoread
set nobackup
set noswapfile
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan
set gdefault
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set clipboard=unnamed
set mouse=a
set shellslash
set wildmenu
set wildmode=list:longest,full
set history=10000
set visualbell
set t_vb=
set noerrorbells
set display=lastline
set textwidth=0
set pumheight=10
set pyx=3
set pyxversion=3
set encoding=utf-8

" -------------------------------------
" dein.vimの設定
" -------------------------------------
let s:plugin_dir = $HOME . '/.vim/dein/'
let s:dein_dir = s:plugin_dir . 'repos/github.com/Shougo/dein.vim'

" dein.vimがないときはgit cloneする
if !isdirectory(s:dein_dir)
  call mkdir(s:dein_dir, 'p')
  silent execute printf('!git clone %s %s', 'https://github.com/Shougo/dein.vim', s:dein_dir)
endif

execute 'set runtimepath^=' . s:dein_dir

call dein#begin(s:plugin_dir)

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})

call dein#add('Shougo/deoplete.nvim')
call dein#add('roxma/nvim-yarp')
call dein#add('roxma/vim-hug-neovim-rpc')

call dein#add('altercation/vim-colors-solarized')
call dein#add('itchyny/lightline.vim')
call dein#add('bronson/vim-trailing-whitespace')
call dein#add('jiangmiao/auto-pairs')
call dein#add('tpope/vim-endwise')
call dein#add('tpope/vim-surround')
call dein#add('easymotion/vim-easymotion')
call dein#add('LeafCage/yankround.vim')

call dein#add('Shougo/unite.vim')
call dein#add('Shougo/vimfiler.vim')

call dein#add('tpope/vim-fugitive')
call dein#add('airblade/vim-gitgutter')

call dein#add('tyru/open-browser.vim')
call dein#add('minerva1129/previm')

call dein#add('mattn/emmet-vim')

call dein#add('tpope/vim-rails')

call dein#add('lervag/vimtex')

call dein#end()

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on

" -------------------------------------
" キーバインド
" -------------------------------------
let mapleader = "\<Space>"
" Yで行末までヤンク
nnoremap Y y$
" ESCで:noh
noremap <silent> <ESC><ESC> :<C-u>noh<CR>
" jjでESC
inoremap <silent> jj <ESC>
" <Leader>p で pasteモード切り替え
noremap <silent> <Leader>p :<C-u>set paste!<CR>
" 表示行単位で上下移動
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
nnoremap gj j
nnoremap gk k
" xでヤンクしない
nnoremap x "_x

" -------------------------------------
" themeの設定
" -------------------------------------
syntax enable
set t_Co=256
set background=dark
colorscheme solarized
let g:solarized_termcolors = 256
let g:solarized_termtrans = 1

highlight CursorLineNr cterm=reverse

" -------------------------------------
" lightline.vimの設定
" -------------------------------------
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

" -------------------------------------
" deocomplete.nvimの設定
" -------------------------------------
let g:deoplete#enable_at_startup = 1
" TABで補完
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" <BS>で閉じて文字削除
inoremap <expr><BS> deoplete#smart_close_popup()."\<BS>"
" omni補完を有効にする
if !exists('g:deoplete#sources#omni#input_patterns')
  let g:deoplete#sources#omni#input_patterns = {}
endif
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
call deoplete#custom#var('omni', 'input_patterns', {
          \ 'ruby': '[^. *\t]\.\w*\|\h\w*::',
          \ 'tex': g:vimtex#re#deoplete
          \})
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

" -------------------------------------
" vim-trailing-whitespaceの設定
" -------------------------------------
function! TrailingWhitespace()
  if &filetype != "markdown"
    FixWhitespace
  endif
endfunction
autocmd BufWrite * call TrailingWhitespace()

" -------------------------------------
" vim-easymotionの設定
" -------------------------------------
map <Leader> <Plug>(easymotion-prefix)
" ハイライト
highlight EasyMotionTarget ctermbg=none ctermfg=darkred
highlight EasyMotionTarget2First ctermbg=none ctermfg=darkcyan
highlight EasyMotionTarget2Second ctermbg=none ctermfg=darkcyan

" -------------------------------------
" yankround.vimの設定
" -------------------------------------
map p <Plug>(yankround-p)
map P <Plug>(yankround-P)
map <C-p> <Plug>(yankround-prev)
map <C-n> <Plug>(yankround-next)

" -------------------------------------
" previmの設定
" -------------------------------------
let g:previm_enable_realtime = 1

" -------------------------------------
" vim-gitgutterの設定
" -------------------------------------
let g:gitgutter_map_keys = 0

" -------------------------------------
" vimfiler.vimの設定
" -------------------------------------
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
noremap <silent><C-e> :VimFiler -toggle<CR>
let g:vimfiler_ignore_pattern = ['^\.$', '^\.\.$', '^\.git$', '^\.DS_Store$']
" ファイル指定で開かれた場合とvimpagerのとき以外はvimfilerを表示する
autocmd VimEnter * if !(argc() || exists('g:vimpager')) | VimFilerExplorer | endif

" -------------------------------------
" emmet-vimの設定
" -------------------------------------
let g:user_emmet_install_global = 0
autocmd FileType html,css,eruby,scss EmmetInstall

" -------------------------------------
" vimtexの設定
" -------------------------------------
let g:tex_conceal = ''
let g:tex_flavor = 'latex'

let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

