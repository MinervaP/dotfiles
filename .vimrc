" -------------------------------------
"  vimのオプション
" -------------------------------------
set number
set ruler
set cursorline
set cursorcolumn
set laststatus=2
set cmdheight=2
set showmatch
set helpheight=999
set list
set listchars=tab:▸\ ,trail:-,nbsp:%,extends:>,precedes:<,eol:¬

set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]
set scrolloff=8
set sidescrolloff=16
set sidescroll=1

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

set clipboard=unnamed,unnamedplus
set mouse=a
set shellslash

set wildmenu
set wildmode=list:longest,full
set history=10000

set visualbell
set t_vb=
set noerrorbells

" -------------------------------------
" キーバインド
" -------------------------------------
let mapleader = "\<Space>"

" -------------------------------------
" dein.vimの設定
" -------------------------------------
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('altercation/vim-colors-solarized')
call dein#add('itchyny/lightline.vim')
call dein#add('Shougo/neocomplete.vim')
call dein#add('easymotion/vim-easymotion')
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/neoyank.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('Townk/vim-autoclose')
call dein#add('tpope/vim-endwise')

call dein#end()

" -------------------------------------
" themeの設定
" -------------------------------------
syntax enable
set t_Co=256
set background=dark
colorscheme solarized
let g:solarized_termcolors = 256
let g:solarized_termtrans = 1

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
      return fugitive#head()
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
" neocomplete.vimの設定
" -------------------------------------
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 0
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
" TABで補完
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" <BS>で閉じて文字削除
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" -------------------------------------
" vim-easymotionの設定
" -------------------------------------
map <Leader> <Plug>(easymotion-prefix)
" ハイライト
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionTarget2First ctermbg=none ctermfg=magenta
hi EasyMotionTarget2Second ctermbg=none ctermfg=magenta

" -------------------------------------
" Unite.vimの設定
" -------------------------------------
let g:unite_enable_start_insert = 1
let g:unite_source_history_yank_enable =1
" fileで隠しファイルも表示する
call unite#custom#source('file', 'matchers', "matcher_default")
" UniteのPrefix
nnoremap [unite] <Nop>
nmap <Leader>u [unite]
" Prefix + uで最近開いたファイル fでカレントディレクトリ以下の全ファイル yでヤンク履歴 nで新規ファイル作成
nnoremap <silent> [unite]u :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> [unite]f :<C-u>Unite file<CR>
nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
nnoremap <silent> [unite]n :<C-u>Unite file/new<CR>

" -------------------------------------
" NERDTreeの設定
" -------------------------------------
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
" ファイル指定で開かれた場合とvimpagerのときはNERDTreeは表示しない
if !(argc() || exists('g:vimpager'))
  autocmd vimenter * NERDTree
endif
" 隠しファイルを表示
let g:NERDTreeShowHidden = 1
" C-eでNERDTreeをトグルする
noremap <silent><C-e> :NERDTreeToggle<CR>

