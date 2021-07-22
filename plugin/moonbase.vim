if !has('nvim-0.5')
    echoerr "Moonbase requires at least nvim-0.5. Please update or uninstall"
    finish
end

" prevent loading moonbase twice
if exists('g:loaded_moonbase')
    finish
endif
let g:loaded_moonbase = 1

" common practice to prevent coptions from interfering with plugin
" First save current cpo settings, reset them, and them restore
let s:save_cpo = &cpo
set cpo&vim " reset coptions to defaults

command! Moonbase lua require('moonbase').hello()

let &cpo = s:save_cpo " restore cpo settings
unlet s:save_cpo
