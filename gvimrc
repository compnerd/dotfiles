" gvimrc
" Saleem Abdulrasool <compnerd@compnerd.org>
" vim: set ts=3 sw=3 et nowrap:

scriptencoding utf-8

set guioptions=aegi
set guicursor=a:ver1

set columns=89
set lines=50

if has('gui_macvim')
   set guifont=Monaco:h10
elseif has("unix")
   set guifont=Consolas\ 8,Envy\ Code\ R\ 8,Monaco\ 8,Cousine\ 8
else
   set guifont=Consolas:h10
endif

if has('gui_macvim')
   set transparency=12
endif

if has('gui_macvim')
   nmap <D-1> 1gt
   imap <D-1> <C-O>1gt

   nmap <D-2> 2gt
   imap <D-2> <C-O>1gt

   nmap <D-3> 3gt
   imap <D-3> <C-O>3gt

   nmap <D-4> 4gt
   imap <D-4> <C-O>4gt

   nmap <D-5> 5gt
   imap <D-5> <C-O>5gt

   nmap <D-6> 6gt
   imap <D-6> <C-O>6gt

   nmap <D-7> 7gt
   imap <D-7> <C-O>7gt

   nmap <D-8> 8gt
   imap <D-8> <C-O>8gt

   nmap <D-9> 9gt
   imap <D-9> <C-O>9gt
endif

" ---- man page viewer ----
source $VIMRUNTIME/ftplugin/man.vim

fun! ShowManPage(sct,page)
   if a:sct == 0
      exe ':Man ' . a:page
   else
      exe ':Man ' . a:sct . ' ' . a:page
   endif
endfun

nmap <silent> K :<C-U>call ShowManPage(v:count, expand("<cword>"))<CR>

autocmd FileType man set nolist

