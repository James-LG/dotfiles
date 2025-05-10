let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/code/dotfiles/home/.config/nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +31 ~/code/dotfiles/cheatsheet.md
badd +1 ~/code/dotfiles/README.md
badd +69 ~/code/dotfiles/home/.zshrc
badd +127 ~/code/dotfiles/home/.aerospace.toml
badd +6 ~/code/dotfiles/home/.config/alacritty/alacritty.toml
badd +10 lua/plugins/colorscheme.lua
badd +1 lua/plugins/telescope.lua
badd +1 ~/code/dotfiles
badd +36 lua/config/options.lua
badd +21 lua/plugins/lsp.lua
badd +12 lua/plugins/trouble.lua
badd +1 ~/code/dotfiles/home/.tmux.conf
badd +1 lua/plugins/lint.lua
badd +6 lua/plugins/conform.lua
badd +3 lua/config/remap.lua
badd +279 health://
argglobal
%argdel
$argadd ~/code/dotfiles
edit lua/plugins/lint.lua
argglobal
balt ~/code/dotfiles/cheatsheet.md
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 32) / 64)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/code/dotfiles/home/.config/nvim
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
nohlsearch
let g:this_session = v:this_session
let g:this_obsession = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
