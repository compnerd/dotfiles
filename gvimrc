" gvimrc
" Saleem Abdulrasool <compnerd@compnerd.org>
" vim: set ts=3 sw=3 et nowrap:

scriptencoding utf-8

set guioptions=aegi
set guicursor=a:ver1
set guifont=envy\ code\ r\ 8,consolas\ 8,monaco\ 8

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

autocmd FileType man set nolist ts=8

