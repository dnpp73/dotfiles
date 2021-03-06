if (exists("b:did_ftplugin_my_python"))
  finish
endif
let b:did_ftplugin_my_python = 1

"----------------------------------------------------
" インデント
"----------------------------------------------------
" オートインデントを有効にする
setlocal autoindent
" タブが対応する空白の数
setlocal tabstop=4
" タブやバックスペースの使用等の編集操作をするときに、タブが対応する空白の数
setlocal softtabstop=4
" インデントの各段階に使われる空白の数
setlocal shiftwidth=4
" タブを挿入するとき、代わりに空白を使う
setlocal expandtab
