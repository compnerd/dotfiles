" gvimrc
" Saleem Abdulrasool <compnerd@compnerd.org>
" vim: set ts=3 sw=3 et nowrap:

scriptencoding utf-8

set guioptions=aegi
set guicursor=a:ver1

set columns=140
set lines=50

if has("unix")
   set guifont=Consolas\ 8,Envy\ Code\ R\ 8,Monaco\ 8,Cousine\ 8
else
   set guifont=Consolas:h8
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

