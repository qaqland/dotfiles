vim9script

set nocompatible
source $VIMRUNTIME/defaults.vim

packadd! nohlsearch
packadd! comment
packadd! editorconfig

if exists('g:loaded_plug')
	plug#begin()

	Plug 'yegappan/lsp'
	Plug 'junegunn/fzf.vim'
	Plug 'airblade/vim-gitgutter'

	plug#end()
endif

set termguicolors
colorscheme lunaperche
# set background=dark
# colorscheme habamax

# for lunaperche in lsp highlight
hi! link Function Statement

set number
set relativenumber
set colorcolumn=80,100
set signcolumn=yes
set laststatus=1
# set noswapfile
set updatetime=2000
set autoread
set list
set listchars=tab:\ \ ,lead:‧,trail:‧,leadmultispace:\ \ \ \ \ \ \ ‧
set shortmess-=S
set hidden
set hlsearch
set timeoutlen=500
set nowrap
set pastetoggle=<F2>

if executable("rg")
	set grepprg=rg\ --vimgrep\ --smart-case
	set grepformat+=%f:%l:%c:%m
	command! -nargs=+ R execute 'silent grep! <args>' | copen
endif

map <Space> <Leader>
inoremap jj <esc>
cnoremap jj <C-C>
nnoremap <Leader>w <Cmd>set wrap! wrap?<CR>
nnoremap <C-L> <Cmd>nohlsearch<CR>

nnoremap [b <Cmd>bnext<CR>
nnoremap ]b <Cmd>bprev<CR>
nnoremap [g <Cmd>cprevious<CR>
nnoremap ]g <Cmd>cnext<CR>

autocmd FileType go setlocal tabstop=4 shiftwidth=4
autocmd Filetype c setlocal commentstring=//\ %s
autocmd Filetype apkbuild setlocal commentstring=#\ %s

# g:fzf_layout = {
# 	'window': {
# 		'width': 0.9,
# 		'height': 0.4,
# 		'relative': true,
# 		'yoffset': 1.0,
# 	}
# }

# lsp server setup
var lspOpts = {
	autoHighlight: true,
	autoHighlightDiags: true,
	semanticHighlight: true,
	semanticHighlightDelay: 500,
	usePopupInCodeAction: true,
}

var lspServers = [
	{
		name: 'clangd',
		filetype: ['c', 'cpp'],
		path: 'clangd',
		args: ['--background-index'],
	}, {
		name: 'gopls',
		filetype: ['go'],
		path: 'gopls',
		args: ['serve'],
	}, {
		name: 'rustanalyzer',
		filetype: ['rust'],
		path: 'rust-analyzer',
		args: [],
		syncInit: true,
	},
]

def LspInit()
	g:LspOptionsSet(lspOpts)
	g:LspAddServer(lspServers)
enddef

def LspKeys()
	nnoremap <buffer> [d	<Cmd>LspDiag prev<cr>
	nnoremap <buffer> ]d	<Cmd>LspDiag next<cr>
	nnoremap <buffer> [D	<Cmd>LspDiag first<cr>
	nnoremap <buffer> ]D	<Cmd>LspDiag last<cr>

	nnoremap <buffer> gd	<Cmd>LspGotoDefinition<cr>
	nnoremap <buffer> gD	<Cmd>LspGotoDeclaration<cr>
	nnoremap <buffer> gy	<Cmd>LspGotoTypeDef<cr>
	nnoremap <buffer> gi	<Cmd>LspGotoImpl<cr>
	nnoremap <buffer> cd	<Cmd>LspRename<cr>
	nnoremap <buffer> gh	<Cmd>LspDiagCurrent<cr>
	nnoremap <buffer> <Leader>k	<Cmd>LspHover<cr>
enddef

augroup lsp
	autocmd!
	autocmd User LspSetup LspInit()
	autocmd User LspAttached LspKeys()
	autocmd BufWritePost * silent! :LspFormat
augroup end

g:loaded_netrwPlugin = 1	# disable netrw
g:loaded_getscript = 1		# disable getscript

# use :scriptnames to check loaded vimrc files
