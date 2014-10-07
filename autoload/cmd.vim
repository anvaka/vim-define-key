if exists('g:loaded_ctrlp_keys') && g:loaded_ctrlp_keys
  fini
en
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
  \ 'init': 'cmd#init()',
  \ 'accept': 'cmd#accept',
  \ 'lname': 'keys',
  \ 'sname': 'keys',
  \ 'type': 'line',
  \ 'sort': 0,
	\ 'postrender': 'cmd#postrender',
  \ }

" Pre-load the vim commands list
let s:keys_commands = []

if !exists('g:ctrlp_keys_execute')
  let g:ctrlp_keys_execute = 0
endif

let s:keys = []
let s:invoke = {}

function! cmd#define(description, command, ...)
  if has_key(s:invoke, a:description)
    return
  endif

  let key = (a:0 == 1) ? a:1 : ''

  call DescribeKey(a:description, a:command, key)

  if a:0 == 1
    " We have custom mapping. use it:
    exec 'nmap ' . key . ' ' . a:command
  endif
endfunction


function! DescribeKey(description, command, key)
  let record = { 'description': a:description, 'command': a:command, 'key': a:key }
  call add(s:keys, record)
  let s:invoke[a:description] = record
endfunction


" This will be called by ctrlp to get the full list of elements
" where to look for matches
function! cmd#init()
  let entries = copy(s:keys)
  let s:longestKey = s:getLongestKey(entries)
  let results = map(sort(entries, 's:compval'), 's:format(v:val)')
  return results
endfunction

function s:getLongestKey(entries)
  let maxLength = 0
  for entry in a:entries
    if strlen(entry['key']) > maxLength
      let maxLength = strlen(entry['key'])
    endif
  endfor

  return maxLength
endfunction

function s:compval(left, right)
  if a:left['description'] < a:right['description']
    return 1
  elseif a:left['description'] > a:right['description']
    return -1
  return 0
endf

function s:format(val)
  let key = a:val['key']
  let diff = s:longestKey - strlen(key) + 1
  let spaces = ''
  while diff > 0
    let spaces = spaces . ' '
    let diff = diff - 1
  endwhile

  return key . spaces . ' ' . a:val['description']
endfunction

function! s:syntax()
	if ctrlp#nosy() | retu | en
  cal ctrlp#hicheck('CtrlPKeysKey', 'Identifier')
  cal ctrlp#hicheck('CtrlPKeysMatch', 'Identifier')
	sy match CtrlPKeysKey '^> .* ' contains=CtrlPLinePre
endfunction

function! cmd#attach()
  if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
    add(g:ctrlp_ext_vars, s:keys_var)
  else
    let g:ctrlp_ext_vars = [s:keys_var]
  endif
  let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
	cal s:syntax()
endfunction

" Public Interface with CtrlP {{{2
function! cmd#id()
  return s:id
endfunction

" This will be called by ctrlp when a match is selected by the user
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
function! cmd#accept(mode, str)
  call ctrlp#exit()

  let descriptionKey = split(a:str,' ')[1]
  let record = s:invoke[descriptionKey]

  let key = record['command']
  let map = substitute(key, '\c<leader>', g:mapleader, 'g')
  let map = substitute(map, '\\', '\\\', 'g')
  let map = substitute(map, '"', '\\"', 'g')
  let map = substitute(map, '\(<[^<]\{-}>\)', '\\\1', 'g')

  let finalCommand = 'call feedkeys("' . map . '")'
  execute finalCommand
endfunc

function! cmd#postrender(pat)
endfunction

function! cmd#exit()
endfunction

"}}}1
"
" vim:fen:fdl=0:ts=2:sw=2:sts=2
