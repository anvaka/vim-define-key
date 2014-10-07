if !exists('g:loaded_ctrlp') || !g:loaded_ctrlp
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

call cmd#attach()
command! CtrlPKeys call ctrlp#init(cmd#id())

let &cpo = s:save_cpo
unlet s:save_cpo
