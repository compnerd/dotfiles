# .gdbinit
# Copyright 2009 Saleem Abdulrasool <compnerd@compnerd.org>

# prompt (the extra space is intentional)
set prompt \001\033[01;32mgdb\001\033[01;34m\002 $\001\033[00;00m\002 

# history
set history save on
set history filename ~/.gdb/history

# pretty printing
set print array on
set print pretty on
set print asm-demangle on

