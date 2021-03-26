![Logo][logo]

Light and dark vim colorscheme, shamelessly stolen from atom (another
excellent text editor). **One** supports *true colors* and falls back
gracefully and automatically if your environment does not support this
feature.

## Everything You Should Know about This Fork

~~It seems rakr stopped maintaining the original repo and there's been
no response for the pull requests since March 2018, although he still
uses GitHub once in a while from what we know about the contribution
graph.~~ Although rakr failed to resolve a merge conflict,
my optimization fix was added manually at last.

The original repo lacks maintenance. The author checks PRs about once a season?
And the accepted PRs even introduced bugs, which let me suspect
if there's any code review being done.
I'll just stop opening pr to it and keep updates in my own fork.

Changes made on this fork

* reduce theme loading time from 170 ms to 18 ms by
  * hard coding the 256 color, see [pr_93]
  * reusing highlight definitions with predefined groups (`hi link`)
* color palette customization support

|                              | loading time           |
| ---------------------------- | ---------------------- |
| original                     | 170.621 ms             |
| hard coding the 256 color    | 33.659 ms              |
| reusing defs with `hi link`  | 18.253 ms              |
| custom `syntax_bg` only      | 20.232 ms              |

### Color Palette Customization

This feature is **not** designed to change **the whole color palette**
of `vim-one`. The language specific highlights are based on the default
`vim-one` color palette. Redefining a completely different palette may
result in ugly highlights.

#### Usage

For example, we can change the background color by defining global variable

```viml
let g:one_light_syntax_bg='#123456'
# or
let g:one_dark_syntax_bg='#123456'
```

All available color palette keywords are as follows,

* `mono_1`, `mono_2`, `mono_3`, `mono_4`
* `hue_1`, `hue_2`, `hue_3`, `hue_4`, `hue_5`, `hue_5_2`, `hue_6`, `hue_6_2`
* `syntax_bg`, `syntax_gutter`, `syntax_cursor`, `syntax_accent`, `syntax_accent_2`
* `vertsplit`, `special_grey`, `visual_grey`, `pmenu`
* `syntax_fg`, `syntax_fold_bg`

Prefix these keywords with `one_dark_` for dark color scheme
and `one_light_` for the light. Browse the source code for more detail.

## Vim Airline theme

Add the following line to your `~/.vimrc` or `~/.config/nvim/init.vim`

```vim
let g:airline_theme='one'
```

As for the colorscheme, this theme comes with light and dark flavors.

## List of enhanced language support

Pull requests are more than welcome here.
I have created few issues to provide a bare bone roadmap for this color
scheme.

### Stable

* Asciidoc
* CSS and Sass
* Cucumber features
* Elixir
* Go
* Haskell
* HTML
* JavaScript, JSON
* Markdown
* PureScript (thanks: [Arthur Xavier](https://github.com/arthur-xavier))
* Ruby
* Rust (thanks: [Erasin](https://github.com/erasin))
* Vim
* XML

### In progress

* Jade
* PHP
* Python
* Switch to estilo in progress, not stable at all and does not reflect all the
  capabilities of the current mainstream version


## Installation

You can use your preferred Vim Package Manager to install **One**.

## Usage

**One** comes in two flavors: light and dark.

```vim
colorscheme one
set background=dark " for the dark version
" set background=light " for the light version
```

`set background` has to be called after setting the colorscheme, this explains
the issue [#21][issue_21] where Vim tries to determine the best background when `ctermbg`
for the `Normal` highlight is defined.

### Italic support

Some terminals do not support italic, cf. [#3][issue_3].

If your terminal does support _italic_, you can set the `g:one_allow_italics` variable to 1 in your `.vimrc` or `.config/nvim/init.vim`:

```vim
set background=light        " for the light version
let g:one_allow_italics = 1 " I love italic for comments
colorscheme one
```

iTerm2 can support italic, follow the instructions given in this [blog post by Alex Pearce](https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/).
Make sure to read the update if you are using tmux version 2.1 or above.

### True color support
To benefit from the **true color** support make sure to add the following lines in your `.vimrc` or `.config/nvim/init.vim`

```vim
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif


set background=dark " for the dark version
" set background=light " for the light version
colorscheme one
```
### Tmux support
To get true color working in tmux, ensure that the `$TERM` environment variable is set to `xterm-256color`. Inside the `.tmux.conf` file we need to override this terminal and also set the default terminal as 256 color.

```
# Add truecolor support
set-option -ga terminal-overrides ",xterm-256color:Tc"
# Default terminal is 256 colors
set -g default-terminal "screen-256color"
```

Note that this only works for Neovim (tested on 0.1.5). For some reason Vim (7.5.2334) doesn't play nice. See [blog post by Anton Kalyaev](http://homeonrails.com/2016/05/truecolor-in-gnome-terminal-tmux-and-neovim/) for more details on setting up tmux.

For Vim inside tmux, you can add the following snippet in your `~/.vimrc`

```viml
set t_8b=^[[48;2;%lu;%lu;%lum
set t_8f=^[[38;2;%lu;%lu;%lum
```

Note: the `^[` in this snippet is a real escape character. To insert it, press `Ctrl-V` and then `Esc`.

I've tested the following setup on a Mac:

* iTerm2 nightly build
* Neovim 0.1.4 and 0.1.5-dev
* Vim 7.4.1952

## Customising One without fork

Following a request to be able to customise **one** without the need to fork,
**one** is now exposing a public function to meet this requirement.

After the colorscheme has been initialised, you can call the following function:

```
one#highlight(group, fg, bg, attribute)
```

* `group`: Highlight you want to customise for example `vimLineComment`
* `fg`: foreground color for the highlight, without the '#', for example:
  `ff0000`
* `bg`: background color for the highlight, without the '#', for example:
  `ff0000`
* `attribute`: `bold`, `italic`, `underline` or any comma separated combination

For example:

```
call one#highlight('vimLineComment', 'cccccc', '', 'none')
```

## Contributors

A special thank you to the following people

* [laggardkernel](https://github.com/laggardkernel): Startup time improvement
* [Erasin](https://github.com/erasin): Rust support
* [Malcolm Ramsay - malramsay64](https://github.com/malramsay64): Gracefully fail if colorscheme is not properly loaded
* [Arthur Xavier](https://github.com/arthur-xavier): PureScript support
* [keremc](https://github.com/keremc): Tip Vim true color support inside tmux
* [jetm](https://github.com/jetm): C/C++ highlighting

[logo]: screenshots/new-logo.png

[issue_3]: https://github.com/rakr/vim-one/issues/3
[issue_21]: https://github.com/rakr/vim-one/issues/21

[pr_93]: https://github.com/rakr/vim-one/pull/93
