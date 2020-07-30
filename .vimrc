set nocompatible              " required
filetype off                  " required


"
" Vundle
"

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'tpope/vim-sensible'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'terryma/vim-expand-region'
Plugin 'terryma/vim-multiple-cursors'
" Plugin 'terryma/vim-smooth-scroll'
Plugin 'psliwka/vim-smoothie'
Plugin 'tpope/vim-surround'
Plugin 'solarnz/thrift.vim'
Plugin 'mbbill/undotree'
Plugin 'thinca/vim-localrc'
Plugin 'maralla/completor.vim'
Plugin 'bogado/file-line'
Plugin 't9md/vim-choosewin'
Plugin 'tmhedberg/matchit'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'majutsushi/tagbar'
Plugin 'airblade/vim-gitgutter'
Plugin 'mhinz/vim-startify'
Plugin 'w0rp/ale'
Plugin 'lepture/vim-jinja'
Plugin 'ambv/black'

" fzf
Plugin 'junegunn/fzf.vim'
set rtp+=/usr/local/opt/fzf


" Add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" ...

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required



"
" Basic
"
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave *: setlocal nu relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   *: setlocal nonu  norelativenumber
augroup END
" Trigger line number
noremap <Leader>n :set invnu invrelativenumber<CR>

syntax on
let python_highlight_all=1

"use space as leader in sensible modes
nmap <space> <Leader>
vmap <space> <Leader>

set nowrap
set splitright
set splitbelow
set backspace=eol,start,indent
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gb2312,gbk
set fileformats=unix,dos
set ignorecase
set smartcase
set incsearch
set scrolloff=3
set sidescrolloff=7
set sidescroll=1
set showcmd
set hls is
set laststatus=2
set showmode
set autoread       " Set to auto read when a file is changed from the outside
set swapfile
set dir=/tmp
set backupdir=/tmp
set undodir=$HOME/.vim/undo
set undofile
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo
set cursorline
set list
set listchars=tab:▸\ ,trail:·,precedes:←,extends:→
set expandtab smarttab shiftwidth=4 tabstop=4
if &diff
    colorscheme industry
else
    colorscheme desertEx
endif
set colorcolumn=80,120
highlight ColorColumn ctermbg=236
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc

" Split navigations
nnoremap <Leader><C-J> <C-W><C-J>
nnoremap <Leader><C-K> <C-W><C-K>
nnoremap <Leader><C-L> <C-W><C-L>
nnoremap <Leader><C-H> <C-W><C-H>

" Horizontal scroll
nnoremap <C-L> 20zl " Scroll 20 characters to the right
nnoremap <C-H> 20zh " Scroll 20 characters to the left

" Delete without yank
vnoremap c "_c

" Templates
if has('autocmd')
    augroup templates
        autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/skeleton.'.expand("<afile>:e")
    augroup END
endif

" Filetype
" Default
autocmd BufRead *.ptl set ft=python
autocmd BufRead *.md set ft=markdown
autocmd BufRead *.html set ft=mako
autocmd BufRead *.sls set ft=yaml

" yaml
autocmd FileType yaml set tabstop=2 expandtab shiftwidth=2 softtabstop=2

" Makefile
autocmd FileType make set noexpandtab

" python
autocmd FileType python set errorformat=%f:%l:\ %m
autocmd FileType python set smartindent cinwords=if,elif,else,for,while,with,try,except,finally,def,class
" Highlighten Trailing Space
autocmd FileType python highlight WhitespaceEOL ctermbg=red guibg=red
autocmd FileType python match WhitespaceEOL /\s\+$/
if exists("&colorcolumn")
    autocmd FileType python set colorcolumn=79
endif

" Jinja2
au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set ft=jinja


" Golang
autocmd BufRead,BufNewFile *.go set filetype=go
autocmd FileType go set noexpandtab tabstop=4


"
" Advance
"
" Search-and-Replace. See: https://github.com/sheerun/blog/blob/master/_posts/2014-03-21-how-to-boost-your-vim-productivity.markdown#iv-discover-text-search-object
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

" In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" Copy relative file path
" relative path
" nmap <Leader>rp :let @"=expand("%")<CR>
" full path
nmap <silent> <Leader>rp :let @*=expand("%:p")<CR>

noremap <Leader><C-y> "*y<CR>
noremap <Leader><C-p> "*p<CR>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"statusline setup
set statusline =%#identifier#
set statusline+=[%f%m]    "tail of the filename
set statusline+=%*

" display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

" display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

" read only flag
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*

" display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

" left align
set statusline+=%=

set statusline+=%c,%l/%L\ %P
" recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

" return '[\s]' if trailing white space is detected
" return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

" return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

" recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

" return '[&et]' if &et is set wrong
" return '[mixed-indenting]' if spaces and tabs are used to indent
" return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

" recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

" return a warning for 'long lines' where 'long' is either &textwidth or 80 (if
" no &textwidth is set)
"
" return '' if no long lines
" return '[#x,my,$z] if long lines are found, were x is the number of long
" lines, y is the median length of the long lines and z is the length of the
" longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")

        if !&modifiable
            let b:statusline_long_line_warning = ''
            return b:statusline_long_line_warning
        endif

        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        endif
    endif
    return b:statusline_long_line_warning
endfunction

" return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)
    let line_lens = map(getline(1,'$'), 'len(substitute(v:val, "\\t", spaces, "g"))')
    return filter(line_lens, 'v:val > threshold')
endfunction

" Set the title of the Terminal to the currently open file
function! SetTerminalTitle()
    let titleString = expand('%:p:h:t')
    if len(titleString) > 0
        let &titlestring = expand('%:p:h:t')
        " this is the format iTerm2 expects when setting the window title
        let args = "\033];".&titlestring."\007"
        let cmd = 'silent !echo -e "'.args.'"'
        execute cmd
        redraw!
    endif
endfunction

autocmd BufEnter * call SetTerminalTitle()

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"
" Plugin Settings
"

"
" NERDTree
"
let g:NERDTreeChDirMode = 0
autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" autocmd VimEnter * NERDTree | wincmd p
map <silent> <Leader>b :NERDTreeToggle<CR>
map <silent> <Leader>F :NERDTreeFind<CR>
map <silent> <Leader>T :NERDTreeFocus<CR>
let NERDTreeIgnore = ['\.pyc$', '__pycache__', '.vscode', '.git', 'tags', 'tags.lock']
let NERDTreeShowHidden = 1
let NERDTreeShowLineNumbers=0
let NERDTreeRespectWildIgnore=1


"
" ludovicchabant/vim-gutentags
"
let g:gutentags_ctags_exclude = ['.git', 'tmp/*', 'log/*', 'coverage/*', 'doc/*']
let g:gutentags_cache_dir = '.git/'
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]

"
" majutsushi/tagbar
"
nnoremap <Leader>] :TagbarToggle<cr>

"
" nerdcommenter
"
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

"
" fzf
"
" see https://github.com/junegunn/fzf.vim/issues/47#issuecomment-160237795
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
command! ProjectFiles execute 'FZF --reverse --inline-info' s:find_git_root()

" nnoremap <silent> <C-p> :FZF --reverse --inline-info<CR>
nnoremap <silent> <C-p> :ProjectFiles <CR>

let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_layout = { 'down': '~20%' }

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 '--color-path "1;36"',
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
nnoremap <silent> <leader><C-p> :Ag!<CR>

"
" undotree
"
nnoremap <F5> :UndotreeToggle<cr>

"
" maralla/completor.vim
"
let g:completor_auto_trigger = 0
inoremap <expr><S-Tab> "<C-R>=completor#do('complete')<CR>"

"
" t9md/vim-choosewin
"
let g:choosewin_overlay_enable = 1
nmap  -  <Plug>(choosewin)

"
" w0rp/ale
"
let g:ale_set_highlights = 0
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\}
let g:ale_python_pylint_use_global = 0
let g:ale_python_pylint_executable = '/usr/bin/env pylint'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_python_pylint_options = '--disable=C0111'
nmap <silent><C-k> <Plug>(ale_previous_wrap)
nmap <silent><C-j> <Plug>(ale_next_wrap)

let g:ale_elixir_credo_strict = 1

"
" vim-startify
"
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
