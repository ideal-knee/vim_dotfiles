set nocompatible
syntax on
filetype plugin indent on

set hlsearch
set number
set showmatch
set incsearch
set background=dark
set hidden
set backspace=indent,eol,start
set textwidth=0 nosmartindent tabstop=4 shiftwidth=4 softtabstop=4 expandtab

let html_use_css=1
let html_number_lines=0

autocmd FileType ruby,eruby,io,cpp setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd BufNewFile,BufRead *.txt setlocal textwidth=78

map <silent> \rb :!ruby %<CR>
map <silent> \rs :!spec %<CR>
map \rd Orequire 'ruby-debug';debugger<ESC>
map <silent> \io :!io %<CR>
map <silent> \rt :!ctags -R -f TAGS --exclude=".git\|.svn\|vendor\|db\|pkg" --extra=+f<CR>
map <silent> \nt :NERDTreeToggle<CR>
map <silent> \ff :FuzzyFinderTaggedFile<CR>
map <silent> \ft :FuzzyFinderTag<CR>
map <silent> \fb :FuzzyFinderBuffer<CR>
map <silent> \nh :nohls<CR>
map <silent> \cc :NERDComComment<CR>
map <silent> \tc :NERDComToggleComment<CR>

if version >= 600
    set foldenable
    set foldmethod=syntax
    set foldlevel=999
endif