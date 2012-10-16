scriptencoding utf-8
" capture.vim
"   Capture ex-command output to new buffer.
"
" cite: https://github.com/tyru/dotfiles/blob/f6f029360f5e0dff9639a9922a49109d29fea4ed/dotfiles/.vim/init.vim

command! -nargs=+ -complete=command Capture call s:capture(<q-args>)

function! s:capture(args)
	let arg1stEnd = stridx(a:args, " ")
	let arg1stEnd = (arg1stEnd > 0) ? arg1stEnd : 0

	" [TODO] To allow command omission signages. (vertical->vert etc.)
	let winComs = ["horizontal", "vertical", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright"]
	let winCom = "horizontal"	" 'horizontal' is default.
	let winComIdx = index(winComs, strpart(a:args, 0, arg1stEnd))
	if winComIdx >= 0	" found
		let winCom = winComs[winComIdx]
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
