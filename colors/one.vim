" Name:    one vim colorscheme
" Author:  Ramzi Akremi
" License: MIT
" Version: 1.1.1-pre

" Global setup =============================================================={{{

if exists("*<SID>X")
  delf <SID>X
  delf <SID>rgb
  delf <SID>color
  delf <SID>rgb_color
  delf <SID>rgb_level
  delf <SID>rgb_number
  delf <SID>grey_color
  delf <SID>grey_level
  delf <SID>grey_number
endif

hi clear
syntax reset
if exists('g:colors_name')
  unlet g:colors_name
endif
let g:colors_name = 'one'

if !exists('g:one_allow_italics')
  let g:one_allow_italics = 0
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
  fun <sid>X(group, fg, bg, attr)
    let l:attr = a:attr
    if g:one_allow_italics == 0 && l:attr ==? 'italic'
      let l:attr= 'none'
    endif

    let l:bg = ""
    let l:fg = ""
    let l:decoration = ""

    if a:bg != ''
      let l:bg = " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
    endif

    if a:fg != ''
      let l:fg = " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
    endif

    if a:attr != ''
      let l:decoration = " gui=" . l:attr . " cterm=" . l:attr
    endif

    let l:exec = l:fg . l:bg . l:decoration

    if l:exec != ''
      exec "hi " . a:group . l:exec
    endif

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

    let s:hue_1  = ['#56b6c2', '73'] " cyan
    let s:hue_2  = ['#61afef', '75'] " blue
    let s:hue_3  = ['#c678dd', '176'] " purple
    let s:hue_4  = ['#98c379', '114'] " green

    let s:hue_5   = ['#e06c75', '168'] " red 1
    let s:hue_5_2 = ['#be5046', '130'] " red 2

    let s:hue_6   = ['#d19a66', '173'] " orange 1
    let s:hue_6_2 = ['#e5c07b', '180'] " orange 2

    let s:syntax_bg     = ['#282c34', '16']
    let s:syntax_gutter = ['#636d83', '60']
    let s:syntax_cursor = ['#2c323c', '16']

    let s:syntax_accent = ['#528bff', '69']

    let s:vertsplit    = ['#181a1f', '233']
    let s:special_grey = ['#3b4048', '16']
    let s:visual_grey  = ['#3e4452', '17']
    let s:pmenu        = ['#333841', '16']
  else
    let s:mono_1 = ['#494b53', '23']
    let s:mono_2 = ['#696c77', '60']
    let s:mono_3 = ['#a0a1a7', '145']
    let s:mono_4 = ['#c2c2c3', '250']

    let s:hue_1  = ['#0184bc', '31'] " cyan
    let s:hue_2  = ['#4078f2', '33'] " blue
    let s:hue_3  = ['#a626a4', '127'] " purple
    let s:hue_4  = ['#50a14f', '71'] " green

    let s:hue_5   = ['#e45649', '166'] " red 1
    let s:hue_5_2 = ['#ca1243', '160'] " red 2

    let s:hue_6   = ['#986801', '94'] " orange 1
    let s:hue_6_2 = ['#c18401', '136'] " orange 2

    let s:syntax_bg     = ['#fafafa', '255']
    let s:syntax_gutter = ['#9e9e9e', '247']
    let s:syntax_cursor = ['#f0f0f0', '254']

    let s:syntax_accent = ['#526fff', '63']
    let s:syntax_accent_2 = ['#0083be', '31']

    let s:vertsplit    = ['#e7e9e1', '188']
    let s:special_grey = ['#d3d3d3', '251']
    let s:visual_grey  = ['#d0d0d0', '251']
    let s:pmenu        = ['#dfdfdf', '253']
  endif

  let s:syntax_fg = s:mono_1
  let s:syntax_fold_bg = s:mono_3

  " }}}

  if &background ==# 'dark'
    " Dark Italic {{{
    hi Normal guifg=#abb2bf ctermfg=145 guibg=#282c34 ctermbg=16
    hi bold gui=bold cterm=bold
    hi ColorColumn guibg=#2c323c ctermbg=16
    hi Conceal guifg=#4b5263 ctermfg=59 guibg=#282c34 ctermbg=16
    hi Cursor guibg=#528bff ctermbg=69
    hi CursorColumn guibg=#2c323c ctermbg=16
    hi CursorLine guibg=#2c323c ctermbg=16 gui=none cterm=none
    hi Directory guifg=#61afef ctermfg=75
    hi ErrorMsg guifg=#e06c75 ctermfg=168 guibg=#282c34 ctermbg=16 gui=none cterm=none
    hi VertSplit guifg=#181a1f ctermfg=233 gui=none cterm=none
    hi Folded guifg=#282c34 ctermfg=16 guibg=#5c6370 ctermbg=59 gui=none cterm=none
    hi FoldColumn guifg=#5c6370 ctermfg=59 guibg=#2c323c ctermbg=16
    hi IncSearch guifg=#d19a66 ctermfg=173
    hi LineNr guifg=#4b5263 ctermfg=59
    hi CursorLineNr guifg=#abb2bf ctermfg=145 guibg=#2c323c ctermbg=16 gui=none cterm=none
    hi MatchParen guifg=#e06c75 ctermfg=168 guibg=#2c323c ctermbg=16 gui=underline,bold cterm=underline,bold
    hi Italic gui=italic cterm=italic
    hi ModeMsg guifg=#abb2bf ctermfg=145
    hi MoreMsg guifg=#abb2bf ctermfg=145
    hi NonText guifg=#5c6370 ctermfg=59 gui=none cterm=none
    hi PMenu guibg=#333841 ctermbg=16
    hi PMenuSel guibg=#4b5263 ctermbg=59
    hi PMenuSbar guibg=#282c34 ctermbg=16
    hi PMenuThumb guibg=#abb2bf ctermbg=145
    hi Question guifg=#61afef ctermfg=75
    hi Search guifg=#282c34 ctermfg=16 guibg=#e5c07b ctermbg=180
    hi SpecialKey guifg=#3b4048 ctermfg=16 gui=none cterm=none
    hi Whitespace guifg=#3b4048 ctermfg=16 gui=none cterm=none
    hi StatusLine guifg=#abb2bf ctermfg=145 guibg=#2c323c ctermbg=16 gui=none cterm=none
    hi StatusLineNC guifg=#5c6370 ctermfg=59
    hi TabLine guifg=#abb2bf ctermfg=145 guibg=#282c34 ctermbg=16
    hi TabLineFill guifg=#5c6370 ctermfg=59 guibg=#3e4452 ctermbg=17 gui=none cterm=none
    hi TabLineSel guifg=#282c34 ctermfg=16 guibg=#61afef ctermbg=75
    hi Title guifg=#abb2bf ctermfg=145 gui=bold cterm=bold
    hi Visual guibg=#3e4452 ctermbg=17
    hi VisualNOS guibg=#3e4452 ctermbg=17
    hi WarningMsg guifg=#e06c75 ctermfg=168
    hi TooLong guifg=#e06c75 ctermfg=168
    hi WildMenu guifg=#abb2bf ctermfg=145 guibg=#5c6370 ctermbg=59
    hi SignColumn guibg=#282c34 ctermbg=16
    hi Special guifg=#61afef ctermfg=75
    hi helpCommand guifg=#e5c07b ctermfg=180
    hi helpExample guifg=#e5c07b ctermfg=180
    hi helpHeader guifg=#abb2bf ctermfg=145 gui=bold cterm=bold
    hi helpSectionDelim guifg=#5c6370 ctermfg=59
    hi Comment guifg=#5c6370 ctermfg=59 gui=italic cterm=italic
    hi Constant guifg=#98c379 ctermfg=114
    hi String guifg=#98c379 ctermfg=114
    hi Character guifg=#98c379 ctermfg=114
    hi Number guifg=#d19a66 ctermfg=173
    hi Boolean guifg=#d19a66 ctermfg=173
    hi Float guifg=#d19a66 ctermfg=173
    hi Identifier guifg=#e06c75 ctermfg=168 gui=none cterm=none
    hi Function guifg=#61afef ctermfg=75
    hi Statement guifg=#c678dd ctermfg=176 gui=none cterm=none
    hi Conditional guifg=#c678dd ctermfg=176
    hi Repeat guifg=#c678dd ctermfg=176
    hi Label guifg=#c678dd ctermfg=176
    hi Operator guifg=#528bff ctermfg=69 gui=none cterm=none
    hi Keyword guifg=#e06c75 ctermfg=168
    hi Exception guifg=#c678dd ctermfg=176
    hi PreProc guifg=#e5c07b ctermfg=180
    hi Include guifg=#61afef ctermfg=75
    hi Define guifg=#c678dd ctermfg=176 gui=none cterm=none
    hi Macro guifg=#c678dd ctermfg=176
    hi PreCondit guifg=#e5c07b ctermfg=180
    hi Type guifg=#e5c07b ctermfg=180 gui=none cterm=none
    hi StorageClass guifg=#e5c07b ctermfg=180
    hi Structure guifg=#e5c07b ctermfg=180
    hi Typedef guifg=#e5c07b ctermfg=180
    hi Special guifg=#61afef ctermfg=75
    hi Underlined gui=underline cterm=underline
    hi Error guifg=#e06c75 ctermfg=168 guibg=#282c34 ctermbg=16 gui=bold cterm=bold
    hi Todo guifg=#c678dd ctermfg=176 guibg=#282c34 ctermbg=16
    hi DiffAdd guifg=#98c379 ctermfg=114 guibg=#3e4452 ctermbg=17
    hi DiffChange guifg=#d19a66 ctermfg=173 guibg=#3e4452 ctermbg=17
    hi DiffDelete guifg=#e06c75 ctermfg=168 guibg=#3e4452 ctermbg=17
    hi DiffText guifg=#61afef ctermfg=75 guibg=#3e4452 ctermbg=17
    hi DiffAdded guifg=#98c379 ctermfg=114 guibg=#3e4452 ctermbg=17
    hi DiffFile guifg=#e06c75 ctermfg=168 guibg=#3e4452 ctermbg=17
    hi DiffNewFile guifg=#98c379 ctermfg=114 guibg=#3e4452 ctermbg=17
    hi DiffLine guifg=#61afef ctermfg=75 guibg=#3e4452 ctermbg=17
    hi DiffRemoved guifg=#e06c75 ctermfg=168 guibg=#3e4452 ctermbg=17
    hi asciidocListingBlock guifg=#828997 ctermfg=102
    hi cInclude guifg=#c678dd ctermfg=176
    hi cPreCondit guifg=#c678dd ctermfg=176
    hi cPreConditMatch guifg=#c678dd ctermfg=176
    hi cType guifg=#c678dd ctermfg=176
    hi cStorageClass guifg=#c678dd ctermfg=176
    hi cStructure guifg=#c678dd ctermfg=176
    hi cOperator guifg=#c678dd ctermfg=176
    hi cStatement guifg=#c678dd ctermfg=176
    hi cTODO guifg=#c678dd ctermfg=176
    hi cConstant guifg=#d19a66 ctermfg=173
    hi cSpecial guifg=#56b6c2 ctermfg=73
    hi cSpecialCharacter guifg=#56b6c2 ctermfg=73
    hi cString guifg=#98c379 ctermfg=114
    hi cppType guifg=#c678dd ctermfg=176
    hi cppStorageClass guifg=#c678dd ctermfg=176
    hi cppStructure guifg=#c678dd ctermfg=176
    hi cppModifier guifg=#c678dd ctermfg=176
    hi cppOperator guifg=#c678dd ctermfg=176
    hi cppAccess guifg=#c678dd ctermfg=176
    hi cppStatement guifg=#c678dd ctermfg=176
    hi cppConstant guifg=#e06c75 ctermfg=168
    hi cCppString guifg=#98c379 ctermfg=114
    hi cucumberGiven guifg=#61afef ctermfg=75
    hi cucumberWhen guifg=#61afef ctermfg=75
    hi cucumberWhenAnd guifg=#61afef ctermfg=75
    hi cucumberThen guifg=#61afef ctermfg=75
    hi cucumberThenAnd guifg=#61afef ctermfg=75
    hi cucumberUnparsed guifg=#d19a66 ctermfg=173
    hi cucumberFeature guifg=#e06c75 ctermfg=168 gui=bold cterm=bold
    hi cucumberBackground guifg=#c678dd ctermfg=176 gui=bold cterm=bold
    hi cucumberScenario guifg=#c678dd ctermfg=176 gui=bold cterm=bold
    hi cucumberScenarioOutline guifg=#c678dd ctermfg=176 gui=bold cterm=bold
    hi cucumberTags guifg=#5c6370 ctermfg=59 gui=bold cterm=bold
    hi cucumberDelimiter guifg=#5c6370 ctermfg=59 gui=bold cterm=bold
    hi cssAttrComma guifg=#c678dd ctermfg=176
    hi cssAttributeSelector guifg=#98c379 ctermfg=114
    hi cssBraces guifg=#828997 ctermfg=102
    hi cssClassName guifg=#d19a66 ctermfg=173
    hi cssClassNameDot guifg=#d19a66 ctermfg=173
    hi cssDefinition guifg=#c678dd ctermfg=176
    hi cssFontAttr guifg=#d19a66 ctermfg=173
    hi cssFontDescriptor guifg=#c678dd ctermfg=176
    hi cssFunctionName guifg=#61afef ctermfg=75
    hi cssIdentifier guifg=#61afef ctermfg=75
    hi cssImportant guifg=#c678dd ctermfg=176
    hi cssInclude guifg=#abb2bf ctermfg=145
    hi cssIncludeKeyword guifg=#c678dd ctermfg=176
    hi cssMediaType guifg=#d19a66 ctermfg=173
    hi cssProp guifg=#56b6c2 ctermfg=73
    hi cssPseudoClassId guifg=#d19a66 ctermfg=173
    hi cssSelectorOp guifg=#c678dd ctermfg=176
    hi cssSelectorOp2 guifg=#c678dd ctermfg=176
    hi cssStringQ guifg=#98c379 ctermfg=114
    hi cssStringQQ guifg=#98c379 ctermfg=114
    hi cssTagName guifg=#e06c75 ctermfg=168
    hi cssAttr guifg=#d19a66 ctermfg=173
    hi sassAmpersand guifg=#e06c75 ctermfg=168
    hi sassClass guifg=#e5c07b ctermfg=180
    hi sassControl guifg=#c678dd ctermfg=176
    hi sassExtend guifg=#c678dd ctermfg=176
    hi sassFor guifg=#abb2bf ctermfg=145
    hi sassProperty guifg=#56b6c2 ctermfg=73
    hi sassFunction guifg=#56b6c2 ctermfg=73
    hi sassId guifg=#61afef ctermfg=75
    hi sassInclude guifg=#c678dd ctermfg=176
    hi sassMedia guifg=#c678dd ctermfg=176
    hi sassMediaOperators guifg=#abb2bf ctermfg=145
    hi sassMixin guifg=#c678dd ctermfg=176
    hi sassMixinName guifg=#61afef ctermfg=75
    hi sassMixing guifg=#c678dd ctermfg=176
    hi scssSelectorName guifg=#e5c07b ctermfg=180
    hi link elixirModuleDefine Define
    hi elixirAlias guifg=#e5c07b ctermfg=180
    hi elixirAtom guifg=#56b6c2 ctermfg=73
    hi elixirBlockDefinition guifg=#c678dd ctermfg=176
    hi elixirModuleDeclaration guifg=#d19a66 ctermfg=173
    hi elixirInclude guifg=#e06c75 ctermfg=168
    hi elixirOperator guifg=#d19a66 ctermfg=173
    hi gitcommitComment guifg=#5c6370 ctermfg=59
    hi gitcommitUnmerged guifg=#98c379 ctermfg=114
    hi gitcommitBranch guifg=#c678dd ctermfg=176
    hi gitcommitDiscardedType guifg=#e06c75 ctermfg=168
    hi gitcommitSelectedType guifg=#98c379 ctermfg=114
    hi gitcommitUntrackedFile guifg=#56b6c2 ctermfg=73
    hi gitcommitDiscardedFile guifg=#e06c75 ctermfg=168
    hi gitcommitSelectedFile guifg=#98c379 ctermfg=114
    hi gitcommitUnmergedFile guifg=#e5c07b ctermfg=180
    hi link gitcommitNoBranch       gitcommitBranch
    hi link gitcommitUntracked      gitcommitComment
    hi link gitcommitDiscarded      gitcommitComment
    hi link gitcommitSelected       gitcommitComment
    hi link gitcommitDiscardedArrow gitcommitDiscardedFile
    hi link gitcommitSelectedArrow  gitcommitSelectedFile
    hi link gitcommitUnmergedArrow  gitcommitUnmergedFile
    hi SignifySignAdd guifg=#98c379 ctermfg=114
    hi SignifySignChange guifg=#e5c07b ctermfg=180
    hi SignifySignDelete guifg=#e06c75 ctermfg=168
    hi link GitGutterAdd    SignifySignAdd
    hi link GitGutterChange SignifySignChange
    hi link GitGutterDelete SignifySignDelete
    hi diffAdded guifg=#98c379 ctermfg=114
    hi diffRemoved guifg=#e06c75 ctermfg=168
    hi goDeclaration guifg=#c678dd ctermfg=176
    hi goField guifg=#e06c75 ctermfg=168
    hi goMethod guifg=#56b6c2 ctermfg=73
    hi goType guifg=#c678dd ctermfg=176
    hi goUnsignedInts guifg=#56b6c2 ctermfg=73
    hi haskellDeclKeyword guifg=#61afef ctermfg=75
    hi haskellType guifg=#98c379 ctermfg=114
    hi haskellWhere guifg=#e06c75 ctermfg=168
    hi haskellImportKeywords guifg=#61afef ctermfg=75
    hi haskellOperators guifg=#e06c75 ctermfg=168
    hi haskellDelimiter guifg=#61afef ctermfg=75
    hi haskellIdentifier guifg=#d19a66 ctermfg=173
    hi haskellKeyword guifg=#e06c75 ctermfg=168
    hi haskellNumber guifg=#56b6c2 ctermfg=73
    hi haskellString guifg=#56b6c2 ctermfg=73
    hi htmlArg guifg=#d19a66 ctermfg=173
    hi htmlTagName guifg=#e06c75 ctermfg=168
    hi htmlTagN guifg=#e06c75 ctermfg=168
    hi htmlSpecialTagName guifg=#e06c75 ctermfg=168
    hi htmlTag guifg=#828997 ctermfg=102
    hi htmlEndTag guifg=#828997 ctermfg=102
    hi MatchTag guifg=#e06c75 ctermfg=168 guibg=#2c323c ctermbg=16 gui=underline,bold cterm=underline,bold
    hi coffeeString guifg=#98c379 ctermfg=114
    hi javaScriptBraces guifg=#828997 ctermfg=102
    hi javaScriptFunction guifg=#c678dd ctermfg=176
    hi javaScriptIdentifier guifg=#c678dd ctermfg=176
    hi javaScriptNull guifg=#d19a66 ctermfg=173
    hi javaScriptNumber guifg=#d19a66 ctermfg=173
    hi javaScriptRequire guifg=#56b6c2 ctermfg=73
    hi javaScriptReserved guifg=#c678dd ctermfg=176
    hi jsArrowFunction guifg=#c678dd ctermfg=176
    hi jsBraces guifg=#828997 ctermfg=102
    hi jsClassBraces guifg=#828997 ctermfg=102
    hi jsClassKeywords guifg=#c678dd ctermfg=176
    hi jsDocParam guifg=#61afef ctermfg=75
    hi jsDocTags guifg=#c678dd ctermfg=176
    hi jsFuncBraces guifg=#828997 ctermfg=102
    hi jsFuncCall guifg=#61afef ctermfg=75
    hi jsFuncParens guifg=#828997 ctermfg=102
    hi jsFunction guifg=#c678dd ctermfg=176
    hi jsGlobalObjects guifg=#e5c07b ctermfg=180
    hi jsModuleWords guifg=#c678dd ctermfg=176
    hi jsModules guifg=#c678dd ctermfg=176
    hi jsNoise guifg=#828997 ctermfg=102
    hi jsNull guifg=#d19a66 ctermfg=173
    hi jsOperator guifg=#c678dd ctermfg=176
    hi jsParens guifg=#828997 ctermfg=102
    hi jsStorageClass guifg=#c678dd ctermfg=176
    hi jsTemplateBraces guifg=#be5046 ctermfg=130
    hi jsTemplateVar guifg=#98c379 ctermfg=114
    hi jsThis guifg=#e06c75 ctermfg=168
    hi jsUndefined guifg=#d19a66 ctermfg=173
    hi jsObjectValue guifg=#61afef ctermfg=75
    hi jsObjectKey guifg=#56b6c2 ctermfg=73
    hi jsReturn guifg=#c678dd ctermfg=176
    hi javascriptArrowFunc guifg=#c678dd ctermfg=176
    hi javascriptClassExtends guifg=#c678dd ctermfg=176
    hi javascriptClassKeyword guifg=#c678dd ctermfg=176
    hi javascriptDocNotation guifg=#c678dd ctermfg=176
    hi javascriptDocParamName guifg=#61afef ctermfg=75
    hi javascriptDocTags guifg=#c678dd ctermfg=176
    hi javascriptEndColons guifg=#5c6370 ctermfg=59
    hi javascriptExport guifg=#c678dd ctermfg=176
    hi javascriptFuncArg guifg=#abb2bf ctermfg=145
    hi javascriptFuncKeyword guifg=#c678dd ctermfg=176
    hi javascriptIdentifier guifg=#e06c75 ctermfg=168
    hi javascriptImport guifg=#c678dd ctermfg=176
    hi javascriptObjectLabel guifg=#abb2bf ctermfg=145
    hi javascriptOpSymbol guifg=#56b6c2 ctermfg=73
    hi javascriptOpSymbols guifg=#56b6c2 ctermfg=73
    hi javascriptPropertyName guifg=#98c379 ctermfg=114
    hi javascriptTemplateSB guifg=#be5046 ctermfg=130
    hi javascriptVariable guifg=#c678dd ctermfg=176
    hi jsonCommentError guifg=#abb2bf ctermfg=145
    hi jsonKeyword guifg=#e06c75 ctermfg=168
    hi jsonQuote guifg=#5c6370 ctermfg=59
    hi jsonTrailingCommaError guifg=#e06c75 ctermfg=168 gui=reverse cterm=reverse
    hi jsonMissingCommaError guifg=#e06c75 ctermfg=168 gui=reverse cterm=reverse
    hi jsonNoQuotesError guifg=#e06c75 ctermfg=168 gui=reverse cterm=reverse
    hi jsonNumError guifg=#e06c75 ctermfg=168 gui=reverse cterm=reverse
    hi jsonString guifg=#98c379 ctermfg=114
    hi jsonBoolean guifg=#c678dd ctermfg=176
    hi jsonNumber guifg=#d19a66 ctermfg=173
    hi jsonStringSQError guifg=#e06c75 ctermfg=168 gui=reverse cterm=reverse
    hi jsonSemicolonError guifg=#e06c75 ctermfg=168 gui=reverse cterm=reverse
    hi markdownUrl guifg=#5c6370 ctermfg=59
    hi markdownBold guifg=#d19a66 ctermfg=173 gui=bold cterm=bold
    hi markdownItalic guifg=#d19a66 ctermfg=173 gui=bold cterm=bold
    hi markdownCode guifg=#98c379 ctermfg=114
    hi markdownCodeBlock guifg=#e06c75 ctermfg=168
    hi markdownCodeDelimiter guifg=#98c379 ctermfg=114
    hi markdownHeadingDelimiter guifg=#be5046 ctermfg=130
    hi markdownH1 guifg=#e06c75 ctermfg=168
    hi markdownH2 guifg=#e06c75 ctermfg=168
    hi markdownH3 guifg=#e06c75 ctermfg=168
    hi markdownH3 guifg=#e06c75 ctermfg=168
    hi markdownH4 guifg=#e06c75 ctermfg=168
    hi markdownH5 guifg=#e06c75 ctermfg=168
    hi markdownH6 guifg=#e06c75 ctermfg=168
    hi markdownListMarker guifg=#e06c75 ctermfg=168
    hi phpClass guifg=#e5c07b ctermfg=180
    hi phpFunction guifg=#61afef ctermfg=75
    hi phpFunctions guifg=#61afef ctermfg=75
    hi phpInclude guifg=#c678dd ctermfg=176
    hi phpKeyword guifg=#c678dd ctermfg=176
    hi phpParent guifg=#5c6370 ctermfg=59
    hi phpType guifg=#c678dd ctermfg=176
    hi phpSuperGlobals guifg=#e06c75 ctermfg=168
    hi pugAttributesDelimiter guifg=#d19a66 ctermfg=173
    hi pugClass guifg=#d19a66 ctermfg=173
    hi pugDocType guifg=#5c6370 ctermfg=59 gui=italic cterm=italic
    hi pugTag guifg=#e06c75 ctermfg=168
    hi purescriptKeyword guifg=#c678dd ctermfg=176
    hi purescriptModuleName guifg=#abb2bf ctermfg=145
    hi purescriptIdentifier guifg=#abb2bf ctermfg=145
    hi purescriptType guifg=#e5c07b ctermfg=180
    hi purescriptTypeVar guifg=#e06c75 ctermfg=168
    hi purescriptConstructor guifg=#e06c75 ctermfg=168
    hi purescriptOperator guifg=#abb2bf ctermfg=145
    hi pythonImport guifg=#c678dd ctermfg=176
    hi pythonBuiltin guifg=#56b6c2 ctermfg=73
    hi pythonStatement guifg=#c678dd ctermfg=176
    hi pythonParam guifg=#d19a66 ctermfg=173
    hi pythonEscape guifg=#e06c75 ctermfg=168
    hi pythonSelf guifg=#828997 ctermfg=102 gui=italic cterm=italic
    hi pythonClass guifg=#61afef ctermfg=75
    hi pythonOperator guifg=#c678dd ctermfg=176
    hi pythonEscape guifg=#e06c75 ctermfg=168
    hi pythonFunction guifg=#61afef ctermfg=75
    hi pythonKeyword guifg=#61afef ctermfg=75
    hi pythonModule guifg=#c678dd ctermfg=176
    hi pythonStringDelimiter guifg=#98c379 ctermfg=114
    hi pythonSymbol guifg=#56b6c2 ctermfg=73
    hi rubyBlock guifg=#c678dd ctermfg=176
    hi rubyBlockParameter guifg=#e06c75 ctermfg=168
    hi rubyBlockParameterList guifg=#e06c75 ctermfg=168
    hi rubyCapitalizedMethod guifg=#c678dd ctermfg=176
    hi rubyClass guifg=#c678dd ctermfg=176
    hi rubyConstant guifg=#e5c07b ctermfg=180
    hi rubyControl guifg=#c678dd ctermfg=176
    hi rubyDefine guifg=#c678dd ctermfg=176
    hi rubyEscape guifg=#e06c75 ctermfg=168
    hi rubyFunction guifg=#61afef ctermfg=75
    hi rubyGlobalVariable guifg=#e06c75 ctermfg=168
    hi rubyInclude guifg=#61afef ctermfg=75
    hi rubyIncluderubyGlobalVariable guifg=#e06c75 ctermfg=168
    hi rubyInstanceVariable guifg=#e06c75 ctermfg=168
    hi rubyInterpolation guifg=#56b6c2 ctermfg=73
    hi rubyInterpolationDelimiter guifg=#e06c75 ctermfg=168
    hi rubyKeyword guifg=#61afef ctermfg=75
    hi rubyModule guifg=#c678dd ctermfg=176
    hi rubyPseudoVariable guifg=#e06c75 ctermfg=168
    hi rubyRegexp guifg=#56b6c2 ctermfg=73
    hi rubyRegexpDelimiter guifg=#56b6c2 ctermfg=73
    hi rubyStringDelimiter guifg=#98c379 ctermfg=114
    hi rubySymbol guifg=#56b6c2 ctermfg=73
    hi SpellBad guibg=#282c34 ctermbg=16 gui=undercurl cterm=undercurl
    hi SpellLocal guibg=#282c34 ctermbg=16 gui=undercurl cterm=undercurl
    hi SpellCap guibg=#282c34 ctermbg=16 gui=undercurl cterm=undercurl
    hi SpellRare guibg=#282c34 ctermbg=16 gui=undercurl cterm=undercurl
    hi vimCommand guifg=#c678dd ctermfg=176
    hi vimCommentTitle guifg=#5c6370 ctermfg=59 gui=bold cterm=bold
    hi vimFunction guifg=#56b6c2 ctermfg=73
    hi vimFuncName guifg=#c678dd ctermfg=176
    hi vimHighlight guifg=#61afef ctermfg=75
    hi vimLineComment guifg=#5c6370 ctermfg=59 gui=italic cterm=italic
    hi vimParenSep guifg=#828997 ctermfg=102
    hi vimSep guifg=#828997 ctermfg=102
    hi vimUserFunc guifg=#56b6c2 ctermfg=73
    hi vimVar guifg=#e06c75 ctermfg=168
    hi xmlAttrib guifg=#e5c07b ctermfg=180
    hi xmlEndTag guifg=#e06c75 ctermfg=168
    hi xmlTag guifg=#e06c75 ctermfg=168
    hi xmlTagName guifg=#e06c75 ctermfg=168
    hi zshCommands guifg=#abb2bf ctermfg=145
    hi zshDeref guifg=#e06c75 ctermfg=168
    hi zshShortDeref guifg=#e06c75 ctermfg=168
    hi zshFunction guifg=#56b6c2 ctermfg=73
    hi zshKeyword guifg=#c678dd ctermfg=176
    hi zshSubst guifg=#e06c75 ctermfg=168
    hi zshSubstDelim guifg=#5c6370 ctermfg=59
    hi zshTypes guifg=#c678dd ctermfg=176
    hi zshVariableDef guifg=#d19a66 ctermfg=173
    hi rustExternCrate guifg=#e06c75 ctermfg=168 gui=bold cterm=bold
    hi rustIdentifier guifg=#61afef ctermfg=75
    hi rustDeriveTrait guifg=#98c379 ctermfg=114
    hi SpecialComment guifg=#5c6370 ctermfg=59
    hi rustCommentLine guifg=#5c6370 ctermfg=59
    hi rustCommentLineDoc guifg=#5c6370 ctermfg=59
    hi rustCommentLineDocError guifg=#5c6370 ctermfg=59
    hi rustCommentBlock guifg=#5c6370 ctermfg=59
    hi rustCommentBlockDoc guifg=#5c6370 ctermfg=59
    hi rustCommentBlockDocError guifg=#5c6370 ctermfg=59
    hi link manTitle String
    hi manFooter guifg=#5c6370 ctermfg=59
    hi ALEWarningSign guifg=#e5c07b ctermfg=180
    hi ALEErrorSign guifg=#e06c75 ctermfg=168
    "}}}
    if g:one_allow_italics == 0
      hi Italic gui=none cterm=none
      hi Comment guifg=#5c6370 ctermfg=59 gui=none cterm=none
      hi pugDocType guifg=#5c6370 ctermfg=59 gui=none cterm=none
      hi pythonSelf guifg=#828997 ctermfg=102 gui=none cterm=none
      hi vimLineComment guifg=#5c6370 ctermfg=59 gui=none cterm=none
    endif
  else
    " Light Italic {{{
    hi Normal guifg=#494b53 ctermfg=23 guibg=#fafafa ctermbg=255
    hi bold gui=bold cterm=bold
    hi ColorColumn guibg=#f0f0f0 ctermbg=254
    hi Conceal guifg=#c2c2c3 ctermfg=250 guibg=#fafafa ctermbg=255
    hi Cursor guibg=#526fff ctermbg=63
    hi CursorColumn guibg=#f0f0f0 ctermbg=254
    hi CursorLine guibg=#f0f0f0 ctermbg=254 gui=none cterm=none
    hi Directory guifg=#4078f2 ctermfg=33
    hi ErrorMsg guifg=#e45649 ctermfg=166 guibg=#fafafa ctermbg=255 gui=none cterm=none
    hi VertSplit guifg=#e7e9e1 ctermfg=188 gui=none cterm=none
    hi Folded guifg=#fafafa ctermfg=255 guibg=#a0a1a7 ctermbg=145 gui=none cterm=none
    hi FoldColumn guifg=#a0a1a7 ctermfg=145 guibg=#f0f0f0 ctermbg=254
    hi IncSearch guifg=#986801 ctermfg=94
    hi LineNr guifg=#c2c2c3 ctermfg=250
    hi CursorLineNr guifg=#494b53 ctermfg=23 guibg=#f0f0f0 ctermbg=254 gui=none cterm=none
    hi MatchParen guifg=#e45649 ctermfg=166 guibg=#f0f0f0 ctermbg=254 gui=underline,bold cterm=underline,bold
    hi Italic gui=italic cterm=italic
    hi ModeMsg guifg=#494b53 ctermfg=23
    hi MoreMsg guifg=#494b53 ctermfg=23
    hi NonText guifg=#a0a1a7 ctermfg=145 gui=none cterm=none
    hi PMenu guibg=#dfdfdf ctermbg=253
    hi PMenuSel guibg=#c2c2c3 ctermbg=250
    hi PMenuSbar guibg=#fafafa ctermbg=255
    hi PMenuThumb guibg=#494b53 ctermbg=23
    hi Question guifg=#4078f2 ctermfg=33
    hi Search guifg=#fafafa ctermfg=255 guibg=#c18401 ctermbg=136
    hi SpecialKey guifg=#d3d3d3 ctermfg=251 gui=none cterm=none
    hi Whitespace guifg=#d3d3d3 ctermfg=251 gui=none cterm=none
    hi StatusLine guifg=#494b53 ctermfg=23 guibg=#f0f0f0 ctermbg=254 gui=none cterm=none
    hi StatusLineNC guifg=#a0a1a7 ctermfg=145
    hi TabLine guifg=#494b53 ctermfg=23 guibg=#fafafa ctermbg=255
    hi TabLineFill guifg=#a0a1a7 ctermfg=145 guibg=#d0d0d0 ctermbg=251 gui=none cterm=none
    hi TabLineSel guifg=#fafafa ctermfg=255 guibg=#4078f2 ctermbg=33
    hi Title guifg=#494b53 ctermfg=23 gui=bold cterm=bold
    hi Visual guibg=#d0d0d0 ctermbg=251
    hi VisualNOS guibg=#d0d0d0 ctermbg=251
    hi WarningMsg guifg=#e45649 ctermfg=166
    hi TooLong guifg=#e45649 ctermfg=166
    hi WildMenu guifg=#494b53 ctermfg=23 guibg=#a0a1a7 ctermbg=145
    hi SignColumn guibg=#fafafa ctermbg=255
    hi Special guifg=#4078f2 ctermfg=33
    hi helpCommand guifg=#c18401 ctermfg=136
    hi helpExample guifg=#c18401 ctermfg=136
    hi helpHeader guifg=#494b53 ctermfg=23 gui=bold cterm=bold
    hi helpSectionDelim guifg=#a0a1a7 ctermfg=145
    hi Comment guifg=#a0a1a7 ctermfg=145 gui=italic cterm=italic
    hi Constant guifg=#50a14f ctermfg=71
    hi String guifg=#50a14f ctermfg=71
    hi Character guifg=#50a14f ctermfg=71
    hi Number guifg=#986801 ctermfg=94
    hi Boolean guifg=#986801 ctermfg=94
    hi Float guifg=#986801 ctermfg=94
    hi Identifier guifg=#e45649 ctermfg=166 gui=none cterm=none
    hi Function guifg=#4078f2 ctermfg=33
    hi Statement guifg=#a626a4 ctermfg=127 gui=none cterm=none
    hi Conditional guifg=#a626a4 ctermfg=127
    hi Repeat guifg=#a626a4 ctermfg=127
    hi Label guifg=#a626a4 ctermfg=127
    hi Operator guifg=#526fff ctermfg=63 gui=none cterm=none
    hi Keyword guifg=#e45649 ctermfg=166
    hi Exception guifg=#a626a4 ctermfg=127
    hi PreProc guifg=#c18401 ctermfg=136
    hi Include guifg=#4078f2 ctermfg=33
    hi Define guifg=#a626a4 ctermfg=127 gui=none cterm=none
    hi Macro guifg=#a626a4 ctermfg=127
    hi PreCondit guifg=#c18401 ctermfg=136
    hi Type guifg=#c18401 ctermfg=136 gui=none cterm=none
    hi StorageClass guifg=#c18401 ctermfg=136
    hi Structure guifg=#c18401 ctermfg=136
    hi Typedef guifg=#c18401 ctermfg=136
    hi Special guifg=#4078f2 ctermfg=33
    hi Underlined gui=underline cterm=underline
    hi Error guifg=#e45649 ctermfg=166 guibg=#fafafa ctermbg=255 gui=bold cterm=bold
    hi Todo guifg=#a626a4 ctermfg=127 guibg=#fafafa ctermbg=255
    hi DiffAdd guifg=#50a14f ctermfg=71 guibg=#d0d0d0 ctermbg=251
    hi DiffChange guifg=#986801 ctermfg=94 guibg=#d0d0d0 ctermbg=251
    hi DiffDelete guifg=#e45649 ctermfg=166 guibg=#d0d0d0 ctermbg=251
    hi DiffText guifg=#4078f2 ctermfg=33 guibg=#d0d0d0 ctermbg=251
    hi DiffAdded guifg=#50a14f ctermfg=71 guibg=#d0d0d0 ctermbg=251
    hi DiffFile guifg=#e45649 ctermfg=166 guibg=#d0d0d0 ctermbg=251
    hi DiffNewFile guifg=#50a14f ctermfg=71 guibg=#d0d0d0 ctermbg=251
    hi DiffLine guifg=#4078f2 ctermfg=33 guibg=#d0d0d0 ctermbg=251
    hi DiffRemoved guifg=#e45649 ctermfg=166 guibg=#d0d0d0 ctermbg=251
    hi asciidocListingBlock guifg=#696c77 ctermfg=60
    hi cInclude guifg=#a626a4 ctermfg=127
    hi cPreCondit guifg=#a626a4 ctermfg=127
    hi cPreConditMatch guifg=#a626a4 ctermfg=127
    hi cType guifg=#a626a4 ctermfg=127
    hi cStorageClass guifg=#a626a4 ctermfg=127
    hi cStructure guifg=#a626a4 ctermfg=127
    hi cOperator guifg=#a626a4 ctermfg=127
    hi cStatement guifg=#a626a4 ctermfg=127
    hi cTODO guifg=#a626a4 ctermfg=127
    hi cConstant guifg=#986801 ctermfg=94
    hi cSpecial guifg=#0184bc ctermfg=31
    hi cSpecialCharacter guifg=#0184bc ctermfg=31
    hi cString guifg=#50a14f ctermfg=71
    hi cppType guifg=#a626a4 ctermfg=127
    hi cppStorageClass guifg=#a626a4 ctermfg=127
    hi cppStructure guifg=#a626a4 ctermfg=127
    hi cppModifier guifg=#a626a4 ctermfg=127
    hi cppOperator guifg=#a626a4 ctermfg=127
    hi cppAccess guifg=#a626a4 ctermfg=127
    hi cppStatement guifg=#a626a4 ctermfg=127
    hi cppConstant guifg=#e45649 ctermfg=166
    hi cCppString guifg=#50a14f ctermfg=71
    hi cucumberGiven guifg=#4078f2 ctermfg=33
    hi cucumberWhen guifg=#4078f2 ctermfg=33
    hi cucumberWhenAnd guifg=#4078f2 ctermfg=33
    hi cucumberThen guifg=#4078f2 ctermfg=33
    hi cucumberThenAnd guifg=#4078f2 ctermfg=33
    hi cucumberUnparsed guifg=#986801 ctermfg=94
    hi cucumberFeature guifg=#e45649 ctermfg=166 gui=bold cterm=bold
    hi cucumberBackground guifg=#a626a4 ctermfg=127 gui=bold cterm=bold
    hi cucumberScenario guifg=#a626a4 ctermfg=127 gui=bold cterm=bold
    hi cucumberScenarioOutline guifg=#a626a4 ctermfg=127 gui=bold cterm=bold
    hi cucumberTags guifg=#a0a1a7 ctermfg=145 gui=bold cterm=bold
    hi cucumberDelimiter guifg=#a0a1a7 ctermfg=145 gui=bold cterm=bold
    hi cssAttrComma guifg=#a626a4 ctermfg=127
    hi cssAttributeSelector guifg=#50a14f ctermfg=71
    hi cssBraces guifg=#696c77 ctermfg=60
    hi cssClassName guifg=#986801 ctermfg=94
    hi cssClassNameDot guifg=#986801 ctermfg=94
    hi cssDefinition guifg=#a626a4 ctermfg=127
    hi cssFontAttr guifg=#986801 ctermfg=94
    hi cssFontDescriptor guifg=#a626a4 ctermfg=127
    hi cssFunctionName guifg=#4078f2 ctermfg=33
    hi cssIdentifier guifg=#4078f2 ctermfg=33
    hi cssImportant guifg=#a626a4 ctermfg=127
    hi cssInclude guifg=#494b53 ctermfg=23
    hi cssIncludeKeyword guifg=#a626a4 ctermfg=127
    hi cssMediaType guifg=#986801 ctermfg=94
    hi cssProp guifg=#0184bc ctermfg=31
    hi cssPseudoClassId guifg=#986801 ctermfg=94
    hi cssSelectorOp guifg=#a626a4 ctermfg=127
    hi cssSelectorOp2 guifg=#a626a4 ctermfg=127
    hi cssStringQ guifg=#50a14f ctermfg=71
    hi cssStringQQ guifg=#50a14f ctermfg=71
    hi cssTagName guifg=#e45649 ctermfg=166
    hi cssAttr guifg=#986801 ctermfg=94
    hi sassAmpersand guifg=#e45649 ctermfg=166
    hi sassClass guifg=#c18401 ctermfg=136
    hi sassControl guifg=#a626a4 ctermfg=127
    hi sassExtend guifg=#a626a4 ctermfg=127
    hi sassFor guifg=#494b53 ctermfg=23
    hi sassProperty guifg=#0184bc ctermfg=31
    hi sassFunction guifg=#0184bc ctermfg=31
    hi sassId guifg=#4078f2 ctermfg=33
    hi sassInclude guifg=#a626a4 ctermfg=127
    hi sassMedia guifg=#a626a4 ctermfg=127
    hi sassMediaOperators guifg=#494b53 ctermfg=23
    hi sassMixin guifg=#a626a4 ctermfg=127
    hi sassMixinName guifg=#4078f2 ctermfg=33
    hi sassMixing guifg=#a626a4 ctermfg=127
    hi scssSelectorName guifg=#c18401 ctermfg=136
    hi link elixirModuleDefine Define
    hi elixirAlias guifg=#c18401 ctermfg=136
    hi elixirAtom guifg=#0184bc ctermfg=31
    hi elixirBlockDefinition guifg=#a626a4 ctermfg=127
    hi elixirModuleDeclaration guifg=#986801 ctermfg=94
    hi elixirInclude guifg=#e45649 ctermfg=166
    hi elixirOperator guifg=#986801 ctermfg=94
    hi gitcommitComment guifg=#a0a1a7 ctermfg=145
    hi gitcommitUnmerged guifg=#50a14f ctermfg=71
    hi gitcommitBranch guifg=#a626a4 ctermfg=127
    hi gitcommitDiscardedType guifg=#e45649 ctermfg=166
    hi gitcommitSelectedType guifg=#50a14f ctermfg=71
    hi gitcommitUntrackedFile guifg=#0184bc ctermfg=31
    hi gitcommitDiscardedFile guifg=#e45649 ctermfg=166
    hi gitcommitSelectedFile guifg=#50a14f ctermfg=71
    hi gitcommitUnmergedFile guifg=#c18401 ctermfg=136
    hi link gitcommitNoBranch       gitcommitBranch
    hi link gitcommitUntracked      gitcommitComment
    hi link gitcommitDiscarded      gitcommitComment
    hi link gitcommitSelected       gitcommitComment
    hi link gitcommitDiscardedArrow gitcommitDiscardedFile
    hi link gitcommitSelectedArrow  gitcommitSelectedFile
    hi link gitcommitUnmergedArrow  gitcommitUnmergedFile
    hi SignifySignAdd guifg=#50a14f ctermfg=71
    hi SignifySignChange guifg=#c18401 ctermfg=136
    hi SignifySignDelete guifg=#e45649 ctermfg=166
    hi link GitGutterAdd    SignifySignAdd
    hi link GitGutterChange SignifySignChange
    hi link GitGutterDelete SignifySignDelete
    hi diffAdded guifg=#50a14f ctermfg=71
    hi diffRemoved guifg=#e45649 ctermfg=166
    hi goDeclaration guifg=#a626a4 ctermfg=127
    hi goField guifg=#e45649 ctermfg=166
    hi goMethod guifg=#0184bc ctermfg=31
    hi goType guifg=#a626a4 ctermfg=127
    hi goUnsignedInts guifg=#0184bc ctermfg=31
    hi haskellDeclKeyword guifg=#4078f2 ctermfg=33
    hi haskellType guifg=#50a14f ctermfg=71
    hi haskellWhere guifg=#e45649 ctermfg=166
    hi haskellImportKeywords guifg=#4078f2 ctermfg=33
    hi haskellOperators guifg=#e45649 ctermfg=166
    hi haskellDelimiter guifg=#4078f2 ctermfg=33
    hi haskellIdentifier guifg=#986801 ctermfg=94
    hi haskellKeyword guifg=#e45649 ctermfg=166
    hi haskellNumber guifg=#0184bc ctermfg=31
    hi haskellString guifg=#0184bc ctermfg=31
    hi htmlArg guifg=#986801 ctermfg=94
    hi htmlTagName guifg=#e45649 ctermfg=166
    hi htmlTagN guifg=#e45649 ctermfg=166
    hi htmlSpecialTagName guifg=#e45649 ctermfg=166
    hi htmlTag guifg=#696c77 ctermfg=60
    hi htmlEndTag guifg=#696c77 ctermfg=60
    hi MatchTag guifg=#e45649 ctermfg=166 guibg=#f0f0f0 ctermbg=254 gui=underline,bold cterm=underline,bold
    hi coffeeString guifg=#50a14f ctermfg=71
    hi javaScriptBraces guifg=#696c77 ctermfg=60
    hi javaScriptFunction guifg=#a626a4 ctermfg=127
    hi javaScriptIdentifier guifg=#a626a4 ctermfg=127
    hi javaScriptNull guifg=#986801 ctermfg=94
    hi javaScriptNumber guifg=#986801 ctermfg=94
    hi javaScriptRequire guifg=#0184bc ctermfg=31
    hi javaScriptReserved guifg=#a626a4 ctermfg=127
    hi jsArrowFunction guifg=#a626a4 ctermfg=127
    hi jsBraces guifg=#696c77 ctermfg=60
    hi jsClassBraces guifg=#696c77 ctermfg=60
    hi jsClassKeywords guifg=#a626a4 ctermfg=127
    hi jsDocParam guifg=#4078f2 ctermfg=33
    hi jsDocTags guifg=#a626a4 ctermfg=127
    hi jsFuncBraces guifg=#696c77 ctermfg=60
    hi jsFuncCall guifg=#4078f2 ctermfg=33
    hi jsFuncParens guifg=#696c77 ctermfg=60
    hi jsFunction guifg=#a626a4 ctermfg=127
    hi jsGlobalObjects guifg=#c18401 ctermfg=136
    hi jsModuleWords guifg=#a626a4 ctermfg=127
    hi jsModules guifg=#a626a4 ctermfg=127
    hi jsNoise guifg=#696c77 ctermfg=60
    hi jsNull guifg=#986801 ctermfg=94
    hi jsOperator guifg=#a626a4 ctermfg=127
    hi jsParens guifg=#696c77 ctermfg=60
    hi jsStorageClass guifg=#a626a4 ctermfg=127
    hi jsTemplateBraces guifg=#ca1243 ctermfg=160
    hi jsTemplateVar guifg=#50a14f ctermfg=71
    hi jsThis guifg=#e45649 ctermfg=166
    hi jsUndefined guifg=#986801 ctermfg=94
    hi jsObjectValue guifg=#4078f2 ctermfg=33
    hi jsObjectKey guifg=#0184bc ctermfg=31
    hi jsReturn guifg=#a626a4 ctermfg=127
    hi javascriptArrowFunc guifg=#a626a4 ctermfg=127
    hi javascriptClassExtends guifg=#a626a4 ctermfg=127
    hi javascriptClassKeyword guifg=#a626a4 ctermfg=127
    hi javascriptDocNotation guifg=#a626a4 ctermfg=127
    hi javascriptDocParamName guifg=#4078f2 ctermfg=33
    hi javascriptDocTags guifg=#a626a4 ctermfg=127
    hi javascriptEndColons guifg=#a0a1a7 ctermfg=145
    hi javascriptExport guifg=#a626a4 ctermfg=127
    hi javascriptFuncArg guifg=#494b53 ctermfg=23
    hi javascriptFuncKeyword guifg=#a626a4 ctermfg=127
    hi javascriptIdentifier guifg=#e45649 ctermfg=166
    hi javascriptImport guifg=#a626a4 ctermfg=127
    hi javascriptObjectLabel guifg=#494b53 ctermfg=23
    hi javascriptOpSymbol guifg=#0184bc ctermfg=31
    hi javascriptOpSymbols guifg=#0184bc ctermfg=31
    hi javascriptPropertyName guifg=#50a14f ctermfg=71
    hi javascriptTemplateSB guifg=#ca1243 ctermfg=160
    hi javascriptVariable guifg=#a626a4 ctermfg=127
    hi jsonCommentError guifg=#494b53 ctermfg=23
    hi jsonKeyword guifg=#e45649 ctermfg=166
    hi jsonQuote guifg=#a0a1a7 ctermfg=145
    hi jsonTrailingCommaError guifg=#e45649 ctermfg=166 gui=reverse cterm=reverse
    hi jsonMissingCommaError guifg=#e45649 ctermfg=166 gui=reverse cterm=reverse
    hi jsonNoQuotesError guifg=#e45649 ctermfg=166 gui=reverse cterm=reverse
    hi jsonNumError guifg=#e45649 ctermfg=166 gui=reverse cterm=reverse
    hi jsonString guifg=#50a14f ctermfg=71
    hi jsonBoolean guifg=#a626a4 ctermfg=127
    hi jsonNumber guifg=#986801 ctermfg=94
    hi jsonStringSQError guifg=#e45649 ctermfg=166 gui=reverse cterm=reverse
    hi jsonSemicolonError guifg=#e45649 ctermfg=166 gui=reverse cterm=reverse
    hi markdownUrl guifg=#a0a1a7 ctermfg=145
    hi markdownBold guifg=#986801 ctermfg=94 gui=bold cterm=bold
    hi markdownItalic guifg=#986801 ctermfg=94 gui=bold cterm=bold
    hi markdownCode guifg=#50a14f ctermfg=71
    hi markdownCodeBlock guifg=#e45649 ctermfg=166
    hi markdownCodeDelimiter guifg=#50a14f ctermfg=71
    hi markdownHeadingDelimiter guifg=#ca1243 ctermfg=160
    hi markdownH1 guifg=#e45649 ctermfg=166
    hi markdownH2 guifg=#e45649 ctermfg=166
    hi markdownH3 guifg=#e45649 ctermfg=166
    hi markdownH3 guifg=#e45649 ctermfg=166
    hi markdownH4 guifg=#e45649 ctermfg=166
    hi markdownH5 guifg=#e45649 ctermfg=166
    hi markdownH6 guifg=#e45649 ctermfg=166
    hi markdownListMarker guifg=#e45649 ctermfg=166
    hi phpClass guifg=#c18401 ctermfg=136
    hi phpFunction guifg=#4078f2 ctermfg=33
    hi phpFunctions guifg=#4078f2 ctermfg=33
    hi phpInclude guifg=#a626a4 ctermfg=127
    hi phpKeyword guifg=#a626a4 ctermfg=127
    hi phpParent guifg=#a0a1a7 ctermfg=145
    hi phpType guifg=#a626a4 ctermfg=127
    hi phpSuperGlobals guifg=#e45649 ctermfg=166
    hi pugAttributesDelimiter guifg=#986801 ctermfg=94
    hi pugClass guifg=#986801 ctermfg=94
    hi pugDocType guifg=#a0a1a7 ctermfg=145 gui=italic cterm=italic
    hi pugTag guifg=#e45649 ctermfg=166
    hi purescriptKeyword guifg=#a626a4 ctermfg=127
    hi purescriptModuleName guifg=#494b53 ctermfg=23
    hi purescriptIdentifier guifg=#494b53 ctermfg=23
    hi purescriptType guifg=#c18401 ctermfg=136
    hi purescriptTypeVar guifg=#e45649 ctermfg=166
    hi purescriptConstructor guifg=#e45649 ctermfg=166
    hi purescriptOperator guifg=#494b53 ctermfg=23
    hi pythonImport guifg=#a626a4 ctermfg=127
    hi pythonBuiltin guifg=#0184bc ctermfg=31
    hi pythonStatement guifg=#a626a4 ctermfg=127
    hi pythonParam guifg=#986801 ctermfg=94
    hi pythonEscape guifg=#e45649 ctermfg=166
    hi pythonSelf guifg=#696c77 ctermfg=60 gui=italic cterm=italic
    hi pythonClass guifg=#4078f2 ctermfg=33
    hi pythonOperator guifg=#a626a4 ctermfg=127
    hi pythonEscape guifg=#e45649 ctermfg=166
    hi pythonFunction guifg=#4078f2 ctermfg=33
    hi pythonKeyword guifg=#4078f2 ctermfg=33
    hi pythonModule guifg=#a626a4 ctermfg=127
    hi pythonStringDelimiter guifg=#50a14f ctermfg=71
    hi pythonSymbol guifg=#0184bc ctermfg=31
    hi rubyBlock guifg=#a626a4 ctermfg=127
    hi rubyBlockParameter guifg=#e45649 ctermfg=166
    hi rubyBlockParameterList guifg=#e45649 ctermfg=166
    hi rubyCapitalizedMethod guifg=#a626a4 ctermfg=127
    hi rubyClass guifg=#a626a4 ctermfg=127
    hi rubyConstant guifg=#c18401 ctermfg=136
    hi rubyControl guifg=#a626a4 ctermfg=127
    hi rubyDefine guifg=#a626a4 ctermfg=127
    hi rubyEscape guifg=#e45649 ctermfg=166
    hi rubyFunction guifg=#4078f2 ctermfg=33
    hi rubyGlobalVariable guifg=#e45649 ctermfg=166
    hi rubyInclude guifg=#4078f2 ctermfg=33
    hi rubyIncluderubyGlobalVariable guifg=#e45649 ctermfg=166
    hi rubyInstanceVariable guifg=#e45649 ctermfg=166
    hi rubyInterpolation guifg=#0184bc ctermfg=31
    hi rubyInterpolationDelimiter guifg=#e45649 ctermfg=166
    hi rubyKeyword guifg=#4078f2 ctermfg=33
    hi rubyModule guifg=#a626a4 ctermfg=127
    hi rubyPseudoVariable guifg=#e45649 ctermfg=166
    hi rubyRegexp guifg=#0184bc ctermfg=31
    hi rubyRegexpDelimiter guifg=#0184bc ctermfg=31
    hi rubyStringDelimiter guifg=#50a14f ctermfg=71
    hi rubySymbol guifg=#0184bc ctermfg=31
    hi SpellBad guibg=#fafafa ctermbg=255 gui=undercurl cterm=undercurl
    hi SpellLocal guibg=#fafafa ctermbg=255 gui=undercurl cterm=undercurl
    hi SpellCap guibg=#fafafa ctermbg=255 gui=undercurl cterm=undercurl
    hi SpellRare guibg=#fafafa ctermbg=255 gui=undercurl cterm=undercurl
    hi vimCommand guifg=#a626a4 ctermfg=127
    hi vimCommentTitle guifg=#a0a1a7 ctermfg=145 gui=bold cterm=bold
    hi vimFunction guifg=#0184bc ctermfg=31
    hi vimFuncName guifg=#a626a4 ctermfg=127
    hi vimHighlight guifg=#4078f2 ctermfg=33
    hi vimLineComment guifg=#a0a1a7 ctermfg=145 gui=italic cterm=italic
    hi vimParenSep guifg=#696c77 ctermfg=60
    hi vimSep guifg=#696c77 ctermfg=60
    hi vimUserFunc guifg=#0184bc ctermfg=31
    hi vimVar guifg=#e45649 ctermfg=166
    hi xmlAttrib guifg=#c18401 ctermfg=136
    hi xmlEndTag guifg=#e45649 ctermfg=166
    hi xmlTag guifg=#e45649 ctermfg=166
    hi xmlTagName guifg=#e45649 ctermfg=166
    hi zshCommands guifg=#494b53 ctermfg=23
    hi zshDeref guifg=#e45649 ctermfg=166
    hi zshShortDeref guifg=#e45649 ctermfg=166
    hi zshFunction guifg=#0184bc ctermfg=31
    hi zshKeyword guifg=#a626a4 ctermfg=127
    hi zshSubst guifg=#e45649 ctermfg=166
    hi zshSubstDelim guifg=#a0a1a7 ctermfg=145
    hi zshTypes guifg=#a626a4 ctermfg=127
    hi zshVariableDef guifg=#986801 ctermfg=94
    hi rustExternCrate guifg=#e45649 ctermfg=166 gui=bold cterm=bold
    hi rustIdentifier guifg=#4078f2 ctermfg=33
    hi rustDeriveTrait guifg=#50a14f ctermfg=71
    hi SpecialComment guifg=#a0a1a7 ctermfg=145
    hi rustCommentLine guifg=#a0a1a7 ctermfg=145
    hi rustCommentLineDoc guifg=#a0a1a7 ctermfg=145
    hi rustCommentLineDocError guifg=#a0a1a7 ctermfg=145
    hi rustCommentBlock guifg=#a0a1a7 ctermfg=145
    hi rustCommentBlockDoc guifg=#a0a1a7 ctermfg=145
    hi rustCommentBlockDocError guifg=#a0a1a7 ctermfg=145
    hi link manTitle String
    hi manFooter guifg=#a0a1a7 ctermfg=145
    hi ALEWarningSign guifg=#c18401 ctermfg=136
    hi ALEErrorSign guifg=#e45649 ctermfg=166
    "}}}
    if g:one_allow_italics == 0
      hi Italic gui=none cterm=none
      hi Comment guifg=#a0a1a7 ctermfg=145 gui=none cterm=none
      hi pugDocType guifg=#a0a1a7 ctermfg=145 gui=none cterm=none
      hi pythonSelf guifg=#696c77 ctermfg=60 gui=none cterm=none
      hi vimLineComment guifg=#a0a1a7 ctermfg=145 gui=none cterm=none
    endif
  endif

  " Neovim Terminal Colors --------------------------------------------------{{{
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
  " }}}

  " Delete functions =========================================================={{{
  " delf <SID>X
  " delf <SID>rgb
  " delf <SID>color
  " delf <SID>rgb_color
  " delf <SID>rgb_level
  " delf <SID>rgb_number
  " delf <SID>grey_color
  " delf <SID>grey_level
  " delf <SID>grey_number
  "}}}

endif
"}}}

" Public API --------------------------------------------------------------{{{
function! one#highlight(group, fg, bg, attr)
  call <sid>X(a:group, a:fg, a:bg, a:attr)
endfunction
" }}}

if exists('s:dark') && s:dark
  set background=dark
endif

" vim: set fdl=0 fdm=marker:
