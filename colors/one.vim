" Name:    one vim colorscheme
" Author:  Ramzi Akremi
" License: MIT
" Version: 1.1.1-pre

" Global setup =============================================================={{{

if exists("*<SID>X")
  delf <SID>X
  delf <SID>XAPI
  delf <SID>rgb
  delf <SID>color
  delf <SID>rgb_color
  delf <SID>rgb_level
  delf <SID>rgb_number
  delf <SID>grey_color
  delf <SID>grey_level
  delf <SID>grey_number
  delf <SID>user_color_palette
endif

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = 'one'
let colors_name = 'one'

if !exists('g:one_allow_italics')
  let g:one_allow_italics = 0
endif

let s:italic = ''
let s:bold_italic = ''
if g:one_allow_italics == 1
  let s:italic = 'italic'
  let s:bold_italic = 'bold,italic'
endif

if !exists('g:one_termcolors')
  let g:one_termcolors = 1
endif

if has('gui_running') || has('termguicolors') || &t_Co == 88 || &t_Co == 256
  " functions
  " returns an approximate grey index for the given grey level

  " Utility functions -------------------------------------------------------{{{
  fun <SID>grey_number(x)
    if &t_Co == 88
      if a:x < 23
        return 0
      elseif a:x < 69
        return 1
      elseif a:x < 103
        return 2
      elseif a:x < 127
        return 3
      elseif a:x < 150
        return 4
      elseif a:x < 173
        return 5
      elseif a:x < 196
        return 6
      elseif a:x < 219
        return 7
      elseif a:x < 243
        return 8
      else
        return 9
      endif
    else
      if a:x < 14
        return 0
      else
        let l:n = (a:x - 8) / 10
        let l:m = (a:x - 8) % 10
        if l:m < 5
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " returns the actual grey level represented by the grey index
  fun <SID>grey_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 46
      elseif a:n == 2
        return 92
      elseif a:n == 3
        return 115
      elseif a:n == 4
        return 139
      elseif a:n == 5
        return 162
      elseif a:n == 6
        return 185
      elseif a:n == 7
        return 208
      elseif a:n == 8
        return 231
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 8 + (a:n * 10)
      endif
    endif
  endfun

  " returns the palette index for the given grey index
  fun <SID>grey_color(n)
    if &t_Co == 88
      if a:n == 0
        return 16
      elseif a:n == 9
        return 79
      else
        return 79 + a:n
      endif
    else
      if a:n == 0
        return 16
      elseif a:n == 25
        return 231
      else
        return 231 + a:n
      endif
    endif
  endfun

  " returns an approximate color index for the given color level
  fun <SID>rgb_number(x)
    if &t_Co == 88
      if a:x < 69
        return 0
      elseif a:x < 172
        return 1
      elseif a:x < 230
        return 2
      else
        return 3
      endif
    else
      if a:x < 75
        return 0
      else
        let l:n = (a:x - 55) / 40
        let l:m = (a:x - 55) % 40
        if l:m < 20
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " returns the actual color level for the given color index
  fun <SID>rgb_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 139
      elseif a:n == 2
        return 205
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 55 + (a:n * 40)
      endif
    endif
  endfun

  " returns the palette index for the given R/G/B color indices
  fun <SID>rgb_color(x, y, z)
    if &t_Co == 88
      return 16 + (a:x * 16) + (a:y * 4) + a:z
    else
      return 16 + (a:x * 36) + (a:y * 6) + a:z
    endif
  endfun

  " returns the palette index to approximate the given R/G/B color levels
  fun <SID>color(r, g, b)
    " get the closest grey
    let l:gx = <SID>grey_number(a:r)
    let l:gy = <SID>grey_number(a:g)
    let l:gz = <SID>grey_number(a:b)

    " get the closest color
    let l:x = <SID>rgb_number(a:r)
    let l:y = <SID>rgb_number(a:g)
    let l:z = <SID>rgb_number(a:b)

    if l:gx == l:gy && l:gy == l:gz
      " there are two possibilities
      let l:dgr = <SID>grey_level(l:gx) - a:r
      let l:dgg = <SID>grey_level(l:gy) - a:g
      let l:dgb = <SID>grey_level(l:gz) - a:b
      let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
      let l:dr = <SID>rgb_level(l:gx) - a:r
      let l:dg = <SID>rgb_level(l:gy) - a:g
      let l:db = <SID>rgb_level(l:gz) - a:b
      let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
      if l:dgrey < l:drgb
        " use the grey
        return <SID>grey_color(l:gx)
      else
        " use the color
        return <SID>rgb_color(l:x, l:y, l:z)
      endif
    else
      " only one possibility
      return <SID>rgb_color(l:x, l:y, l:z)
    endif
  endfun

  " returns the palette index to approximate the 'rrggbb' hex string
  fun <SID>rgb(rgb)
    let l:r = ('0x' . strpart(a:rgb, 0, 2)) + 0
    let l:g = ('0x' . strpart(a:rgb, 2, 2)) + 0
    let l:b = ('0x' . strpart(a:rgb, 4, 2)) + 0

    return <SID>color(l:r, l:g, l:b)
  endfun

  " sets the highlighting for the given group
  fun <SID>XAPI(group, fg, bg, attr)
    let l:attr = a:attr
    if l:attr ==? 'italic' && g:one_allow_italics == 0
      let l:attr= 'NONE'
    endif

    let l:bg = substitute(a:bg, '#', '', '')
    let l:fg = substitute(a:fg, '#', '', '')
    let l:decoration = ""

    if a:bg != ''
      let l:bg = " guibg=#" . l:bg . " ctermbg=" . <SID>rgb(l:bg)
    else
      let l:bg = " guibg=NONE ctermbg=NONE"
    endif

    if a:fg != ''
      let l:fg = " guifg=#" . l:fg . " ctermfg=" . <SID>rgb(l:fg)
    else
      let l:fg = " guifg=NONE ctermfg=NONE"
    endif

    if l:attr != ''
      let l:decoration = " gui=" . l:attr . " cterm=" . l:attr
    else
      let l:decoration = " gui=NONE cterm=NONE"
    endif

    exec "hi " . a:group . l:fg . l:bg . l:decoration

  endfun

  " Highlight function
  " the original one is borrowed from mhartington/oceanic-next
  function! <SID>X(group, fg, bg, attr, ...)
    let l:attrsp = get(a:, 1, "")

    if !empty(a:fg)
      let l:fg = " guifg=" . a:fg[0] . " ctermfg=" . a:fg[1]
    else
      let l:fg = " guifg=NONE ctermfg=NONE"
    endif

    if !empty(a:bg)
      let l:bg = " guibg=" . a:bg[0] . " ctermbg=" . a:bg[1]
    else
      let l:bg = " guibg=NONE ctermbg=NONE"
    endif

    if !empty(a:attr)
      let l:attr = " gui=" . a:attr . " cterm=" . a:attr
    else
      let l:attr = " gui=NONE cterm=NONE"
    endif

    exec "hi " . a:group . l:fg . l:bg . l:attr
  endfun

  " replace predefined colors with user defined ones
  fun <SID>user_color_palette(style)
    let l:color= ['', '']
    for i in ['mono_1', 'mono_2', 'mono_3', 'mono_4',
      \ 'hue_1', 'hue_2', 'hue_3', 'hue_4',
      \ 'hue_5', 'hue_5_2', 'hue_6', 'hue_6_2',
      \ 'syntax_bg', 'syntax_gutter', 'syntax_cursor', 'syntax_accent', 'syntax_accent_2',
      \ 'vertsplit', 'special_grey', 'visual_grey', 'pmenu',
      \ 'syntax_fg', 'syntax_fold_bg' ]
      if exists('g:one_' . a:style . '_' . i)
        exe 'let l:color[0] = g:one_' . a:style . '_' . i
        let l:color[0] = substitute(l:color[0], '#', '', '')
        let l:color[1] = <SID>rgb(l:color[0])
        let l:color[0] = '#' . l:color[0]
        exe 'let s:' . i . '=l:color'
      endif
    endfor
  endfun

  " }}}

  " Color definition --------------------------------------------------------{{{
  let s:dark = 0
  if &background ==# 'dark'
    let s:dark = 1
    let s:mono_1 = ['#abb2bf', '145']
    let s:mono_2 = ['#828997', '102']
    let s:mono_3 = ['#5c6370', '59']
    let s:mono_4 = ['#4b5263', '59']
    let s:mono_5 = ['#878700', '100'] " yellow 4

    let s:hue_1  = ['#56b6c2', '73'] " cyan

    let s:hue_2   = ['#61afef', '75'] " blue
    let s:hue_2_2 = ['#52a8ff', '69']
    let s:hue_2_3 = ['#005fff', '27']
    let s:hue_2_4 = ['#0000ff', '21']

    let s:hue_3   = ['#c678dd', '176'] " purple
    let s:hue_3_2 = ['#af5f87', '132'] " hotpink
    let s:hue_3_3 = ['#af87ff', '141'] " mediumpurple

    let s:hue_4   = ['#98c379', '114'] " green 1
    let s:hue_4_2 = ['#87875f', '101'] " wheet
    let s:hue_4_3 = ['#008700', '28'] " green 2
    let s:hue_4_4 = ['#77b04f', '114'] " green 3

    let s:hue_5   = ['#e06c75', '168'] " red 1
    let s:hue_5_2 = ['#be5046', '131'] " red 2
    let s:hue_5_3 = ['#b30000', '160'] " red 3
    let s:hue_5_4 = ['#b83d14', '131'] " red 4

    let s:hue_6   = ['#d19a66', '173'] " orange 1
    let s:hue_6_2 = ['#e5c07b', '180'] " orange 2
    let s:hue_6_3 = ['#e66700', '166'] " green
    let s:hue_6_4 = ['#af5f00', '130'] " orange 3

    let s:hue_7   = ['#87af00', '106']
    let s:hue_7_2 = ['#5fd75f', '77']
    let s:hue_7_3 = ['#00d700', '40']

    let s:hue_8   = ['#7db300', '64'] " green 3
    let s:hue_8_2 = ['#5f8700', '64'] " green 3

    let s:hue_9  = ['#5f5fd7', '62']

    let s:syntax_bg     = ['#282c34', '16']
    let s:syntax_gutter = ['#636d83', '60']
    let s:syntax_cursor = ['#2c323c', '16']

    let s:syntax_accent = ['#528bff', '69']

    let s:vertsplit    = ['#181a1f', '233']
    let s:special_grey = ['#3b4048', '16']
    let s:visual_grey  = ['#3e4452', '17']
    let s:pmenu        = ['#333841', '16']

    let s:syntax_fg = s:mono_1
    let s:syntax_fold_bg = s:mono_3

    call <SID>user_color_palette('dark')
  else
    let s:mono_1 = ['#494b53', '23']
    let s:mono_2 = ['#696c77', '60']
    let s:mono_3 = ['#a0a1a7', '145']
    let s:mono_4 = ['#c2c2c3', '250']
    let s:mono_5 = ['#8cb464', '108']

    let s:hue_1  = ['#0184bc', '31'] " cyan

    let s:hue_2   = ['#4078f2', '33'] " blue
    let s:hue_2_2 = ['#0087d7', '32'] " deep skyblue
    let s:hue_2_3 = ['#00af00', '34'] " green 2
    let s:hue_2_4 = ['#005f00', '22'] " green 3

    let s:hue_3   = ['#a626a4', '127'] " purple
    let s:hue_3_2 = ['#8787ff', '105'] " purple
    let s:hue_3_3 = ['#d700af', '163'] " purple

    let s:hue_4   = ['#50a14f', '71'] " green
    let s:hue_4_2 = ['#008700', '28'] " green 2
    let s:hue_4_3 = ['#00af87', '36'] " darkcyan
    let s:hue_4_4 = ['#005f00', '22'] " green 3

    let s:hue_5   = ['#e45649', '166'] " red 1
    let s:hue_5_2 = ['#d78700', '172'] " orange 2
    let s:hue_5_3 = ['#ff0000', '160'] " red 3
    let s:hue_5_4 = ['#b83d14', '131'] " red 4

    let s:hue_6   = ['#986801', '94'] " orange 1
    let s:hue_6_2 = ['#d75f00', '166'] " orange 3
    let s:hue_6_3 = ['#ca1243', '160'] " red 2

    let s:hue_7   = ['#ff00ff', '201']
    let s:hue_7_2 = ['#ff00ff', '171']
    let s:hue_7_3 = ['#d700ff', '165']

    let s:hue_8   = ['#005fff', '27']
    let s:hue_8_2 = ['#0000ff', '21']

    let s:hue_9  = ['#875fff', '99']

    let s:syntax_bg     = ['#fafafa', '255']
    let s:syntax_gutter = ['#9e9e9e', '247']
    let s:syntax_cursor = ['#f0f0f0', '254']

    let s:syntax_accent = ['#526fff', '63']
    let s:syntax_accent_2 = ['#0083be', '31']

    let s:vertsplit    = ['#e7e9e1', '188']
    let s:special_grey = ['#d3d3d3', '251']
    let s:visual_grey  = ['#d0d0d0', '251']
    let s:pmenu        = ['#dfdfdf', '253']

    let s:syntax_fg = s:mono_1
    let s:syntax_fold_bg = s:mono_3

    call <SID>user_color_palette('light')
  endif

  " }}}

  " Pre-define some hi groups -----------------------------------------------{{{
  call <sid>X('OneMono1', s:mono_1, '', '')
  call <sid>X('OneMono2', s:mono_2, '', '')
  call <sid>X('OneMono3', s:mono_3, '', '')
  call <sid>X('OneMono4', s:mono_4, '', '')
  call <sid>X('OneMono5', s:mono_5, '', '')

  call <sid>X('OneHue1', s:hue_1, '', '')
  call <sid>X('OneHue2', s:hue_2, '', '')
  call <sid>X('OneHue22', s:hue_2_2, '', '')
  call <sid>X('OneHue23', s:hue_2_3, '', '')
  call <sid>X('OneHue24', s:hue_2_4, '', '')
  call <sid>X('OneHue3', s:hue_3, '', '')
  call <sid>X('OneHue32', s:hue_3_2, '', '')
  call <sid>X('OneHue33', s:hue_3_3, '', '')
  call <sid>X('OneHue4', s:hue_4, '', '')
  call <sid>X('OneHue42', s:hue_4_2, '', '')
  call <sid>X('OneHue43', s:hue_4_3, '', '')
  call <sid>X('OneHue5', s:hue_5, '', '')
  call <sid>X('OneHue52', s:hue_5_2, '', '')
  call <sid>X('OneHue53', s:hue_5_3, '', '')
  call <sid>X('OneHue54', s:hue_5_4, '', '')
  call <sid>X('OneHue6', s:hue_6, '', '')
  call <sid>X('OneHue62', s:hue_6_2, '', '')
  call <sid>X('OneHue63', s:hue_6_3, '', '')
  call <sid>X('OneHue7', s:hue_7, '', '')
  call <sid>X('OneHue72', s:hue_7_2, '', '')
  call <sid>X('OneHue73', s:hue_7_3, '', '')
  call <sid>X('OneHue8', s:hue_8, '', '')
  call <sid>X('OneHue82', s:hue_8_2, '', '')
  call <sid>X('OneHue9', s:hue_9, '', '')

  hi! link OneSyntaxFg OneMono1
  " }}}

  " Vim editor color --------------------------------------------------------{{{
  call <sid>X('Normal',       s:syntax_fg,     s:syntax_bg,      '')
  call <sid>X('bold',         '',              '',               'bold')
  call <sid>X('ColorColumn',  '',              s:syntax_cursor,  '')
  call <sid>X('Conceal',      s:mono_4,        s:syntax_bg,      '')
  call <sid>X('Cursor',       '',              s:syntax_accent,  '')
  call <sid>X('CursorIM',     '',              '',               '')
  call <sid>X('CursorColumn', '',              s:syntax_cursor,  '')
  call <sid>X('CursorLine',   '',              s:syntax_cursor,  'none')
  hi! link Directory OneHue2
  call <sid>X('ErrorMsg',     s:hue_5,         s:syntax_bg,      'none')
  call <sid>X('VertSplit',    s:vertsplit,     '',               'none')
  call <sid>X('Folded',       s:syntax_bg,     s:syntax_fold_bg, 'none')
  call <sid>X('FoldColumn',   s:mono_3,        s:syntax_cursor,  '')
  call <sid>X('IncSearch',    s:hue_6,         '',               'reverse')
  hi! link LineNr OneMono4
  call <sid>X('CursorLineNr', s:syntax_fg,     s:syntax_cursor,  'none')
  call <sid>X('MatchParen',   s:hue_5,         s:syntax_cursor,  'underline,bold')
  call <sid>X('Italic',       '',              '',               s:italic)
  hi! link ModeMsg OneSyntaxFg
  hi! link MoreMsg OneSyntaxFg
  call <sid>X('NonText',      s:mono_3,        '',               'none')
  call <sid>X('PMenu',        '',              s:pmenu,          '')
  call <sid>X('PMenuSel',     '',              s:mono_4,         '')
  call <sid>X('PMenuSbar',    '',              s:syntax_bg,      '')
  call <sid>X('PMenuThumb',   '',              s:mono_1,         '')
  hi! link Question OneHue2
  call <sid>X('Search',       s:syntax_bg,     s:hue_6_2,        '')
  call <sid>X('SpecialKey',   s:special_grey,  '',               'none')
  call <sid>X('Whitespace',   s:special_grey,  '',               'none')
  call <sid>X('StatusLine',   s:syntax_fg,     s:syntax_cursor,  'none')
  call <sid>X('StatusLineNC', s:mono_3,        '',               'reverse')
  call <sid>X('TabLine',      s:mono_2,        s:visual_grey,    'none')
  call <sid>X('TabLineFill',  s:mono_3,        s:visual_grey,    'none')
  call <sid>X('TabLineSel',   s:syntax_bg,     s:hue_2,          '')
  call <sid>X('Title',        s:syntax_fg,     '',               'bold')
  call <sid>X('Visual',       '',              s:visual_grey,    '')
  call <sid>X('VisualNOS',    '',              s:visual_grey,    '')
  hi! link WarningMsg OneHue5
  hi! link TooLong OneHue5
  call <sid>X('WildMenu',     s:syntax_fg,     s:mono_3,         '')
  call <sid>X('SignColumn',   '',              s:syntax_bg,      '')
  hi! link Special OneHue2
  " }}}

  " Vim Help highlighting ---------------------------------------------------{{{
  hi! link helpCommand OneHue62
  hi! link helpExample OneHue62
  call <sid>X('helpHeader',       s:mono_1,  '', 'bold')
  hi! link helpSectionDelim OneMono3
  " }}}

  " Standard syntax highlighting --------------------------------------------{{{
  call <sid>X('Comment',        s:mono_3,        '',          s:italic)
  hi! link Constant OneHue4
  hi! link String OneHue4
  hi! link Character OneHue4
  hi! link Number OneHue6
  hi! link Boolean OneHue6
  hi! link Float OneHue6
  call <sid>X('Identifier',     s:hue_5,         '',          'none')
  hi! link Function OneHue2
  hi! link Statement OneHue3
  hi! link Conditional OneHue3
  hi! link Repeat OneHue3
  hi! link Label OneHue3
  call <sid>X('Operator',       s:syntax_accent, '',          'none')
  hi! link Keyword OneHue5
  hi! link Exception OneHue3
  hi! link PreProc OneHue62
  hi! link Include OneHue2
  hi! link Define OneHue3
  hi! link Macro OneHue3
  hi! link PreCondit OneHue62
  hi! link Type OneHue62
  hi! link StorageClass OneHue62
  hi! link Structure OneHue62
  hi! link Typedef OneHue62
  call <sid>X('SpecialChar',    '',              '',          '')
  call <sid>X('Tag',            '',              '',          '')
  call <sid>X('Delimiter',      '',              '',          '')
  call <sid>X('Debug',          '',              '',          '')
  call <sid>X('Underlined',     '',              '',          'underline')
  call <sid>X('Ignore',         '',              '',          '')
  call <sid>X('Error',          s:hue_5,         s:syntax_bg, 'bold')
  hi! link Todo OneHue3
  " }}}

  " Diff highlighting -------------------------------------------------------{{{
  " :h diff
  " Vimdiff color source, from
  " - red, green from Atom One
  " - purple from Kaledoscope
  if &background == 'light'
    call <sid>X('DiffAdd',    ['#022B00', '233'], ['#D9FBE3', '194'], '')
    call <sid>X('DiffDelete', ['#FBE1E4', '224'], ['#FBE1E4', '224'], 'none')
    call <sid>X('DiffChange', s:mono_1,           ['#F6F1FF', '231'], '')
    call <sid>X('DiffText',   ['#1E162F', '235'], ['#D4BDFF', '183'], 'none')
  elseif &background == 'dark'
    call <sid>X('DiffAdd',    ['#D9FBE3', '194'], ['#264B3A', '237'], '')
    call <sid>X('DiffDelete', ['#48313B', '237'], ['#48313B', '237'],  'none')
    call <sid>X('DiffChange', s:mono_1,           ['#3B2C5C', '238'], '')
    call <sid>X('DiffText',   ['#F6F1FF', '231'], ['#6548A3',  '61'], 'none')
  endif

  " For patch like format file, defined in runtime/syntax/diff.vim
  " Don't use bg, unlike vimdiff view, the bg color is not rendered in full width
  " in diff syntax (patch file)
  " diff headers
  hi! link DiffIndexLine Title
  hi! link DiffLine      Title
  hi! link DiffSubname   OneHue62
  hi! link DiffFile      Title
  hi! link DiffNewFile   OneHue4
  hi! link DiffOldFile   OneHue5
  " diff content
  hi! link DiffAdded   OneHue4
  hi! link DiffRemoved OneHue5
  hi! link DiffChanged OneHue2
  hi! link DiffComment Comment
  " }}}

  " Asciidoc highlighting ---------------------------------------------------{{{
  hi! link asciidocListingBlock OneMono2
  " }}}

  " C/C++ highlighting ------------------------------------------------------{{{
  " adjust the order similar to vim 'syntax:group-name' help
  hi! link cComment Comment
  hi! link cCommentL Comment

  hi! link cConstant OneHue53
  hi! link cString OneHue4
  hi! link cNumber OneHue53
  hi! link cOctal OneHue53
  hi! link cBoolean OneHue52
  hi! link cFloat OneHue53

  hi! link cIdentifier OneHue9
  hi! link cFunction OneHue22

  hi! link cStatement OneHue3
  hi! link cConditional OneHue63
  hi! link cRepeat OneHue63
  hi! link cLabel OneHue63
  hi! link cUserLabel OneHue32
  hi! link cOperator OneHue32
  hi! link cCustomOperator OneHue72
  hi! link cKeyword OneHue3
  hi! link cSpecialKeyword OneHue63
  hi! link cGotoKeyword OneHue53
  hi! link cExtLangKeyword OneHue53

  hi! link cPreProc OneHue52
  hi! link cInclude OneHue3
  hi! link cDefine OneHue32
  hi! link cMacro OneHue52
  hi! link cPreCondit OneHue52
  hi! link cPreConditMatch OneHue52

  hi! link cType OneHue3
  hi! link cStorageClass OneHue3
  hi! link cStructure OneHue3
  hi! link cTypedef OneHue3
  hi! link cMemberVar OneHue43
  hi! link cStructDeclare OneHue23

  hi! link cSpecial OneHue1
  hi! link cSpecialCharacter OneHue1
  hi! link cDelimiter OneHue9
  hi! link cSpecialDelimiter OneHue63
  hi! link cTODO OneHue3

  hi! link cppConstant OneHue52
  hi! link cppString OneHue4
  hi! link cppNumber OneHue53
  hi! link cppBoolean OneHue52
  hi! link cppFloat OneHue53

  hi! link cppIdentifier OneHue9

  hi! link cppStatement OneHue63
  hi! link cppLabel OneHue8
  hi! link cppOperator OneHue32
  hi! link cppCustomOperator OneHue72
  hi! link cppKeyword OneHue72
  hi! link cppExceptions OneHue6
  hi! link cppSTLExceptions OneHue6

  hi! link cppDelimiter OneHue9

  hi! link cppType OneHue3
  hi! link cppStorageClass OneHue3
  hi! link cppStructure OneHue63
  hi! link cppTypedef OneHue62
  hi! link cppTemplateImpl OneHue42
  hi! link cppStructDeclare OneHue23

  hi! link cppModifier OneHue3
  hi! link cppAccess OneHue63
  hi! link cppClassScope OneHue82
  hi! link cppNamespace OneHue82
  ".}}}

  " Cucumber highlighting ---------------------------------------------------{{{
  hi! link cucumberGiven OneHue2
  hi! link cucumberWhen OneHue2
  hi! link cucumberWhenAnd OneHue2
  hi! link cucumberThen OneHue2
  hi! link cucumberThenAnd OneHue2
  hi! link cucumberUnparsed OneHue6
  call <sid>X('cucumberFeature',         s:hue_5,  '', 'bold')
  hi! link cucumberBackground OneHue3
  hi! link cucumberScenario OneHue3
  hi! link cucumberScenarioOutline OneHue3
  call <sid>X('cucumberTags',            s:mono_3, '', 'bold')
  call <sid>X('cucumberDelimiter',       s:mono_3, '', 'bold')
  " }}}

  " CSS/Sass highlighting ---------------------------------------------------{{{
  hi! link cssAttrComma OneHue3
  hi! link cssAttributeSelector OneHue4
  hi! link cssBraces OneMono2
  hi! link cssClassName OneHue6
  hi! link cssClassNameDot OneHue6
  hi! link cssDefinition OneHue3
  hi! link cssFontAttr OneHue6
  hi! link cssFontDescriptor OneHue3
  hi! link cssFunctionName OneHue2
  hi! link cssIdentifier OneHue2
  hi! link cssImportant OneHue3
  hi! link cssInclude OneMono1
  hi! link cssIncludeKeyword OneHue3
  hi! link cssMediaType OneHue6
  hi! link cssProp OneHue1
  hi! link cssPseudoClassId OneHue6
  hi! link cssSelectorOp OneHue3
  hi! link cssSelectorOp2 OneHue3
  hi! link cssStringQ OneHue4
  hi! link cssStringQQ OneHue4
  hi! link cssTagName OneHue5
  hi! link cssAttr OneHue6

  hi! link sassAmpersand OneHue5
  hi! link sassClass OneHue62
  hi! link sassControl OneHue3
  hi! link sassExtend OneHue3
  hi! link sassFor OneMono1
  hi! link sassProperty OneHue1
  hi! link sassFunction OneHue1
  hi! link sassId OneHue2
  hi! link sassInclude OneHue3
  hi! link sassMedia OneHue3
  hi! link sassMediaOperators OneMono1
  hi! link sassMixin OneHue3
  hi! link sassMixinName OneHue2
  hi! link sassMixing OneHue3

  hi! link scssSelectorName OneHue62
  " }}}

  " Elixir highlighting------------------------------------------------------{{{
  hi! link elixirModuleDefine Define
  hi! link elixirAlias OneHue62
  hi! link elixirAtom OneHue1
  hi! link elixirBlockDefinition OneHue3
  hi! link elixirModuleDeclaration OneHue6
  hi! link elixirInclude OneHue5
  hi! link elixirOperator OneHue6
  " }}}

  " Git and git related plugins highlighting --------------------------------{{{
  hi! link gitcommitComment OneMono3
  hi! link gitcommitUnmerged OneHue4
  call <sid>X('gitcommitOnBranch',      '',        '', '')
  hi! link gitcommitBranch OneHue3
  hi! link gitcommitDiscardedType OneHue5
  hi! link gitcommitSelectedType OneHue4
  call <sid>X('gitcommitHeader',        '',        '', '')
  hi! link gitcommitUntrackedFile OneHue1
  hi! link gitcommitDiscardedFile OneHue5
  hi! link gitcommitSelectedFile OneHue4
  hi! link gitcommitUnmergedFile OneHue62
  call <sid>X('gitcommitFile',          '',        '', '')
  hi! link gitcommitNoBranch       gitcommitBranch
  hi! link gitcommitUntracked      gitcommitComment
  hi! link gitcommitDiscarded      gitcommitComment
  hi! link gitcommitSelected       gitcommitComment
  hi! link gitcommitDiscardedArrow gitcommitDiscardedFile
  hi! link gitcommitSelectedArrow  gitcommitSelectedFile
  hi! link gitcommitUnmergedArrow  gitcommitUnmergedFile

  hi! link SignifySignAdd OneHue4
  hi! link SignifySignChange OneHue62
  hi! link SignifySignDelete OneHue5
  hi! link GitGutterAdd    SignifySignAdd
  hi! link GitGutterChange SignifySignChange
  hi! link GitGutterDelete SignifySignDelete
  " }}}

  " Go highlighting ---------------------------------------------------------{{{
  hi! link goDeclaration OneHue3
  hi! link goField OneHue5
  hi! link goMethod OneHue1
  hi! link goType OneHue3
  hi! link goUnsignedInts OneHue1
  " }}}

  " Haskell highlighting ----------------------------------------------------{{{
  hi! link haskellDeclKeyword OneHue2
  hi! link haskellType OneHue4
  hi! link haskellWhere OneHue5
  hi! link haskellImportKeywords OneHue2
  hi! link haskellOperators OneHue5
  hi! link haskellDelimiter OneHue2
  hi! link haskellIdentifier OneHue6
  hi! link haskellKeyword OneHue5
  hi! link haskellNumber OneHue1
  hi! link haskellString OneHue1
  "}}}

  " HTML highlighting -------------------------------------------------------{{{
  hi! link htmlArg OneHue6
  hi! link htmlTagName OneHue5
  hi! link htmlTagN OneHue5
  hi! link htmlSpecialTagName OneHue5
  hi! link htmlTag OneMono2
  hi! link htmlEndTag OneMono2

  call <sid>X('MatchTag', s:hue_5, s:syntax_cursor, 'underline,bold')
  " }}}

  " JavaScript highlighting -------------------------------------------------{{{
  hi! link coffeeString OneHue4

  hi! link javaScriptBraces OneMono2
  hi! link javaScriptFunction OneHue3
  hi! link javaScriptNull OneHue6
  hi! link javaScriptNumber OneHue6
  hi! link javaScriptRequire OneHue1
  hi! link javaScriptReserved OneHue3
  " https://github.com/pangloss/vim-javascript
  hi! link jsArrowFunction OneHue3
  hi! link jsBraces OneMono2
  hi! link jsClassBraces OneMono2
  hi! link jsClassKeywords OneHue3
  hi! link jsDocParam OneHue2
  hi! link jsDocTags OneHue3
  hi! link jsFuncBraces OneMono2
  hi! link jsFuncCall OneHue2
  hi! link jsFuncParens OneMono2
  hi! link jsFunction OneHue3
  hi! link jsGlobalObjects OneHue62
  hi! link jsModuleWords OneHue3
  hi! link jsModules OneHue3
  hi! link jsNoise OneMono2
  hi! link jsNull OneHue6
  hi! link jsOperator OneHue3
  hi! link jsParens OneMono2
  hi! link jsStorageClass OneHue3
  hi! link jsTemplateBraces OneHue52
  hi! link jsTemplateVar OneHue4
  hi! link jsThis OneHue5
  hi! link jsUndefined OneHue6
  hi! link jsObjectValue OneHue2
  hi! link jsObjectKey OneHue1
  hi! link jsReturn OneHue3
  " https://github.com/othree/yajs.vim
  hi! link javascriptArrowFunc OneHue3
  hi! link javascriptClassExtends OneHue3
  hi! link javascriptClassKeyword OneHue3
  hi! link javascriptDocNotation OneHue3
  hi! link javascriptDocParamName OneHue2
  hi! link javascriptDocTags OneHue3
  hi! link javascriptEndColons OneMono3
  hi! link javascriptExport OneHue3
  hi! link javascriptFuncArg OneMono1
  hi! link javascriptFuncKeyword OneHue3
  hi! link javascriptIdentifier OneHue5
  hi! link javascriptImport OneHue3
  hi! link javascriptObjectLabel OneMono1
  hi! link javascriptOpSymbol OneHue1
  hi! link javascriptOpSymbols OneHue1
  hi! link javascriptPropertyName OneHue4
  hi! link javascriptTemplateSB OneHue52
  hi! link javascriptVariable OneHue3
  " }}}

  " JSON highlighting -------------------------------------------------------{{{
  hi! link jsonCommentError OneMono1
  hi! link jsonKeyword OneHue5
  hi! link jsonQuote OneMono3
  call <sid>X('jsonTrailingCommaError',   s:hue_5,   '', 'reverse' )
  call <sid>X('jsonMissingCommaError',    s:hue_5,   '', 'reverse' )
  call <sid>X('jsonNoQuotesError',        s:hue_5,   '', 'reverse' )
  call <sid>X('jsonNumError',             s:hue_5,   '', 'reverse' )
  hi! link jsonString OneHue4
  hi! link jsonBoolean OneHue3
  hi! link jsonNumber OneHue6
  call <sid>X('jsonStringSQError',        s:hue_5,   '', 'reverse' )
  call <sid>X('jsonSemicolonError',       s:hue_5,   '', 'reverse' )
  " }}}

  " Markdown highlighting ---------------------------------------------------{{{
  hi! link markdownUrl OneMono3
  call <sid>X('markdownBold',             s:hue_6,   '', 'bold')
  call <sid>X('markdownItalic',           s:hue_6,   '', s:italic)
  call <sid>X('markdownBoldItalic',       s:hue_6,   '', s:bold_italic)
  hi! link markdownCode OneHue4
  hi! link markdownCodeBlock OneHue5
  hi! link markdownCodeDelimiter OneHue4
  hi! link markdownHeadingDelimiter OneHue52
  hi! link markdownH1 OneHue5
  hi! link markdownH2 OneHue5
  hi! link markdownH3 OneHue5
  hi! link markdownH4 OneHue5
  hi! link markdownH5 OneHue5
  hi! link markdownH6 OneHue5
  hi! link markdownListMarker OneHue5
  " }}}

  " Perl highlighting -------------------------------------------------------{{{
  call <sid>X('perlFunction',      s:hue_3,     '', '')
  call <sid>X('perlMethod',        s:syntax_fg, '', '')
  call <sid>X('perlPackageConst',  s:hue_3,     '', '')
  call <sid>X('perlPOD',           s:mono_3,    '', '')
  call <sid>X('perlSubName',       s:syntax_fg, '', '')
  call <sid>X('perlSharpBang',     s:mono_3,    '', '')
  call <sid>X('perlSpecialString', s:hue_4,     '', '')
  call <sid>X('perlVarPlain',      s:hue_2,     '', '')
  call <sid>X('podCommand',        s:mono_3,    '', '')
  " }}}

  " PHP highlighting --------------------------------------------------------{{{
  hi! link phpClass OneHue62
  hi! link phpFunction OneHue2
  hi! link phpFunctions OneHue2
  hi! link phpInclude OneHue3
  hi! link phpKeyword OneHue3
  hi! link phpParent OneMono3
  hi! link phpType OneHue3
  hi! link phpSuperGlobals OneHue5
  " }}}

  " Pug (Formerly Jade) highlighting ----------------------------------------{{{
  hi! link pugAttributesDelimiter OneHue6
  hi! link pugClass OneHue6
  call <sid>X('pugDocType',               s:mono_3,   '', s:italic)
  hi! link pugTag OneHue5
  " }}}

  " PureScript highlighting -------------------------------------------------{{{
  hi! link purescriptKeyword OneHue3
  hi! link purescriptModuleName OneSyntaxFg
  hi! link purescriptIdentifier OneSyntaxFg
  hi! link purescriptType OneHue62
  hi! link purescriptTypeVar OneHue5
  hi! link purescriptConstructor OneHue5
  hi! link purescriptOperator OneSyntaxFg
  " }}}

  " Python highlighting -----------------------------------------------------{{{
  hi! link pythonImport OneHue3
  hi! link pythonBuiltin OneHue1
  hi! link pythonStatement OneHue3
  hi! link pythonParam OneHue6
  hi! link pythonEscape OneHue5
  call <sid>X('pythonSelf',                 s:mono_2,    '', s:italic)
  hi! link pythonClass OneHue2
  hi! link pythonOperator OneHue3
  hi! link pythonFunction OneHue2
  hi! link pythonKeyword OneHue2
  hi! link pythonModule OneHue3
  hi! link pythonStringDelimiter OneHue4
  hi! link pythonSymbol OneHue1
  " }}}

  " Ruby highlighting -------------------------------------------------------{{{
  hi! link rubyBlock OneHue3
  hi! link rubyBlockParameter OneHue5
  hi! link rubyBlockParameterList OneHue5
  hi! link rubyCapitalizedMethod OneHue3
  hi! link rubyClass OneHue3
  hi! link rubyConstant OneHue62
  hi! link rubyControl OneHue3
  hi! link rubyDefine OneHue3
  hi! link rubyEscape OneHue5
  hi! link rubyFunction OneHue2
  hi! link rubyGlobalVariable OneHue5
  hi! link rubyInclude OneHue2
  hi! link rubyIncluderubyGlobalVariable OneHue5
  hi! link rubyInstanceVariable OneHue5
  hi! link rubyInterpolation OneHue1
  hi! link rubyInterpolationDelimiter OneHue5
  hi! link rubyKeyword OneHue2
  hi! link rubyModule OneHue3
  hi! link rubyPseudoVariable OneHue5
  hi! link rubyRegexp OneHue1
  hi! link rubyRegexpDelimiter OneHue1
  hi! link rubyStringDelimiter OneHue4
  hi! link rubySymbol OneHue1
  " }}}

  " Spelling highlighting ---------------------------------------------------{{{
  call <sid>X('SpellBad',     '', s:syntax_bg, 'undercurl')
  call <sid>X('SpellLocal',   '', s:syntax_bg, 'undercurl')
  call <sid>X('SpellCap',     '', s:syntax_bg, 'undercurl')
  call <sid>X('SpellRare',    '', s:syntax_bg, 'undercurl')
  " }}}

  " Vim highlighting --------------------------------------------------------{{{
  hi! link vimCommand OneHue3
  call <sid>X('vimCommentTitle', s:mono_3, '', 'bold')
  hi! link vimFunction OneHue1
  hi! link vimFuncName OneHue3
  hi! link vimHighlight OneHue2
  call <sid>X('vimLineComment',  s:mono_3, '', s:italic)
  hi! link vimParenSep OneMono2
  hi! link vimSep OneMono2
  hi! link vimUserFunc OneHue1
  hi! link vimVar OneHue5
  " }}}

  " XML highlighting --------------------------------------------------------{{{
  hi! link xmlAttrib OneHue62
  hi! link xmlEndTag OneHue5
  hi! link xmlTag OneHue5
  hi! link xmlTagName OneHue5
  " }}}

  " ZSH highlighting --------------------------------------------------------{{{
  hi! link zshCommands OneSyntaxFg
  hi! link zshDeref OneHue5
  hi! link zshShortDeref OneHue5
  hi! link zshFunction OneHue1
  hi! link zshKeyword OneHue3
  hi! link zshSubst OneHue5
  hi! link zshSubstDelim OneMono3
  hi! link zshTypes OneHue3
  hi! link zshVariableDef OneHue6
  " }}}

  " Rust highlighting -------------------------------------------------------{{{
  call <sid>X('rustExternCrate',          s:hue_5,    '', 'bold')
  hi! link rustIdentifier OneHue2
  hi! link rustDeriveTrait OneHue4
  hi! link SpecialComment OneMono3
  hi! link rustCommentLine OneMono3
  hi! link rustCommentLineDoc OneMono3
  hi! link rustCommentLineDocError OneMono3
  hi! link rustCommentBlock OneMono3
  hi! link rustCommentBlockDoc OneMono3
  hi! link rustCommentBlockDocError OneMono3
  " }}}

  " man highlighting --------------------------------------------------------{{{
  hi! link manTitle String
  hi! link manFooter OneMono3
  " }}}

  " ALE (Asynchronous Lint Engine) highlighting -----------------------------{{{
  hi! link ALEWarningSign OneHue62
  hi! link ALEErrorSign OneHue5
  " }}}

  " Neovim NERDTree Background fix ------------------------------------------{{{
  hi! link NERDTreeFile OneSyntaxFg
  " }}}

  " Neovim Terminal Colors --------------------------------------------------{{{
  if has('nvim') && g:one_termcolors != 0
    let g:terminal_color_0  = "#353a44"
    let g:terminal_color_8  = "#353a44"
    let g:terminal_color_1  = "#e88388"
    let g:terminal_color_9  = "#e88388"
    let g:terminal_color_2  = "#a7cc8c"
    let g:terminal_color_10 = "#a7cc8c"
    let g:terminal_color_3  = "#ebca8d"
    let g:terminal_color_11 = "#ebca8d"
    let g:terminal_color_4  = "#72bef2"
    let g:terminal_color_12 = "#72bef2"
    let g:terminal_color_5  = "#d291e4"
    let g:terminal_color_13 = "#d291e4"
    let g:terminal_color_6  = "#65c2cd"
    let g:terminal_color_14 = "#65c2cd"
    let g:terminal_color_7  = "#e3e5e9"
    let g:terminal_color_15 = "#e3e5e9"
  endif
  " }}}

  " Delete functions =========================================================={{{
  " delf <SID>X
  " delf <SID>XAPI
  " delf <SID>rgb
  " delf <SID>color
  " delf <SID>rgb_color
  " delf <SID>rgb_level
  " delf <SID>rgb_number
  " delf <SID>grey_color
  " delf <SID>grey_level
  " delf <SID>grey_number
  " delf <SID>user_color_palette
  " }}}

endif
"}}}

" Public API --------------------------------------------------------------{{{
function! one#highlight(group, fg, bg, attr)
  call <sid>XAPI(a:group, a:fg, a:bg, a:attr)
endfunction

function! one#rgb(c)
  return <sid>rgb(a:c)
endfunction
"}}}

if exists('s:dark') && s:dark
  set background=dark
endif

" vim: set fdl=0 fdm=marker:
