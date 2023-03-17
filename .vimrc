" ============================================================================
" PLUG EXTENSIONS
" ============================================================================
" Plugins will be downloaded under the specified directory.
" Install plugins once with :PlugInstall
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
" Declare the list of plugins.

" install fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" match parenthesis and curly brackets
" Plug 'chun-yang/auto-pairs'

" install commentary for easier commenting
Plug 'chrisbra/vim-commentary'

" install nerd tree
Plug 'preservim/nerdtree'

" a nice color scheme
Plug 'artanikin/vim-synthwave84'

" release branch of coc vim for code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" a tool to help format using clang-format
Plug 'rhysd/vim-clang-format'

" a tool to make it easy to define header gaurds
Plug 'drmikehenry/vim-headerguard'

" quickly switch between header files and c files
Plug 'vim-scripts/a.vim'


" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" ============================================================================
" Prepare vim for color schemes
" ============================================================================
:set termguicolors
:colorscheme synthwave84

" ============================================================================
" Swap Files
" ============================================================================
:set noswapfile

" ============================================================================
" Refresh vim buffer if file changes
" ============================================================================
:set autoread

" ============================================================================
" Show file name in status line
" ============================================================================
:set laststatus=2
:set statusline+=%F


" ============================================================================
" hide abandonded files
" ============================================================================
" A file is abandoned if you leave it without making changes to it.
" :set hidden will allow you to keep the unsaved buffer without leaving it
:set hidden

" ============================================================================
" line numbers
" ============================================================================
:set number
:set relativenumber
:set numberwidth=4

" ============================================================================
" Tabs / Spaces
" ============================================================================
" how many columns of whitespaces is a \t character
:set tabstop=4

" how many columns of whitespaces is a level of indentation 
:set shiftwidth=4

" how many columns of whitespaces is a tab keypress worth
:set softtabstop=4

" tab keypress results in \t
:set noexpandtab

" ============================================================================
" Save files quickly with space
" ============================================================================
nnoremap <Space> :w<CR>
nnoremap <Leader><Space> :wall<CR>

" ============================================================================
" enable the mouse in all modes
" ============================================================================
:set mouse=a
:set ttymouse=xterm2

" ============================================================================
" edit ~/.vimrc and source it easily
" ============================================================================
nnoremap <Leader>ve :vsplit ~/.vimrc<CR>
nnoremap <Leader>vs :source ~/.vimrc<CR>
nnoremap <Leader>vi :PlugInstall<CR>

" ============================================================================
" quickly switch buffers
" ============================================================================
nnoremap <leader>bb :ls<cr>:buffer 
nnoremap <Leader>bd :bd<CR>
nnoremap <C-RIGHT> :bnext<CR>
nnoremap <C-LEFT> :bprev<CR>

" ============================================================================
" quickly work with the fuzzy finder
" ============================================================================
nnoremap <leader>ff :Files<cr>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>fg :Rg<CR>

" ============================================================================
" quickly open NERDtree
" ============================================================================
nnoremap <leader>nn :NERDTreeToggle<CR>

" ============================================================================
" :ClangFormat settings
" ============================================================================
nnoremap <leader>cf :ClangFormat<CR>
vnoremap <leader>cf :ClangFormat<CR>

" ============================================================================
" headergaurd customization
" ============================================================================
nnoremap <leader>hga :HeaderguardAdd<CR>

" this function will determine the base name of header gaurd value
function! g:HeaderguardName()
	let header_prefix = ''

	let git_repo_name = substitute(system('basename `git rev-parse --show-toplevel`'), '\n\+$', '', '')

	if v:shell_error == 0
		let header_prefix = toupper(git_repo_name) . '_'
	endif

	let file_based_header_name = toupper(expand('%:t:gs/[^0-9a-zA-Z_]/_/g'))
	return header_prefix . file_based_header_name
endfunction

" ============================================================================
" Coc settings
" ============================================================================
" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=500

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
