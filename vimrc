" vimrc
" Saleem Abdulrasool <compnerd@compnerd.org>
" vim: set ts=3 sw=3 et nowrap:

scriptencoding utf-8 " This file is in UTF-8

" ---- Terminal Setup ----
if (&term =~ "xterm") && (&termencoding == "")
   set termencoding=utf-8
endif

" ---- General Setup ----
set nocompatible           " Don't emulate vi's limitations

set encoding=utf-8         " Default encoding should always be UTF-8

set tabstop=3              " 3 spaces for tabs
set shiftwidth=3           " 3 spaces for indents
set smarttab               " tab next line based on current line
set expandtab              " spaces for tabs
set autoindent             " automatically indent next line based on current line
set smartindent            " indent next line based on current line

set incsearch              " enable incremental searching
set hlsearch               " hilight search matches
set ignorecase             " case insensitive search ...
set smartcase              " ... except when we dont want it
set infercase              " attempt to figure out the correct case

" unhighlight the search results when the keyboard is idle
autocmd CursorHold,CursorHoldI * nohls | redraw

set wildmenu               " menu on completion please
set wildmode=longest,full  " match the longest substring, complete with first
set wildignore=*.o,*~      " ignore temporary files in wildmenu

set scrolloff=3            " show 3 lines of context when scrolling
set sidescrolloff=2        " show 2 columns of context when scrolling

set hidden                 " allow flipping of buffers without saving

set nomodeline             " modelines are insecure, see securemodelines

set textwidth=80           " wrap at 80 character boundary by default
set linebreak              " display long lines wrapped at word boundaries
let &showbreak = "↪ "      " continuation character

set virtualedit=block      " allow virtual editing in visual block mode

set lazyredraw             " prevent window updates during macro execution

" --- Syntax Highlighting ----
if &t_Co > 2 || has("gui_running")
   syntax on               " enable syntax highlighting
   syntax sync fromstart   " parse from the beginning to get accurate syntax highlighting
endif

" ---- Filetypes ----
filetype on          " Detect filetype by extensions
filetype indent on   " Enable indents based on extensions
filetype plugin on   " Load filetype plugins

" ---- Colour Schemes ----
set background=dark  " prefer dark backgrounds

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
   call LoadColourScheme("xoria256:wombat256:inkpot")
elseif &t_Co == 88 || &t_Co == 256
   call LoadColourScheme("inkpot:wombat256")
else
   call LoadColourScheme("elflord:zellner")
endif

" ---- Trailing/Bleeding Whitespace ----

" shamelessly stolen from Ciaran McCreesh <ciaran.mccreesh@gmail.com>
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

" ---- Status Line ----
set laststatus=2
set shortmess=atI
set statusline=Editing:\ %r%t%m\ %=Location:\ Line\ %l/%L\ \ Col:\ %v\ (%p%%)

" ---- Spell Checking ----
if (v:version >= 700)
   set spelllang=en_us  " US English spelling please
endif

" ---- Code Indexing (ctags/cscope) ----
set showfulltag         " show full tags when doing completion

" search for tags in parent directory, recursively
set tags=tags;/

if has("cscope")
   set csto=1           " check ctags before cscope

   set nocsverb
   if filereadable("cscope.out")
      cs add cscope.out
   endif
   set csverb

   if has("quickfix")
      set csqf=s-,c-,d-,i-,t-,e-
   endif

   " c -> calls ; d -> definition ; r -> references
   nmap <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
   nmap <leader>d :cs find g <C-R>=expand("<cword>")<CR><CR>
   nmap <leader>r :cs find s <C-R>=expand("<cword>")<CR><CR>
endif

" ---- Build Tools Setup ----
if filereadable("SConstruct")
   set makeprg=scons\ -Q
endif

" ---- Restore Cursor Location ----
autocmd BufReadPost *
   \ if line("'\"") > 0 && line("'\"") <= line("$") |
   \  exe "normal g'\"" |
   \ endif

" ---- Key Mappings ----

" line numbers
nmap <silent> <F12> :silent set number!<CR>
imap <silent> <F12> <C-O>:silent set number!<CR>

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
fun! CAbbrev()
   iab #i #include
   iab #I #include

   iab #d #define
   iab #D #define

   iab #e #endif
   iab #E #endif
endfun

autocmd FileType c,cpp :call CAbbrev()

digraph ., 8230               " elipsis (…)

