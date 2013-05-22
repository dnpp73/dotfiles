if (exists("b:did_ftplugin_my_php"))
  finish
endif
let b:did_ftplugin_my_php = 1

setlocal makeprg=php\ -l\ %
setlocal errorformat=%m\ in\ %f\ on\ line\ %l
