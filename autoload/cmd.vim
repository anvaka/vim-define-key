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

  let descriptionWithKey = s:getDescriptionWithKey(a:description, key)
  call add(g:unite_source_menu_menus.palette.command_candidates,
        \ [descriptionWithKey, feedKeyCommand])

  if a:0 == 1
    " We have custom mapping. use it:
    exec 'nmap ' . key . ' ' . a:command
  endif
endfunction

function! s:getDescriptionWithKey(description, key)
  let finalString = strpart(a:description, 0, 75)
  let leadingZero = 75 - strlen(finalString)
  if leadingZero > 0
    let finalString .= s:makeSpaces(leadingZero)
  else
    let finalString .= "..."
  endif

  if strlen(a:key) > 0
    let finalString .= "\t".  a:key
  endif

  return finalString
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

function s:makeSpaces(spacesCount)
  let diff = a:spacesCount
  let spaces = ''
  while diff > 0
    let spaces = spaces . ' '
    let diff = diff - 1
  endwhile

  return spaces
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

let g:loaded_define_keys = 1
"}}}1
"
" vim:fen:fdl=0:ts=2:sw=2:sts=2
