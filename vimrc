" vimrc
" Saleem Abdulrasool <compnerd@compnerd.org>
" vim: set ts=8 sts=4 sw=4 et nowrap:

scriptencoding utf-8 " This file is in UTF-8

" ---- Terminal Setup ----
if (&term =~ "xterm") && (&termencoding == "")
    set termencoding=utf-8
endif

" ---- General Setup ----
set nocompatible            " Don't emulate vi's limitations

set encoding=utf-8          " Default encoding should always be UTF-8

set tabstop=8               " 8 spaces for tabs
set shiftwidth=4            " 4 spaces for indenting
set softtabstop=4           " 4 spaces for indenting
set smarttab                " tab next line based on current line
set expandtab               " spaces for tabs
set autoindent              " automatically indent next line based on current line
set smartindent             " indent next line based on current line

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

set nomodeline              " modelines are insecure, see securemodelines

set textwidth=80            " wrap at 80 character boundary by default
set linebreak               " display long lines wrapped at word boundaries
let &showbreak = "↪ "       " continuation character

set virtualedit=block       " allow virtual editing in visual block mode

set lazyredraw              " prevent window updates during macro execution
set ttyfast                 " use advanced tty features for smoother drawing

" ---- Syntax Highlighting ----
syntax on                   " enable syntax highlighting
syntax sync fromstart       " parse from the beginning to get accurate syntax highlighting

" ---- Filetypes ----
filetype on                 " Detect filetype by extensions
filetype indent on          " Enable indents based on extensions
filetype plugin on          " Load filetype plugins

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
    call LoadColourScheme("lucius:xoria256:wombat256:inkpot")
elseif (&t_Co == 88) || (&t_Co == 256)
    call LoadColourScheme("lucius:xoria256:wombat256:inkpot")
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
set statusline=Editing:\ %r%t%m\ %=Location:\ Line\ %l/%L\ \ Col:\ %v\ (%p%%)

" ---- Spell Checking ----
if (v:version >= 700)
    set spelllang=en_us     " US English spelling please
endif

" ---- Code Folding ----
set fillchars=fold:\        " no fill characters for folds
let javascript_fold = 1     " enable folding for JavaScript

" ---- Code Indexing (ctags/cscope) ----
set tags=tags;/             " search for tags in parent directory, recursively
set showfulltag             " show full tags when doing completion
set tagrelative             " paths are relative to tag file

if has("cscope")
    set cscopetag           " search both ctags and cscope
    set cscopetagorder=1    " check ctags before cscope

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

" ---- Text Width Marker ----
if (v:version >= 703)
    set colorcolumn=+1
    highlight ColorColumn ctermbg=88 guibg=#5f0000
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
function! s:iabbrev()
    iabbrev #i #include
    iabbrev #I #include

    iabbrev #d #define
    iabbrev #D #define

    iabbrev #e #endif
    iabbrev #E #endif
endfunction

autocmd FileType c,cpp,c.doxygen,cpp.doxygen call s:iabbrev()

if has("digraph")
    digraph ., 8230        " elipsis (…)
endif

