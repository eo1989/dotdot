"VimR & Fvim config & then goneovim -- mostly guifont stuff

if exists('gui')
endif

if exists('g:fvim_loaded')
	" good old "set guifont" compat
	set guifont=Fira\ Code:h15:cANSI
	FVimFontAntialias v:true
	FVimFontAutohint v:true
	FVimFontHintLevel 'full'
	FVimFontLigature v:true
	FVimFontLineHeight '+1.0'
	FVimFontSubpixel v:true
	FVimFontAutoSnap v:true
	" FVimFontNoBuiltInSymbols v:true  " Disables built-in Nerd Font symbols
	
	"Fancy cursor effects a la neovide
	FVimCursorSmoothMove v:true
	FVimCursorSmoothBlink v:true
endif
