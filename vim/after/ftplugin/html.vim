if (exists("b:did_ftplugin_my_html"))
  finish
endif
let b:did_ftplugin_my_html = 1

"----------------------------------------------------
" ����ǥ��
"----------------------------------------------------
" �����ȥ���ǥ�Ȥ�ͭ���ˤ���
setlocal autoindent
" ���֤��б��������ο�
setlocal tabstop=2
" ���֤�Хå����ڡ����λ��������Խ����򤹤�Ȥ��ˡ����֤��б��������ο�
setlocal softtabstop=2
" ����ǥ�Ȥγ��ʳ��˻Ȥ������ο�
setlocal shiftwidth=2
" ���֤���������Ȥ�������˶����Ȥ�
setlocal expandtab

compiler tidy
setlocal makeprg=tidy\ -raw\ -quiet\ -errors\ %
nmap <buffer> <silent> tidy :!tidy -iq -raw -m "%"<CR>
