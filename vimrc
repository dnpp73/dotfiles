"----------------------------------------------------
" 基本的な設定
"----------------------------------------------------
" viとの互換性をとらない(vimの独自拡張機能を使う為)
set nocompatible
" 改行コードの自動認識
set fileformats=unix,dos,mac
" ビープ音を鳴らさない
set vb t_vb=
" バックスペースキーで削除できるものを指定
" indent  : 行頭の空白
" eol     : 改行
" start   : 挿入モード開始位置より手前の文字
set backspace=indent,eol,start

"----------------------------------------------------
" バックアップ関係
"----------------------------------------------------
" バックアップをとらない
set nobackup
" ファイルの上書きの前にバックアップを作る
" (ただし、backup がオンでない限り、バックアップは上書きに成功した後削除される)
set writebackup
" バックアップをとる場合
"set backup
" バックアップファイルを作るディレクトリ
"set backupdir=~/.vimbackup
" スワップファイルを作るディレクトリ
"set directory=~/.vimswap
" crontabの編集の時に困るので
set backupskip=/tmp/*,/private/tmp/*

"----------------------------------------------------
" 検索関係
"----------------------------------------------------
" コマンド、検索パターンを100個まで履歴に残す
set history=100
" 検索の時に大文字小文字を区別しない
set ignorecase
" 検索の時に大文字が含まれている場合は区別して検索する
set smartcase
" 最後まで検索したら先頭に戻る
set wrapscan
" インクリメンタルサーチを使わない
set noincsearch

"----------------------------------------------------
" 表示関係
"----------------------------------------------------
" タイトルをウインドウ枠に表示する
set title
" 行番号を表示
set number
" ルーラーを表示
set ruler
" タブ文字を CTRL-I で表示し、行末に $ で表示しする
set list
" 不可視文字をカスタマイズする
" set listchars=tab:→,trail:·,eol:￢,extends:»,precedes:«,nbsp:%,space:·
" set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%,space:-
set listchars=tab:￫･,trail:･,eol:¬,extends:»,precedes:«,nbsp:%,space:･
" 入力中のコマンドをステータスに表示する
set showcmd
" ステータスラインを常に表示
set laststatus=2
" タブを常に表示"
set showtabline=2
" 括弧入力時の対応する括弧を表示
set showmatch
" 対応する括弧の表示時間を2にする
set matchtime=2
" シンタックスハイライトを有効にする
syntax on
" 検索結果文字列のハイライトを無効にする
set nohlsearch
" コメント文の色を変更
highlight Comment ctermfg=DarkCyan
" コマンドライン補完を拡張モードにする
set wildmenu
" カーソル行を強調表示
set nocursorline

" 入力されているテキストの最大幅
" (行がそれより長くなると、この幅を超えないように空白の後で改行される)を無効にする
set textwidth=0
" ウィンドウの幅より長い行は折り返して、次の行に続けて表示する
set nowrap

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" ステータスラインに表示する情報の指定
set statusline=%n\:%y%F\ \|%{(&fenc!=''?&fenc:&enc).'\|'.&ff.'\|'}%m%r%=<%l/%L:%p%%>
" ステータスラインの色
highlight StatusLine   term=NONE cterm=NONE ctermfg=black ctermbg=white

" カラースキーム
" colorscheme desert
colorscheme xcodedarkhc
" 不可視文字の色の上書き
hi NonText    ctermbg=None ctermfg=59
hi SpecialKey ctermbg=None ctermfg=59

"----------------------------------------------------
" インデント
"----------------------------------------------------
" オートインデントを有効にする
set autoindent
" タブが対応する空白の数
set tabstop=4
" タブやバックスペースの使用等の編集操作をするときに、タブが対応する空白の数
set softtabstop=4
" インデントの各段階に使われる空白の数
set shiftwidth=4
" タブを挿入するとき、代わりに空白を使う
set expandtab
" C言語用のインデントだとか"
set cindent

"----------------------------------------------------
" 国際化関係
"----------------------------------------------------
" 文字コードの設定
" fileencodingsの設定ではencodingの値を一番最後に記述する
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,cp932,iso-2022-jp,ucs-2le,ucs-2,ucs-bom

"----------------------------------------------------
" オートコマンド
"----------------------------------------------------
if has("autocmd")
    " ファイルタイプ別インデント、プラグインを有効にする
    filetype plugin indent on

    " カーソル位置を記憶する
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    autocmd BufReadPost *     exe "normal g`\""
    autocmd BufReadPost * endif
endif

"----------------------------------------------------
" その他
"----------------------------------------------------
" バッファを切替えてもundoの効力を失わない
set hidden
" 起動時のメッセージを表示しない
set shortmess+=I

"----------------------------------------------------
" :TOhtml
"----------------------------------------------------
let g:use_xhtml = 1
let g:html_use_css = 1
let g:html_no_pre = 1

"----------------------------------------------------
" MacVim用
"----------------------------------------------------
if has('gui_macvim')
    " フォントの変更"
    "set guifont=Monaco:h14
    " ラインとカラム"
    "大きさ的なの
    set lines=50 columns=130
    " ツールバーっぽいの非表示"
    set guioptions-=T
    " ウィンドウの右側にスクロールバーを表示しない"
    set guioptions-=r
    " 縦に分割されたウィンドウの右側にスクロールバーを表示しない"
    set guioptions-=R
    " ウィンドウの左側にスクロールバーを表示しない"
    set guioptions-=l
    " 縦に分割されたウィンドウの左側にスクロールバーを表示しない"
    set guioptions-=L
    " 水平スクロールバーを表示しない"
    set guioptions=-b
    " tab を GUI で"
    set guioptions=e
    " アンチエイリアス有効
    set antialias
    " カーソルの点滅を止める"
    " set guicursor=a:blinkon0
    " フルスクリーン
    " set fuoptions=maxvert,maxhorz
    " au GUIEnter * set fullscreen
endif

"----------------------------------------------------
" nmap
"----------------------------------------------------
nmap <space>W :set nowrap<CR>
nmap <space>w :set wrap<CR>
nmap <Space>b :ls<CR>:buffer
nmap <Space>v :vsplit<CR><C-w><C-w>:ls<CR>:buffer

"----------------------------------------------------
" Mouse and Clipboard
"----------------------------------------------------
set mouse=a
set clipboard+=unnamed

