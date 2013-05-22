if (exists("b:did_ftplugin_my_html"))
  finish
endif
let b:did_ftplugin_my_html = 1

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

compiler tidy
setlocal makeprg=tidy\ -raw\ -quiet\ -errors\ %
nmap <buffer> <silent> tidy :!tidy -iq -raw -m "%"<CR>
