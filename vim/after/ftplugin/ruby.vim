if (exists("b:did_ftplugin_my_ruby"))
  finish
endif
let b:did_ftplugin_my_ruby = 1

"----------------------------------------------------
" インデント
"----------------------------------------------------
" オートインデントを有効にする
setlocal autoindent
" タブが対応する空白の数
setlocal tabstop=2
" タブやバックスペースの使用等の編集操作をするときに、タブが対応する空白の数
setlocal softtabstop=2
" インデントの各段階に使われる空白の数
setlocal shiftwidth=2
" タブを挿入するとき、代わりに空白を使う
setlocal expandtab

"----------------------------------------------------
" 文法チェック
"----------------------------------------------------
setlocal makeprg=ruby\ -c\ %
setlocal errorformat=%m\ in\ %f\ on\ line\ %l
