" Jump bisecting
" Author: Jonatan Vela
" Version: 0.1

if exists('g:hjkl_bisect_loaded')
	finish
endif

let g:hjkl_bisect_loaded = 1
let s:active = 0

function! s:start_bisect_v()
	nmap <buffer> <silent> k :call <SID>up()<CR>
	nmap <buffer> <silent> j :call <SID>down()<CR>
	nmap <buffer> <silent> l :call <SID>stop_bisect()<CR>
	nmap <buffer> <silent> h :call <SID>stop_bisect()<CR>
	nmap <buffer> <silent> <Esc> :call <SID>stop_bisect()<CR>
	nmap <buffer> <silent> <CR> :call <SID>stop_bisect()<CR>
	let s:active = 1
	let s:old_cursorline = &cursorline
	let s:old_cursorcolumn = &cursorcolumn
	set cursorline
	set nocursorcolumn
endfunction

function! s:start_bisect_h()
	nmap <buffer> <silent> k :call <SID>stop_bisect()<CR>
	nmap <buffer> <silent> j :call <SID>stop_bisect()<CR>
	nmap <buffer> <silent> l :call <SID>right()<CR>
	nmap <buffer> <silent> h :call <SID>left()<CR>
	nmap <buffer> <silent> <Esc> :call <SID>stop_bisect()<CR>
	nmap <buffer> <silent> <CR> :call <SID>stop_bisect()<CR>
	let s:active = 2
	let s:old_cursorline = &cursorline
	let s:old_cursorcolumn = &cursorcolumn
	set nocursorline
	set cursorcolumn
endfunction

function! s:stop_bisect()
	nunmap <buffer> j
	nunmap <buffer> k
	nunmap <buffer> l
	nunmap <buffer> h
	nunmap <buffer> <Esc>
	let s:active = 0
	let &cursorline = s:old_cursorline
	let &cursorcolumn = s:old_cursorcolumn
endfunction

function! s:check_pos()
	if (s:active != 0) && ((s:pos2 - s:pos1) == 0)
		call s:stop_bisect()
	endif
	return s:active != 0
endfunction

function! s:set_cursor_v(top, bot, direction)
	let delta = a:bot - a:top
	if delta == 0
		call s:stop_bisect()
  else
    if delta == 1
      let delta += a:direction
    endif
    call cursor(line('w0') - 1 + a:top + (delta/2), 1)
  endif
endfunction

function! s:set_cursor_h(top, bot, direction)
	let delta = a:bot - a:top
	if abs(delta) == 0
		call s:stop_bisect()
	else
    if delta == 1
      let delta += a:direction
    endif
		call cursor(line('.'), a:top + (delta/2))
	end
endfunction

function! s:up()
	let s:pos2 = winline()
	if s:active == 0
		let s:pos1 = 1
		call s:start_bisect_v()
	endif
	if s:check_pos()
		call s:set_cursor_v(s:pos1, s:pos2, -1)
	endif
endfunction

function! s:down()
	let s:pos1 = winline()
	if s:active == 0
		let s:pos2 = winheight(0)
		call s:start_bisect_v()
	endif
	if s:check_pos()
		call s:set_cursor_v(s:pos1, s:pos2, 1)
	endif
endfunction

function! s:left()
	let s:pos2 = col('.')
	if s:active == 0
		let s:pos1 = 1
		call s:start_bisect_h()
	endif
	if s:check_pos()
		call s:set_cursor_h(s:pos1, s:pos2, -1)
	endif
endfunction

function! s:right()
	let s:pos1 = col('.')
	if s:active == 0
		let s:pos2 = col('$') - 1
		call s:start_bisect_h()
	endif
	if s:check_pos()
		call s:set_cursor_h(s:pos1, s:pos2, 1)
	endif
endfunction

command! -nargs=0 BisectStartUp call s:up()
command! -nargs=0 BisectStartDown call s:down()
command! -nargs=0 BisectStartRight call s:right()
command! -nargs=0 BisectStartLeft call s:left()

nmap <leader><leader>j :BisectStartDown<CR>
nmap <leader><leader>k :BisectStartUp<CR>
nmap <leader><leader>l :BisectStartRight<CR>
nmap <leader><leader>h :BisectStartLeft<CR>
