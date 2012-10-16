scriptencoding utf-8
" capture.vim
"   Capture ex-command output to new buffer.
"
" cite: https://github.com/tyru/dotfiles/blob/f6f029360f5e0dff9639a9922a49109d29fea4ed/dotfiles/.vim/init.vim

command! -nargs=+ -complete=command Capture call s:capture(<q-args>)
function! s:capture(args)
	redir => output
		silent execute a:args
	redir END
	
	new
	silent file `=printf('[Capture: %s]', a:args)`
	setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted
	call setline(1, split(output, '\n'))
endfunction
