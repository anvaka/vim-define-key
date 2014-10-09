if exists('g:loaded_define_keys') && g:loaded_define_keys
  finish
endif

if !exists('g:unite_source_menu_menus')
  let g:unite_source_menu_menus = {}
endif

let g:unite_source_menu_menus.palette = { 'description' : 'Command palette...' }
let g:unite_source_menu_menus.palette.command_candidates = []

function! cmd#define(description, command, ...)

  let key = (a:0 == 1) ? a:1 : ''
  let feedKeyCommand = s:getFeedKeys(a:command)

  call add(g:unite_source_menu_menus.palette.command_candidates,
        \ [a:description, feedKeyCommand])

  if a:0 == 1
    " We have custom mapping. use it:
    exec 'nmap ' . key . ' ' . a:command
  endif
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

" Public Interface with CtrlP {{{2
function! cmd#id()
  return s:id
endfunction

function! s:getFeedKeys(key)
  let map = substitute(a:key, '\c<leader>', g:mapleader, 'g')
  let map = substitute(map, '\\', '\\\', 'g')
  let map = substitute(map, '"', '\\"', 'g')
  let map = substitute(map, '\(<[^<]\{-}>\)', '\\\1', 'g')

  let finalCommand = 'call feedkeys("' . map . '")'
  return finalCommand
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

let g:loaded_define_keys = 1
"}}}1
"
" vim:fen:fdl=0:ts=2:sw=2:sts=2
