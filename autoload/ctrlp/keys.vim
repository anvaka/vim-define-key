let g:loaded_ctrlp_keys = 1

" The main variable for this extension.
"
" The values are:
" + the name of the input function (including the brackets and any argument)
" + the name of the action function (only the name)
" + the long and short names to use for the statusline
" + the matching type: line, path, tabs, tabe
"                      |     |     |     |
"                      |     |     |     `- match last tab delimited str
"                      |     |     `- match first tab delimited str
"                      |     `- match full line like file/dir path
"                      `- match full line
let s:keys_var = {
	\ 'init': 'ctrlp#keys#init()',
	\ 'accept': 'ctrlp#keys#accept',
	\ 'lname': 'keys',
	\ 'sname': 'keys',
	\ 'type': 'tabs',
	\ 'sort': 0,
	\ }


" Pre-load the vim commands list
let s:keys_commands = []

if !exists('g:ctrlp_keys_execute')
  let g:ctrlp_keys_execute = 0
endif

" Append s:keys_var to g:ctrlp_ext_vars
if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
	let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:keys_var)
else
	let g:ctrlp_ext_vars = [s:keys_var]
endif


" This will be called by ctrlp to get the full list of elements
" where to look for matches
function! ctrlp#keys#init()
  return s:keys_commands
endfunction


" This will be called by ctrlp when a match is selected by the user
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
func! ctrlp#keys#accept(mode, str)
  call ctrlp#exit()
  call feedkeys(':')
  call feedkeys(split(a:str, '\t')[0])
  if g:ctrlp_keys_execute == 1
    call feedkeys("\<CR>")
  endif
endfunc


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
" Allow it to be called later
function! ctrlp#keys#id()
  return s:id
endfunction


" vim:fen:fdl=0:ts=2:sw=2:sts=2
