"" Pathogen
call pathogen#runtime_append_all_bundles()
"call pathogen#helptags()

"" Global settings
set fileencoding=utf8
filetype plugin on
filetype indent on
filetype on


" set line length for all files at 78
autocmd FileType text setlocal textwidth=78

" important settings
set incsearch
set ignorecase
set hlsearch

" Disable backup cuz I use that GIT fad
set nobackup
set nowritebackup
set noswapfile
set nofoldenable

" status line
set statusline=
set statusline+=%f\ %2*%m\ %1*%h
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{fugitive#statusline()}
set statusline+=%*
set statusline+=%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}]\ %12.(%c:%l/%L%)
set laststatus=2

set nocompatible

" backspace mode
set bs=2

" highlitt current line and add line numbers
set cursorline
set number

" yummy
set antialias
if has('gui')
    if has('gui_gnome')
        set guifont=DejaVu\ Sans\ Mono\ 8
    elseif has('gui_macvim')
        "set guifont=Monaco:h12.00
        set guifont=Menlo:h12.00
        set transparency=0
    elseif has('gui_win32')
        set guifont=Consolas:h8
    endif
endif

" turn off the scrollbars and the rest of the crap
set guioptions=eg

" colorz
syntax on
" let g:molokai_original=1
colorscheme  chance-of-storm


" display improvements
set list
set lcs=tab:>-,trail:-

" show indents
set ruler
set showcmd
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab


" nice mappings
noremap <C-a> ^
noremap <C-e> $

" better esc
ino jj <esc>
cno jj <c-c>

" better buffer/window/tab navigation
map ee <C-w>

" disable arrows
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

" Bubble single lines
nmap <C-Up> ddkP
nmap <C-Down> ddp
" Bubble multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]

" make tab key more better
nmap <tab> v>
nmap <s-tab> v<
vmap <tab> >gv
vmap <s-tab> <gv

"" Filetype specific settings

" json as javascript
au BufNewFile  *.json set filetype=javascript
au BufRead *.json set filetype=javascript

" mustache templates
au BufNewFile  *.mustache set filetype=mustache
au BufRead *.mustache set filetype=mustache

" markdown filetype
au BufNewFile  *.md set filetype=mkd
au BufRead *.md set filetype=mkd
au BufNewFile  *.markdown set filetype=mkd
au BufRead *.markdown set filetype=mkd

" set spellcheck for markdown files
au BufNewFile  *.md set spell
au BufRead *.md set spell
au BufNewFile  *.markdown set spell
au BufRead *.markdown set spell

" non ruby files
au BufNewFile  Gemfile set filetype=ruby
au BufRead Gemfile set filetype=ruby
au BufNewFile  Gemfile.lock set filetype=ruby
au BufRead Gemfile.lock set filetype=ruby

au BufNewFile  Rakefile set filetype=ruby
au BufRead Rakefile set filetype=ruby

"" Plugin settings

" disable xrargs for grep.vim
let Grep_Find_Use_Xargs = 0

noremap <Leader>n :NERDTreeToggle<CR>

noremap <Leader>g :GundoToggle<CR>

noremap <Leader>l :RRSpecL<CR>
"" Functions

" save all command under :W, possibly add new stuff to it
function! s:SaveAll()
    w | :Error
endfunction
command! -bar -narg=0 W call s:SaveAll()

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()


" Any command output piping to a new split
function! SplitMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  vnew
  silent put=message
  %s/\r//
  set nomodified
endfunction
command! -nargs=+ -complete=command SplitMessage call SplitMessage(<q-args>)
