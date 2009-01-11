" vimrc
" Saleem Abdulrasool <compnerd@compnerd.org>
" vim: set ts=3 sw=3 et nowrap:

scriptencoding utf-8       " This file is in UTF-8

" ---- Terminal Setup ----
if (&term =~ "xterm") && (&termencoding == "")
   set termencoding=utf-8
endif

" ---- General Setup ----
set nocompatible           " Don't emulate vi's limitations
set encoding=utf-8         " Default encoding should always be UTF-8
set tabstop=3              " 3 spaces for tabs
set shiftwidth=3           " 3 spaces for indents
set smarttab               " Tab next line based on current line
set expandtab              " Spaces for indentation
set autoindent             " Automatically indent next line
set smartindent            " Indent next line based on current line
set linebreak              " Display long lines wrapped at word boundaries
set incsearch              " Enable incremental searching
set hlsearch               " Highlight search matches
set ignorecase             " Ignore case when searching
set infercase              " Attempt to figure out the correct case
set showfulltag            " Show full tags when doing completion
set virtualedit=block      " Only allow virtual editing in block mode
set lazyredraw             " Lazy Redraw (faster macro execution)
set wildmenu               " Menu on completion please
set wildmode=longest,full  " Match the longest substring, complete with first
set wildignore=*.o,*~      " Ignore temp files in wildmenu
set scrolloff=3            " Show 3 lines of context during scrolls
set sidescrolloff=2        " Show 2 columns of context during scrolls
set backspace=2            " Normal backspace behavior
set textwidth=80           " Break lines at 80 characters
set hidden                 " Allow flipping of buffers without saving
set nomodeline             " modelines are insecure, use securemodelines

" ---- Filetypes ----
filetype on                " Detect filetype by extension
filetype indent on         " Enable indents based on extensions
filetype plugin on         " Load filetype plugins

" ---- Folding ----
fun! WideFold()
   if winwidth(0) > 90
      setlocal foldcolumn=1
   else
      setlocal foldcolumn=0
   endif
endfun

autocmd BufEnter * :call WideFold()

" ---- Spelling ----
if (v:version >= 700)
   set spelllang=en_us        " US English Spelling please

   " Toggle spellchecking with F10
   nmap <silent> <F10> :silent set spell!<CR>
   imap <silent> <F10> <C-O>:silent set spell!<CR>
endif

" Always display a pretty statusline
set title
set laststatus=2
set shortmess=atI
set statusline=Editing:\ %r%t%m\ %=Location:\ Line\ %l/%L\ \ Col:\ %c\ (%p%%)


" Shamelessly stolen from Ciaran McCreesh <ciaranm@ciaranm.org>
fun! LoadColorScheme(schemes)
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

" We like dark backgrounds
set background=dark

" Select colorschemes based on how we are running
if has("gui_running")
   call LoadColorScheme("molokai:moria:inkpot:zenburn:vividchalk:darkspectrum")
elseif &t_Co == 88 || &t_Co == 256
   call LoadColorScheme("inkpot:vividchalk")
else
   call LoadColorScheme("elflord:zellner")
endif

" Show trailing whitespace visually
" Shamelessly stolen from Ciaran McCreesh <ciaranm@gentoo.org>
if (&termencoding == "utf-8") || has("gui_running")
   if v:version >= 700
      set list listchars=tab:»·,trail:·,extends:…,nbsp:‗
   else
      set list listchars=tab:»·,trail:·,extends:…
   endif
else
   if v:version >= 700
      set list listchars=tab:>-,trail:.,extends:>,nbsp:_
   else
      set list listchars=tab:>-,trail:.,extends:>
   endif
endif

" Dont copy the listchars when copying
set mouse=nvi

" Get rid of the annoying UI
if has("gui")
   set guioptions-=t       " Disable menu tear-offs
   set guioptions-=T       " Disable the toolbar
   set guioptions-=m       " Disable the menu
   set guioptions-=R       " Disable the (right) scrollbar
   set guioptions-=r       " Disable the (right) scrollbar
   set guioptions-=l       " Disable the (left) scrollbar
   set guioptions-=L       " Disable the (left) scrollbar
endif

" unhighlight search when idle
autocmd CursorHold * nohls | redraw

" always refresh syntax from the start
autocmd BufEnter * syntax sync fromstart

" subversion commit messages need not be backed up
autocmd BufRead svn-commit.tmp :setlocal nobackup

" mutt does not like UTF-8
autocmd BufRead,BufNewFile *
   \ if &ft == 'mail' | set fileencoding=iso8859-1 | endif

" fix up procmail rule detection
autocmd BufRead procmailrc :setfiletype procmail

" sc files are scons files
autocmd BufRead,BufNewFile *.sc set ft=python
autocmd BufRead,BufNewFile SCons* set ft=python

" ---- cscope/ctags setup ----
if has('cscope') && filereadable('/usr/bin/cscope')
   " Search cscope and ctags, in that order
   set cscopetag
   set cscopetagorder=0

   set nocsverb
   if filereadable('cscope.out')
      cs add cscope.out
   endif
   set csverb
endif

" ---- Key Mappings ----

" improved lookup
fun! GoDefinition()
   let pos = getpos(".")
   normal! gd
   if getpos(".") == pos
      exe "tag " . expand("<cword>")
   endif
endfun
nmap <C-]> :call GoDefinition()<CR>

" Shortcuts
fun! <SID>cabbrev()
   iab #i #include
   iab #I #include

   iab #d #define
   iab #D #define

   iab #e #endif
   iab #E #endif
endfun
autocmd FileType c,cpp :call <SID>cabbrev()

" make tab reindent in normal mode
autocmd FileType c,cpp,cs,java nmap <Tab> =0<CR>

" tab in visual mode is for indentation
vmap <silent> <Tab> >gv
vmap <silent> <S-Tab> <gv

" Page using space
noremap <Space> <C-F>

" shifted arrows are stupid
inoremap <S-Up> <C-O>gk
noremap  <S-Up> gk
inoremap <S-Down> <C-O>gj
noremap  <S-Down> gj

" vK is stupid
vmap K k

if has("gui")
   source $VIMRUNTIME/ftplugin/man.vim

   fun! ShowManPage(sct,page)
      if a:sct == 0
         exe ':Man ' . a:page
      else
         exe ':Man ' . a:sct . ' ' . a:page
      endif
   endfun

   nmap <silent> K :<C-U>call ShowManPage(v:count, expand("<cword>"))<CR>

   autocmd FileType man set nolist ts=8
else
   nmap K K<CR>
endif

" Toggle numbers with F12
nmap <silent> <F12> :silent set number!<CR>
imap <silent> <F12> <C-O>:silent set number!<CR>

" Don't force column 0 for #
inoremap # X<BS>#

" Add a simple way to add a copyright notice
inoremap <leader>c Copyright <c-r>=strftime('%Y')<CR> Saleem Abdulrasool <compnerd@compnerd.org><CR>

autocmd BufReadPost *
   \ if line("'\"") > 0 && line("'\"") <= line("$") |
   \  exe "normal g'\"" |
   \ endif

