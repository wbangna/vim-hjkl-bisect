bisectj-vim
===========

Jump to anywhere in the displayed vim window using bisection.

Possible configuration in your vimrc:

nmap <leader><leader>j :BisectStartDown<CR>
nmap <leader><leader>k :BisectStartUp<CR>
nmap <leader><leader>l :BisectStartRight<CR>
nmap <leader><leader>h :BisectStartLeft<CR>

Start bisecting vertically with <leader><leader>j or <leader><leader>k.
continue bisecting with 'j' and 'k' keys. Pressing 'h', 'l', 'Esc' or 'Enter'
will quit bisecting.

Start bisecting horizontally with <leader><leader>h or <leader><leader>l.
continue bisecting with 'h' and 'l' keys. Pressing 'j', 'k', 'Esc' or 'Enter'
will quit bisecting.
