[nnn](https://github.com/jarun/nnn), the unorthodox file manager is my favorite
file manager of all time. it has been influential for many tui file managers,
like `yazi`, `ranger` and so on; yet somehow its still better than every one of
them.

the FIFO and POSIX based nature of nnn somehow makes a lot of sense. I don't
need to write my plugins in any certain language, any executable file will do;
and i'd only need to read some environment variables in that executable file.

but preview is where other tui file managers shine most, and do a better job
that `nnn` does. or do they?

# nnn preview-tabbed and dwm
the `preview-tabbed` uses [suckless's
tabbed](https://tools.suckless.org/tabbed/) to open a x window that shows some
preview application in it. this plugin is by default coded in a way that uses
`xdotool`'s `windowactivate` command to always activate the main window, which
doesn't work in dwm (as `windowactivate` sets `_NET_ACTIVE_WINDOW` variable, and
dwm only sets the urgency bit of a window with `_NET_ACTIVE_WINDOW` enabled).

however, there is a patch to work around this. its called
[focusonnetactive](https://dwm.suckless.org/patches/focusonnetactive/) (or
`FOCUSONNETACTIVE_PATCH` in dwm-flexipatch). apply this and from now on, dwm
responds to `windowactivate` by activating the window.

# nnn preview-tabbed and pdf preview
this plugin uses [pwmt's zathura](https://github.com/pwmt/zathura) for pdf
preview; but there are a couple of problems, mentioned in the following.

i have my own "forked" `preview-tabbed` that fixes these issues. following is
details of how it has been fixed. you can access the fork from
[here](/public/preview-tabbed)

## pdf preview is not rendered. i need to focus it
zathura waits for window focus/window size change to render the document, hence
you need to focus on `tabbed`'s  x window in order to fire the render event of
zathura. there's a huge problem of loading the document (some epub files take
eternities to load), which you need to focus on the x window ***after*** the
loading of document is ended.

a workaround is to have a loop that tries to focus on x window's id every couple
of deciseconds.

## zathura isn't set for epub's mime type
to fix this, you just need to match `applciation/epub+zip` mime type in the
switch case inside `~/.config/nnn/plugins/preview-tabbed`
```
