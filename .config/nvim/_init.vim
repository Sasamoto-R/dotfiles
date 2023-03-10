set number             "行番号を表示
set autoindent         "改行時に自動でインデントする
set tabstop=2          "タブを何文字の空白に変換するか 
set shiftwidth=2       "自動インデント時に入力する空白の数
set expandtab          "タブ入力を空白に変換
set clipboard=unnamed  "yank した文字列をクリップボードにコピー
set hls                "検索した文字をハイライトする
set termguicolors      "TrueColor対応
set background=dark    "backgroundカラー設定
set helplang=ja

" terminal ノーマルモード移行<Esc>キーで出来る様にする
tnoremap <Esc> <C-\><C-n>

call plug#begin('$HOME/.local/share/nvim/plugged')
Plug 'vim-airline/vim-airline' "ステータスライン
Plug 'vim-airline/vim-airline-themes' "ステータスライン
Plug 'airblade/vim-gitgutter' "gitの差分表示
Plug 'rust-lang/rust.vim'
Plug 'ryanoasis/vim-devicons' "ファイルツリーのアイコン（いらないかも）
Plug 'lambdalisue/fern.vim' "ファイルツリー
Plug 'lambdalisue/fern-renderer-nerdfont.vim' "fernでのアイコン表示
Plug 'lambdalisue/nerdfont.vim' "アイコン全般
Plug 'lambdalisue/glyph-palette.vim' "filer icon color sheme
Plug 'sainnhe/gruvbox-material' "color sheme
Plug 'neoclide/coc.nvim', {'branch': 'release'} "自動補完
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' "fazzy finder
Plug 'yuki-yano/fzf-preview.vim'

""========================================="
""ddc.vim plugin ※まぁここはたぶん使わない
""========================================="
"Plug 'Shougo/ddc.vim'
"Plug 'Shougo/ddc-around'
"Plug 'Shougo/ddc-matcher_head'
"Plug 'Shougo/ddc-matcher_length'
"Plug 'Shougo/ddc-sorter_rank'
"Plug 'Shougo/ddc-nvim-lsp'
"Plug 'Shougo/pum.vim'
"Plug 'Shougo/neco-vim'
"Plug 'Shougo/ddc-cmdline-history'
"Plug 'tani/ddc-fuzzy'

call plug#end()

"========================================="
" plugin Manager: vim-plug setting
"========================================="

" vim-plug なかったら落としてくる
if empty(glob('$HOME/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" 足りないプラグインがあれば :PlugInstall を実行
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

"========================================="
" plugin Fern Setting
"========================================="

" Show hidden files
let g:fern#default_hidden=1
" Show icon
let g:fern#renderer = 'nerdfont'

" Show file tree with Ctrl + n
nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=30<CR>

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

"========================================="
" plugin fzf-preview setting
"========================================="

let $BAT_THEME                     = 'gruvbox-dark'
let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'gruvbox-dark'

nnoremap <silent> <Plug>(ff)r  <Cmd>CocCommand fzf-preview.ProjectFiles<CR>
nnoremap <silent> <Plug>(ff)s  <Cmd>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> <Plug>(ff)gg <Cmd>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> <Plug>(ff)b  <Cmd>CocCommand fzf-preview.Buffers<CR>
nnoremap          <Plug>(ff)f  :<C-u>CocCommand fzf-preview.ProjectGrep --add-fzf-arg=--exact --add-fzf-arg=--no-sort<Space>

nnoremap <silent> <Plug>(lsp)q  <Cmd>CocCommand fzf-preview.CocCurrentDiagnostics<CR>
nnoremap <silent> <Plug>(lsp)rf <Cmd>CocCommand fzf-preview.CocReferences<CR>
nnoremap <silent> <Plug>(lsp)d  <Cmd>CocCommand fzf-preview.CocDefinition<CR>
nnoremap <silent> <Plug>(lsp)t  <Cmd>CocCommand fzf-preview.CocTypeDefinition<CR>
nnoremap <silent> <Plug>(lsp)o  <Cmd>CocCommand fzf-preview.CocOutline --add-fzf-arg=--exact --add-fzf-arg=--no-sort<CR>

"========================================="
" plugin coc.nvim setting
"========================================="

let g:coc_global_extensions = ['coc-tsserver', 'coc-eslint', 'coc-prettier', 'coc-git', 'coc-fzf-preview', 'coc-lists']

inoremap <silent> <expr> <C-Space> coc#refresh()

nnoremap <silent> K             <Cmd>call <SID>show_documentation()<CR>
nmap     <silent> <Plug>(lsp)rn <Plug>(coc-rename)
nmap     <silent> <Plug>(lsp)a  <Plug>(coc-codeaction-cursor)

function! s:coc_typescript_settings() abort
  nnoremap <silent> <buffer> <Plug>(lsp)f :<C-u>CocCommand eslint.executeAutofix<CR>:CocCommand prettier.formatFile<CR>
endfunction

augroup coc_ts
  autocmd!
  autocmd FileType typescript,typescriptreact call <SID>coc_typescript_settings()
augroup END

function! s:show_documentation() abort
  if index(['vim','help'], &filetype) >= 0
    execute 'h ' . expand('<cword>')
  elseif coc#rpc#ready()
    call CocActionAsync('doHover')
  endif
endfunction
"========================================="
" setting
"========================================="
filetype plugin indent on

syntax enable
colorscheme gruvbox-material
let g:airline_theme = 'wombat'
" powerline enable(最初に設定しないとダメ)
let g:airline_powerline_fonts = 1
" タブラインを表示
let g:airline#extensions#tabline#enabled = 1
" 選択行列の表示をカスタム(デフォルトだと長くて横幅を圧迫するので最小限に)
let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
" gitのHEADから変更した行の+-を非表示(vim-gitgutterの拡張)
let g:airline#extensions#hunks#enabled = 0

"========================================="
" plugin Manager: dein.vim setting
" deinが上手く動作しない場合、:call dein#update()と
" :call dein#recache_runtimepath()を実行する
"========================================="
"if &compatible
"  set nocompatible
"endif
"
"" プラグインが実際にインストールされるディレクトリ
"let s:dein_dir = expand('~/.cache/dein')
""dein.vim 本体
"let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
""dein.vim がなければ github から落としてくる
"if &runtimepath !~# '/dein.vim'
"  if !isdirectory(s:dein_repo_dir)
"    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
"  endif
"  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
"endif
"
"" 設定開始
"if dein#load_state(s:dein_dir)
"  call dein#begin(s:dein_dir)
"
"  " プラグインリストを収めた TOML ファイル
"  " 予め TOML ファイルを用意しておく
"  let g:rc_dir    = expand('~/.config/nvim/rc')
"  let s:toml      = g:rc_dir . '/dein.toml'
"  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
"
"   " TOML を読み込み、キャッシュしておく
"  call dein#load_toml(s:toml,      {'lazy': 0})
"  call dein#load_toml(s:lazy_toml, {'lazy': 1})
"
"  call dein#end()
"  call dein#save_state()
"endif
"
"  "もし、未インストールものものがあったらインストール
"if dein#check_install()
"  call dein#install()
"endif
"
"let g:dein#install_max_processes = 16

"========================================="
"Auto Commands
"========================================="
augroup vimrc
  " [NeovimのTerminalモードをちょっと使いやすくする](https://zenn.dev/ryo_kawamata/articles/improve-neovmi-terminal)
  autocmd TermOpen * startinsert

augroup END
