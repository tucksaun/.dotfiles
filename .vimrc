" General
    filetype on
    filetype plugin indent on
    set backspace=indent,eol,start  " make backspace a bit more flexible, http://vim.wikia.com/wiki/Backspace_and_delete_problems
    set iskeyword+=_,@,%,#          " none of these are word dividers ???
    set nobackup
    set nowritebackup               " like set nobackup.
    set nocompatible                " Explicitly get out of vi-compatible mode
    set noerrorbells                " Do not make any noise!
    set vb                          " I said, NO noise
    set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc,*.pyo,*/cache/**,*/logs/** " Ignore certain files
    syntax on

" utf8
    scriptencoding utf-8
    set fileencoding=UTF-8          " speak utf8
    set encoding=UTF-8              " display utf8

" UI
    set background=dark
    set cursorline                  " Highlight the current line
    set hlsearch                    " Highlight matches.
    set incsearch                   " Highlight matches as you type.
    set langmenu=en_US.UTF-8
    set list                        " Show special chars
    set number                      " Show line numbers in gutter
    set ruler                       " Always show current position along the bottom
    set scrolloff=8                 " Keep x line for scope while scrolling
    set showcmd                     " Show (partial) command in status line.
    set showmatch                   " Show matching bracket
    set sidescrolloff=8             " same same
    set showmode                    " show mode status

" EDITING
    set expandtab                   " We do not want tabs, do we?
    set softtabstop=4               " hit <tab> insert 4 spaces
    set ff=unix                     " Unix EOL
    set fileformats=unix            " always show ^M for DOS CR
    set fileencoding=UTF-8          " Speak UTF-8
    set ignorecase                  " case sensitivity is dumb
    set list                        " show whitespaces
    set listchars=trail:¤,tab:>-    " only show ther chars
    set nowrap                      " No, I don't want wordwrap
    set shiftround                  " when at 3 spaces, and I hit > ... go to 4, not 5
    set shiftwidth=4
    set smartcase                   " but not where there are different cases
    set tabstop=4
    set cindent                     " C style indentation
    set smarttab
    set smartindent                 " manage indentation inside braces
    set paste                       " no auto-indent on paste
    setlocal spell spelllang=en_us  " enable spelling
    set spellsuggest=5              " suggest
    " auto formatting
    set comments="sl:/*,mb: *,elx: */" " auto insert comments blocks
    set formatoptions+=r            " auto-insert ' * ' when hitting <enter> in comment block
    autocmd FileType c,cpp,java,php,js,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))        " remove trailing whitespaces and ^M
    " auto completion
    set wildmenu                     " show list instead of just completing
    set wildmode=list:longest,full   " ctrl <Tab> completion, list matches, then longest common part, then all
    set completeopt=longest,menuone  " same as above
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
    inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" plug-ins
    call pathogen#infect()      " pathogen plugin
    imap <buffer> <F5> <C-O>:call PhpInsertUse()<CR>
    map <buffer> <F5> :call PhpInsertUse()<CR>

" colors
    set background=dark
    colorscheme solarized

" GUI
if has('gui_running')
  set guifont=Monaco:h12
  let g:solarized_style="dark"
  let g:solarized_contrast="high"
endif

" ctrl shortcuts
    vnoremap <C-X> "+x
    vnoremap <C-C> "+y
    map <C-V> "+gP
    cmap <C-V> <C-R>+

" Extra
    " return at last position
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

if has('statusline')
    set laststatus=2
    set statusline=%<%f\    " filename
    set statusline+=%w%h%m%r " options
    set statusline+=%{fugitive#statusline()} " git status
    set statusline+=\ [%{&ff}/%Y] " file type
    set statusline+=\ [%{getcwd()}] " current directory
    set statusline+=%=%-14.(%l,%c%V%)\ %p%% " right aligned file nav info
endif
