" ref: https://vi.stackexchange.com/a/169/15292
function! s:handle_large_file() abort
  let g:large_file = 10485760 " 10MB
  let f = expand("<afile>")

  if getfsize(f) > g:large_file || getfsize(f) == -2
    set eventignore+=all
    " turning off relative number helps a lot
    set norelativenumber
    setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1
  else
    set eventignore-=all relativenumber
  endif
endfunction

augroup LargeFile
  autocmd!
  autocmd BufReadPre * call s:handle_large_file()
augroup END
