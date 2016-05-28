" vimrc
" Saleem Abdulrasool <compnerd@compnerd.org>
" vim: set ts=8 sts=2 sw=2 et nowrap:

scriptencoding utf-8        " this file is in utf-8

" ---- language categorisation ----
let s:CLangFileTypes = [ 'c', 'cpp', 'objc', 'objcpp', 'c.doxygen',
                       \ 'cpp.doxygen', 'objc.doxygen', 'objcpp.doxygen' ]
let s:CPlusPlusFileTypes = [ 'cpp', 'objcpp', 'cpp.doxygen', 'objcpp.doxygen' ]

" ---- Terminal Setup ----
if (&term =~ "xterm") && (&termencoding == "")
  set termencoding=utf-8
endif

" ---- General Setup ----
set nocompatible            " don't emulate vi's limitations

set encoding=utf-8          " default encoding should always be UTF-8

set tabstop=8               " 8 spaces for tabs
set shiftwidth=2            " 4 spaces for indenting
set softtabstop=2           " 4 spaces for indenting
set smarttab                " tab next line based on current line
set expandtab               " spaces for tabs

set backspace=2             " fix backspace behaviour (indent,eol,start)

set incsearch               " enable incremental searching
set hlsearch                " hilight search matches
set ignorecase              " case insensitive search ...
set smartcase               " ... except when we dont want it
set infercase               " attempt to figure out the correct case

" unhighlight the search results when the keyboard is idle
autocmd CursorHold,CursorHoldI * nohls | redraw

set wildmenu                " menu on completion please
set wildmode=longest,full   " match the longest substring, complete with first
set wildignore=*.o,*~       " ignore temporary files in wildmenu

set scrolloff=2             " show 2 lines of context when scrolling
set sidescrolloff=2         " show 2 columns of context when scrolling
set nostartofline           " don't jump to first character when paging

set hidden                  " allow flipping of buffers without saving
set autowrite               " save buffers on flip

set nomodeline              " modelines are insecure, see securemodelines

set textwidth=80            " wrap at 80 character boundary by default
set formatoptions=tcroqnl   " cf. fo-table
if (v:version >= 703 && has('patch541'))
  set formatoptions+=j      " strip comment leader when joining lines
endif
set linebreak               " display long lines wrapped at word boundaries
let &showbreak = "↪ "       " continuation character

set virtualedit=block       " allow virtual editing in visual block mode

set lazyredraw              " prevent window updates during macro execution
set ttyfast                 " use advanced tty features for smoother drawing

" ---- Syntax Highlighting ----
syntax on                   " enable syntax highlighting
syntax sync fromstart       " parse from the beginning to get accurate syntax highlighting

" ---- Filetypes ----
filetype on                 " detect filetype by extensions
filetype indent on          " enable indents based on extensions
filetype plugin on          " load filetype plugins

" ---- codetags ----
if has("autocmd")
  autocmd syntax * syntax keyword hNote NOTE containedin=.*Comment
  highlight link hNote note

  autocmd syntax * syntax keyword hHack HACK containedin=.*Comment
  highlight link hHack hack

  " NOTE(compnerd) violate 80-colume for syntax highlighting
  autocmd colorscheme * highlight todo gui=bold guibg=NONE guifg=#eeee00 cterm=bold ctermbg=NONE ctermfg=yellow
  autocmd colorscheme * highlight note gui=bold guibg=NONE guifg=#009900 cterm=bold ctermbg=NONE ctermfg=green
  autocmd colorscheme * highlight hack gui=bold guibg=NONE guifg=#ee0000 cterm=bold ctermbg=NONE ctermfg=red
endif

" ---- Colour Schemes ----
set background=dark         " prefer dark backgrounds

" shamelessly stolen from Ciaran McCreesh <ciaran.mccreesh@gmail.com>
fun! LoadColourScheme(schemes)
  let l:schemes = a:schemes . ":"

  while l:schemes != ""
    let l:scheme = strpart(l:schemes, 0, stridx(l:schemes, ":"))
    let l:schemes = strpart(l:schemes, stridx(l:schemes, ":") + 1)

    try
      exec "colorscheme" l:scheme
      break
    catch
    endtry
  endwhile
endfun

if has("gui_running")
  call LoadColourScheme("spacegray:babymate256:PaperColor")
elseif (&t_Co == 256)
  call LoadColourScheme("spacegray:PaperColor")
elseif (&t_Co == 88)
  call LoadColourScheme("lucius:moria:inkpot")
else
  call LoadColourScheme("elflord:zellner")
endif

" ---- Trailing/Bleeding Whitespace ----

" shamelessly stolen from Ciaran McCreesh <ciaran.mccreesh@gmail.com>
if (&termencoding == "utf-8") || has("gui_running")
  if (v:version >= 700)
    set list listchars=tab:»·,trail:·,extends:…,nbsp:‗
  else
    set list listchars=tab:»·,trail:·,extends:…
  endif
else
  if (v:version >= 700)
    set list listchars=tab:>-,trail:.,extends:>,nbsp:_
  else
    set list listchars=tab:>-,trail:.,extends:>
  endif
endif

" ---- Status Line ----
set laststatus=2
set shortmess=aItT
set statusline=Editing:\ %m%F%r\ %y[%{&ff}][%{&fenc}]\ %=Location:\ Line\ %l/%L,\ Column\ %v\ (%p%%)

" ---- Spell Checking ----
if (v:version >= 700)
  set spelllang=en_us       " US English spelling please
endif

" ---- Code Folding ----
set fillchars=fold:\        " no fill characters for folds
let javascript_fold = 1     " enable folding for JavaScript

" ---- Code Indexing (ctags/cscope) ----
set tags=tags;/             " search for tags in parent directory, recursively
set showfulltag             " show full tags when doing completion
set tagrelative             " paths are relative to tag file

if has("cscope")
  set cscopetag             " search both ctags and cscope
  set cscopetagorder=1      " check ctags before cscope

  set nocscopeverbose
  if filereadable("cscope.out")
    cscope add cscope.out
  endif
  set cscopeverbose

  " c -> calls ; d -> definition ; f -> file ; r -> references
  nmap <leader>cc :cscope find c <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>cf :cscope find f <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>cd :cscope find g <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>cr :cscope find s <C-R>=expand("<cword>")<CR><CR>
endif

" ---- Build Tools Setup ----
if filereadable("SConstruct")
  set makeprg=scons\ -Q
endif

autocmd FileType scons
      \ setlocal includeexpr=substitute(v:fname,'#/',substitute(findfile('SConstruct','.;'),'SConstruct','','g'),'g')

" ---- Restore Cursor Location ----
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g'\"" |
      \ endif

" ---- Splits ----
" resize splits when windows are resized
autocmd VimResized * wincmd =

" ---- Text Width Marker ----
if (v:version >= 703)
  set colorcolumn=+1
  highlight ColorColumn ctermbg=237 guibg=#363946
endif

" ---- Key Mappings ----

" blackhole register ("_ is hard to type, use the leader instead)
map <leader>b "_

" line numbers
nmap <silent> <F12> :silent set number!<CR>
imap <silent> <F12> <C-O>:silent set number!<CR>

nmap <silent> <S-F12> :silent set relativenumber!<CR>
imap <silent> <S-F12> <C-O>:silent set relativenumber!<CR>

" spell checking
if (v:version >= 700)
  nmap <silent> <F10> :silent set spell!<CR>
  imap <silent> <F10> <C-O>:silent set spell!<CR>
endif

" tab-based indentation
vmap <silent> <tab>     >gv
vmap <silent> <s-tab>   <gv

" space bar paging
nmap <silent> <space>   <C-f>

" improved K behaviour (K in visual mode is dumb)
vmap K k
nmap K K<CR>

" ---- shortcuts ----
function! s:CLangShortcuts()
  inoremap #in #include
  if stridx(&ft, "objc", 0) == 0
    inoremap #im #import
  endif

  inoremap #d #define
  inoremap #els #else
  inoremap #eli #elif
  inoremap #en #endif
  inoremap #p #pragma
  inoremap #u #undef
endfunction

if has("autocmd")
  execute "autocmd FileType " . join(s:CLangFileTypes, ",") . " call s:CLangShortcuts()"
endif

if has("autocmd")
  execute "autocmd FileType " . join(s:CPlusPlusFileTypes, ",") . " set matchpairs=(:),{:},[:],<:>"
endif

if has("digraph")
  digraph ., 8230           " elipsis (…)
endif

" ---- code formatting ----
set autoindent              " automatically indent based on current line

function! s:CLangFormatting()
  " use C-like language indentation
  set cindent
  set cinoptions=:0,l1,g0,N-s,t0,(0,u0

  " tweak comment leaders to align properly
  set comments=sl:/*,mb:\ *,elx:\ */,://

  " tweak include path handling
  set path=.,/usr/include,/usr/local/include,,src/

  " Use :GNUFormat to setup formatting behaviour amenable to GNU style
  command! GNUFormat :setlocal cinoptions=>2s,n-1s,{s,^-1s,:1s,=1s,g0,h1s,t0,+1s,(0,u0,w1,m1 noexpandtab shiftwidth=2 softtabstop=2 tabstop=8

  " Use :LLVMFormat to setup formatting behaviour ammenable to LLVM style
  command! LLVMFormat :setlocal cinoptions=:0,g0,(0,Ws,l1 expandtab shiftwidth=2 softtabstop=2 tabstop=8
endfunction

function! s:AsmFormatting()
  " use 8-space indenting, hard tabs in assembly
  setlocal noexpandtab
  setlocal shiftwidth=8
  setlocal softtabstop=8
endfunction

if has("autocmd")
  execute "autocmd FileType " . join(s:CLangFileTypes, ",") . " call s:CLangFormatting()"
  execute "autocmd FileType asm call s:AsmFormatting()"
endif

autocmd FileType cmake setlocal cinoptions=(0 expandtab shiftwidth=2 softtabstop=2

" ---- files ----
if !has("unix")
  set viminfo+=n$HOME/.viminfo
endif

" enable spellchecking in git/svn commit messages by default
autocmd FileType gitcommit setlocal spell
autocmd FileTYpe svn setlocal spell

" ---- commands ----
if has("user_commands")
  command! -bang -complete=file -nargs=? W w<bang> <args>
  command! -bang -complete=file -nargs=? Wq wq<bang> <args>
  command! -bang -complete=file -nargs=? WQ wq<bang> <args>
  command! -bang Q q<bang>
endif

" make pasting into ex-mode more reasonable
cnoremap <c-v> <c-r>*
" support emacs-like bindings in ex-mode, since vi-style is not really possible
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" ---- per host configuration ----
let s:per_host_configuration = expand("~/.vim/settings")
if filereadable(s:per_host_configuration)
  execute ":source " . s:per_host_configuration
endif

