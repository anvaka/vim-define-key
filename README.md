# Vim Keys

Just a humble attempt to play with vim plugins

# Idea

There are times, when I'm rarly using a function of vim, but when I need it I
can't recall its keyboard shortcut.

This project implements `commands palette` interface where you can type human
readable description of a command and get it executed immediately.

# How to use

Instead of

``` vim
" Reload .vimrc
nmap <YOUR_KEY> :source $MYVIMRC<CR>
```

Use

``` vim
call cmd#define('Reload .vimrc', ":source $MYVIMRC<CR>")
```

If you need `YOUR-KEY` to be bound to the same action, just pass it as the last
argument:

``` vim
call cmd#define('Reload .vimrc', ":source $MYVIMRC<CR>", "<YOUR_KEY>")
```

Now every time when you invoke `:Unite menu:palette` you will find this feature in the
list of available commands

# Install

```
NeoBundle 'anvaka/vim-define-key'
```

This package depends on [Unite](https://github.com/Shougo/unite.vim). Make sure to grab it as well.

# Disclaimer

This is my first vim plugin. I have no idea what I'm doing.

# Licnese

MIT
