scriptencoding utf-8
" capture.vim
"   Capture ex-command output to new buffer.
"
" cite: https://github.com/tyru/dotfiles/blob/f6f029360f5e0dff9639a9922a49109d29fea4ed/dotfiles/.vim/init.vim

command! -nargs=+ -complete=command Capture call s:capture(<q-args>)

function! s:capture(args)
	let arg1stEnd = stridx(a:args, " ")
	let arg1stEnd = (arg1stEnd > 0) ? arg1stEnd : 0
	let arg1st = strpart(a:args, 0, arg1stEnd)

	let winComs = ['horizontal', 'vert\%[ical]', 'lefta\%[bove]', 'abo\%[veleft]', 'rightb\%[elow]', 'bel\%[owright]', 'to\%[pleft]', 'bo\%[tright]']
	let winCom = "horizontal"	" 'horizontal' is default.
	let winComHits = filter(winComs, 'arg1st =~# v:val')
 
	if len(winComHits)	" found
		let winCom = matchstr(winComHits[0], '^\w\+')	" delete '\%[]' part
		let args = strpart(a:args, arg1stEnd + 1)	" delete 1st token(=window create command).
	else
		let args = a:args
	endif
	" 'horizontal' is used default behavior of the Vim.
	if winCom ==# "horizontal" | let winCom = "" | endif

	" [TODO] Error message captured. At this behavior is good? to not captured?
	redir => output
		silent execute args
	redir END

	execute winCom . " new"
	setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted
	silent file `=printf("[Capture: %s]", args)`
	call setline(1, split(output, "\n"))
endfunction
