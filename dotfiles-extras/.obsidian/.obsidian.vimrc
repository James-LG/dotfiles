inoremap jk <Esc>

" gd to follow links
exmap followLink :obcommand editor:follow-link
nmap gd :followLink

" <Space>f to open quick switcher
unmap <Space>
exmap openQuickSwitch :obcommand switcher:open
nmap <Space>f :openQuickSwitch

" Yank to system clipboard
set clipboard=unnamed

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back
exmap forward obcommand app:go-forward
nmap <C-i> :forward