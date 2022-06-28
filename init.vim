"------	auto close empty buffer when leaving it
autocmd BufUnload * if bufexists('%') && bufname('%')=='' 
\ && getbufinfo('%')[0].changed 
\| exe 'bw!' | endif

"------	cd into the dir of arguments
autocmd VimEnter * execute 'cd '.FindArgDir()
function FindArgDir() abort
	if len(argv()) != 1 | return getcwd() |endif
  if isdirectory(argv()[0]) | return argv()[0] |endif
	return fnamemodify(argv()[0], ':p:h')
endfunction!

"------ Use Correct Colors
set t_Co=256
"set termguicolors 
"highlight Normal ctermbg=NONE
"highlight nonText ctermbg=NONE
syntax on
filetype on

"------	line number
" set nu
set rnu
set nuw=1
set signcolumn=yes:1
set cursorline

"------	intentation
filetype plugin indent on
set tabstop=2
set shiftwidth=4

"------	Mouse support
set mouse=a

" - - - - - - - - - shortcut - - - - - - - - - - - -

"------	define leader
let mapleader=" "

"------	quick save
noremap <leader>w :w<CR>

"------	cpy-pst system buffer
"nnoremap <C-y> "+y
"vnoremap <C-y> "+y
"xnoremap <C-y> "+y
"nnoremap <C-p> "+gP
"vnoremap <C-p> "+gP
"xnoremap <C-p> "+gP

"------ shift tab to exit insert mode
inoremap <s-tab> <esc>

"------	Ctrl/Alt J K
xnoremap <S-J> :m+<CR>
xnoremap <S-K> :m-2<CR>
nnoremap <C-k> ddkP
nnoremap <C-j> ddp
nnoremap <M-k> 2<c-y>
nnoremap <M-j> 2<c-e>

"------	Insert new lines in normal mode
nnoremap <leader>o :call append(line('.'), '')<CR>j
nnoremap <leader>O :call append(line('.')-1, '')<CR>k

"------	help
nnoremap <leader>hv :vert bo help 
nnoremap <leader>hh :help 

"------	Window Navigation
nnoremap <C-h> <c-w>h 
nnoremap <C-l> <c-w>l 

"------	Window Resize
nnoremap <C-Right> <c-w>2>
nnoremap <C-Left> <c-w>2<
nnoremap <C-Up> <c-w>2+
nnoremap <C-Down> <c-w>2-

"------	open vim config
nnoremap <leader>cc :e $MYVIMRC<CR>

"------	Toggle highlight search
nnoremap <Leader>il :set cursorline!<cr>
nnoremap <Leader>ic :set cursorcolumn!<cr>
nnoremap <Leader>ih :set hlsearch!<cr>
"nnoremap <silent><expr> <Leader>i (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

"------	Toggle fullscreen current window
let s:fullscreen=0
nnoremap <leader>f :call ToggleFullscreen()<CR>
function! ToggleFullscreen()
    let s:fullscreen = !s:fullscreen
    if s:fullscreen
        execute 'tab split'
    else
        execute 'tabc'
    endif
endfunction

"  *  *  *  *  *  *  *  *  *  *  *  *  *	*  *  *  *  *  *  *  *
"  *  *  *  *  *  *  *  *  *  Plugins  *  *  *  *  *  *  *  *  *
"  *  *  *  *  *  *  *  *  *  *  *  *  *	*  *  *  *  *  *  *  *
call plug#begin()

"------	Shortcut cheatsheet
Plug 'folke/which-key.nvim'
set timeoutlen=500

"------	colorscheme manager
Plug 'xolox/vim-colorscheme-switcher'
Plug 'xolox/vim-misc' "depencie
Plug 'Taverius/vim-colorscheme-manager'
"nnoremap <S-PageUp> :NextColorScheme<CR>
"nnoremap <S-PageDown> :PrevColorScheme<CR>
"nnoremap <C-PageDown> :set background=light<CR>
"nnoremap <C-PageUp> :set background=dark<CR>
nnoremap <leader>cn :NextColorScheme<CR>
nnoremap <leader>cb :PrevColorScheme<CR>
nnoremap <leader>ck :set background!<CR>
nnoremap <leader>cj :set termguicolors!<CR>

"------	minimal screen
Plug 'junegunn/goyo.vim'

"------	Auto completion
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clangd-completer' }
imap <silent> <C-space> <Plug>(YCMToggleSignatureHelp)
let g:ycm_global_ycm_extra_conf = "~/.local/share/nvim/plugged/YouCompleteMe/.ycm_extra_conf.py"
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_max_num_candidates = 20
let g:ycm_semantic_triggers =  {'c,cpp,objc': [ 're!\w{2}', '_' ],}
let g:ycm_semantic_triggers =  { 'json': [ 're!\w' ],}
let g:ycm_error_symbol = '*'
let g:ycm_warning_symbol = '*'

"------	Auto Pairs
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsMultilineClose=0

"------	Quick Comment
Plug 'preservim/nerdcommenter'
let g:nerdcreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
nnoremap <leader>n <plug>NERDCommenterToggle
xnoremap <leader>n <plug>NERDCommenterToggle

"------	Nerd Tree
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'PhilRunninger/nerdtree-visual-selection'
nnoremap <leader>vv :NERDTreeToggle<CR>
nnoremap <leader>vc :NERDTreeToggle %<CR>
let NERDTreeMapChangeRoot='L'
let g:NERDTreeWinSize=24
"------ close extra tabs
autocmd VimEnter * wincmd l | let s:main_bufnr = bufnr('%')| let s:fname = expand('%')|
\ if s:fname[0:8] ==# 'NERD_tree'| exe bufwinnr(s:main_bufnr) . "wincmd w" |bw |endif
"------ open at startup
autocmd VimEnter * NERDTree | wincmd p
"------ If another buffer tries to replace NERDTree, put it in the other window,
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' 
\ && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
\ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
"------ Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 
\ && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
"------ Open the existing NERDTree on each new tab.
autocmd BufWinEnter * silent NERDTreeMirror
"------ Start NERDTree when Vim starts with a directory argument.
"au VimEnter NERD_tree_1 enew | execute 'NERDTree '.argv()[0]
"------ Start NERDTree when Vim starts with a directory argument.
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
"	\ execute 'NERDTree' argv()[0] | enew | execute 'cd '.argv()[0] | endif


"------	Sessions
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
"Plug 'xolox/vim-session'
let g:prosession_on_startup = 0
nnoremap <leader>ss :Prosession<CR>
nnoremap <leader>so :Prosession 
nnoremap <leader>sc :ProsessionClean<CR>
nnoremap <leader>sx :ProsessionDelete<CR>
nnoremap <leader>sd :ProsessionDelete 
"Plug 'dominickng/fzf-session.vim'
"let g:prosession_dir = '~/.vim/session/'
"let g:fzf_session_path = g:prosession_dir
"nnoremap <leader>sp :Sessions<CR>

"------ Buffers
"Plug 'moll/vim-bbye'

"------ Tab bar
nnoremap <leader><Tab> :b#<CR>
"Plug 'drmingdrmer/vim-tabbar'
Plug 'pacha/vem-tabline'
"Plug 'bagrat/vim-buffet'
"Plug 'ap/vim-buftabline'
nnoremap <leader>b<tab> :b#<cr>
nnoremap <leader>bn :bn<cr>
nnoremap <leader>bb :bp<cr>
nnoremap <leader>bd :bd<cr>
nnoremap <leader>bx :bw<cr>
nnoremap <leader>bl :ls<cr>
nnoremap <leader>bj :ls!<cr>
nnoremap <leader>bw :ls!<cr>:bw 

"------	Fuzzy Find
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
nnoremap <C-p> :Files<Cr>
"let g:fzf_layout = { 'window': '~40%' }

"------	Terminal
Plug 'voldikss/vim-floaterm'
"Plug 'kassio/neoterm'
"Plug 'tc50cal/vim-terminal'
nnoremap <leader>tt :TerminalTab bash<CR>
nnoremap <leader>tr :TerminalVSplit bash<CR>
nnoremap <leader>td :TerminalSplit bash<CR>
let g:floaterm_keymap_toggle = '<C-T>'

"------ Git integration
Plug 'tpope/vim-fugitive'
nnoremap <leader>g :Goyo<cr>

"------ color scheme (a bit too much)
Plug 'marcopaganini/mojave-vim-theme'
Plug 'cliuj/vim-dark-meadow'
Plug 'bluz71/vim-moonfly-colors'
Plug 'slugbyte/yuejiu'
Plug 'justb3a/vim-smarties'
Plug 'noprompt/lite-brite'
Plug 'vim-scripts/abbott.vim'
Plug 'bignimbus/pop-punk.vim'
Plug 'vim-scripts/rootwater.vim'
Plug 'kitten/vim-adventurous'
Plug 'sabrinagannon/vim-garbage-oracle'
Plug 'adampasz/stonewashed-themes'
Plug 'Shadorain/shadotheme'
Plug 'evgenyzinoviev/vim-vendetta'
Plug 'vim-scripts/thinkpad.vim'
Plug 'jyalim/lichen'
Plug 'mikker/vim-colors-pap'
Plug 'jy-r/darkness_leaks'
Plug 'jdsimcoe/onedarkatom.vim'
Plug 'jhwheeler/fluidlan-vim'
Plug 'Aryansh-S/fastdark.vim'
Plug 'vim-scripts/vim-colors-pencil'
Plug 'ronwoch/hotline-vim'
Plug 'perfectspr/dracula-vim'
Plug 'vim-scripts/up.vim'
Plug 'vim-scripts/pf_earth.vim'
Plug 'ojiry/bolero.vim'
Plug 'vim-scripts/darknight256.vim'
Plug 'nonetallt/vim-neon-dark'
Plug 'vim-scripts/blue_sky'
Plug 'romainl/vim-dichromatic'
Plug 'schickele/vim-nachtleben'
Plug 'heraldofsolace/nisha-vim'
Plug 'szorfein/darkest-space'

call plug#end()

"------ colorscheme after include call
colorscheme fastdark


lua << EOF
  require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
