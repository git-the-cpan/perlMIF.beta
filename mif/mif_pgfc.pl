##---------------------------------------------------------------------------##
##  File:
##      mif_pgfc.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_pgfc" perl package.  It defines
##	routines to handle the PgfCatalog via MIFread_mif() defined in
##	the "mif" package.
##---------------------------------------------------------------------------##
##  Copyright (C) 1994  Earl Hood, ehood@convex.com
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
## 
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##  
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
##---------------------------------------------------------------------------##

require 'mif/mif.pl' || die "Unable to require mif.pl\n";
require 'mif/mif_pgf.pl' || die "Unable to require mif_pgf.pl\n";

package mif_pgfc;

##--------------------------------------------##
## Add PgfCatalog function to %MIFToken array ##
##--------------------------------------------##
$mif'MIFToken{'PgfCatalog'} = 'PgfCatalog';

##-------------------------------##
## PgfCatalog associative arrays ##
##-------------------------------##
%PgfUseNextTag		= ();
%PgfNextTag		= ();
%PgfFIndent		= ();
%PgfLIndent		= ();
%PgfRIndent		= ();
%PgfAlignment		= ();
%PgfSpBefore		= ();
%PgfSpAfter		= ();
%PgfLineSpacing		= ();
%PgfLeading		= ();
%PgfNumTabs		= ();
%TabStops		= ();
%PgfPlacement		= ();
%PgfPlacementStyle	= ();
%PgfRunInDefaultPunct	= ();
%PgfWithPrev		= ();
%PgfWithNext		= ();
%PgfBlockSize		= ();
%PgfAutoNum		= ();
%PgfNumFormat		= ();
%PgfNumberFont		= ();
%PgfNumAtEnd		= ();
%PgfHyphenate		= ();
%HyphenMaxLines		= ();
%HyphenMinPrefix	= ();
%HyphenMinSuffix	= ();
%HyphenMinWord		= ();
%PgfLetterSpace		= ();
%PgfMinWordSpace	= ();
%PgfOptWordSpace	= ();
%PgfMaxWordSpace	= ();
%PgfLanguage		= ();
%PgfTopSeparator	= ();
%PgfBotSeparator	= ();
%PgfCellAlignment	= ();
%PgfCellMargins		= ();
%PgfCellLMarginFixed	= ();
%PgfCellTMarginFixed	= ();
%PgfCellRMarginFixed	= ();
%PgfCellBMarginFixed	= ();

%FTag		= ();	# Tag name of font (should be "")
%FFamily	= ();	# Name of font family
%FAngle		= ();	# Name of angle
%FWeight	= ();	# Name of weight
%FVar		= ();	# Name of variation
%FPostScriptName = ();	# Name of font sent to PostScript	    # Frame 4.x
%FPlatformName	= ();	# Platform-specific font name (Mac/Windows) # Frame 4.x
%FSize		= ();	# Size in points
%FColor		= ();	# Font color
%FUnderline	= ();	# Underline boolean flag		    # Frame 3.x
%FDoubleUnderline = (); # DoubleUnderline boolean flag              # Frame 3.x
%FNumericUnderline = ();# NumericUnderline boolean flag             # Frame 3.x
%FUnderlining	= ();	# Underlining style			    # Frame 4.x
%FOverline	= ();	# Overline boolean flag
%FStrike	= ();	# Strikethrough boolean flag
%FSupScript	= ();	# Superscript boolean flag		    # Frame 3.x
%FSubScript	= ();	# Subscript boolean flag		    # Frame 3.x
%FChangeBar	= ();	# Change bar boolean flag
%FPosition	= ();	# Sub/Superscript			    # Frame 4.x
%FOutline	= ();	# Outline boolean flag (Mac)
%FShadow	= ();	# Shadow boolean flag (Mac)
%FPairKern	= ();	# Pair kerning boolean flag
%FCase		= ();	# Capitalization style			    # Frame 4.x
%FDX		= ();	# Horizontal manual kern value
%FDY		= ();	# Vertical manual kern value
%FDW		= ();	# Spread value for space between characters
%FPlain		= ();	# Used only by filters
%FBold		= ();	# Used only by filters
%FItalic	= ();	# Used only by filters
%FSeparation	= ();	# Spot color				    # Frame 3.x

##------------------------##
## Import 'mif' variables ##
##------------------------##
$MStore		= $mif'MStore;
$MOpen		= $mif'MOpen;
$MClose		= $mif'MClose;
$MLine		= $mif'MLine;
$mso		= $mif'mso;
$msc		= $mif'msc;
$stb		= $mif'stb;
$ste		= $mif'ste;
$como		= $mif'como;

			    ##---------------##
			    ## Main Routines ##
			    ##---------------##
##---------------------------------------------------------------------------
##	MIFwrite_pgfc() outputs the PgfCatalog as defined by the
##	associative arrays.
##
##	Usage:
##	    &'MIFwrite_pgfc(FILEHANDLE);
##
sub main'MIFwrite_pgfc {
    local($handle, $l) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, 'PgfCatalog', "\n";
    foreach (sort keys %PgfUseNextTag) {
	&'MIFwrite_pgf($handle, 1+$l,
		       $_,
		       $PgfUseNextTag{$_},
		       $PgfNextTag{$_},
		       $PgfFIndent{$_},
		       $PgfLIndent{$_},
		       $PgfRIndent{$_},
		       $PgfAlignment{$_},
		       $PgfSpBefore{$_},
		       $PgfSpAfter{$_},
		       $PgfLineSpacing{$_},
		       $PgfLeading{$_},
		       $PgfNumTabs{$_},
		       $TabStops{$_},
		       $PgfPlacement{$_},
		       $PgfPlacementStyle{$_},
		       $PgfRunInDefaultPunct{$_},
		       $PgfWithPrev{$_},
		       $PgfWithNext{$_},
		       $PgfBlockSize{$_},
		       $PgfAutoNum{$_},
		       $PgfNumFormat{$_},
		       $PgfNumberFont{$_},
		       $PgfNumAtEnd{$_},
		       $PgfHyphenate{$_},
		       $HyphenMaxLines{$_},
		       $HyphenMinPrefix{$_},
		       $HyphenMinSuffix{$_},
		       $HyphenMinWord{$_},
		       $PgfLetterSpace{$_},
		       $PgfMinWordSpace{$_},
		       $PgfOptWordSpace{$_},
		       $PgfMaxWordSpace{$_},
		       $PgfLanguage{$_},
		       $PgfTopSeparator{$_},
		       $PgfBotSeparator{$_},
		       $PgfCellAlignment{$_},
		       $PgfCellMargins{$_},
		       $PgfCellLMarginFixed{$_},
		       $PgfCellTMarginFixed{$_},
		       $PgfCellRMarginFixed{$_},
		       $PgfCellBMarginFixed{$_},
		       $FTag{$_},
		       $FFamily{$_},
		       $FAngle{$_},
		       $FWeight{$_},
		       $FVar{$_},
		       $FPostScriptName{$_},
		       $FPlatformName{$_},
		       $FSize{$_},
		       $FColor{$_},
		       $FUnderline{$_},
		       $FDoubleUnderline{$_},
		       $FNumericUnderline{$_},
		       $FUnderlining{$_},
		       $FOverline{$_},
		       $FStrike{$_},
		       $FSupScript{$_},
		       $FSubScript{$_},
		       $FChangeBar{$_},
		       $FPosition{$_},
		       $FOutline{$_},
		       $FShadow{$_},
		       $FPairKern{$_},
		       $FCase{$_},
		       $FDX{$_},
		       $FDY{$_},
		       $FDW{$_},
		       $FPlain{$_},
		       $FBold{$_},
		       $FItalic{$_},
		       $FSeparation{$_});
    }
    print $handle $i0, $msc, " $como end of PgfCatalog\n";
}
##---------------------------------------------------------------------------##
##	MIFget_ptag_data() is a convienence routine that returns
##	data associated with the para tag $ptag.  The font data returned
##	is specific to MIF version 4.x, except it will also return the
##	FSeparation value.
##
##	Usage:
##	    (<pgf data> ...,
##	     $ftag, $family, $angle, $weight, $var, $size, $undlining,
##	     $overline, $strike, $chngbar, $position, $outline, $shadow,
##	     $pairkern, $case, $dx, $dy, $dw, $color, $separation)
##		=
##	    &'MIFget_ptag_data($ptag);
##
sub main'MIFget_ptag_data {
    local($ptag) = @_;
    ($PgfUseNextTag{$ptag},
     $PgfNextTag{$ptag},
     $PgfFIndent{$ptag},
     $PgfLIndent{$ptag},
     $PgfRIndent{$ptag},
     $PgfAlignment{$ptag},
     $PgfSpBefore{$ptag},
     $PgfSpAfter{$ptag},
     $PgfLineSpacing{$ptag},
     $PgfLeading{$ptag},
     $PgfNumTabs{$ptag},
     $TabStops{$ptag},
     $PgfPlacement{$ptag},
     $PgfPlacementStyle{$ptag},
     $PgfRunInDefaultPunct{$ptag},
     $PgfWithPrev{$ptag},
     $PgfWithNext{$ptag},
     $PgfBlockSize{$ptag},
     $PgfAutoNum{$ptag},
     $PgfNumFormat{$ptag},
     $PgfNumberFont{$ptag},
     $PgfNumAtEnd{$ptag},
     $PgfHyphenate{$ptag},
     $HyphenMaxLines{$ptag},
     $HyphenMinPrefix{$ptag},
     $HyphenMinSuffix{$ptag},
     $HyphenMinWord{$ptag},
     $PgfLetterSpace{$ptag},
     $PgfMinWordSpace{$ptag},
     $PgfOptWordSpace{$ptag},
     $PgfMaxWordSpace{$ptag},
     $PgfLanguage{$ptag},
     $PgfTopSeparator{$ptag},
     $PgfBotSeparator{$ptag},
     $PgfCellAlignment{$ptag},
     $PgfCellMargins{$ptag},
     $PgfCellLMarginFixed{$ptag},
     $PgfCellTMarginFixed{$ptag},
     $PgfCellRMarginFixed{$ptag},
     $PgfCellBMarginFixed{$ptag},
     $FTag{$ptag},
     $FFamily{$ptag},
     $FAngle{$ptag},
     $FWeight{$ptag},
     $FVar{$ptag},
     $FSize{$ptag},
     $FUnderlining{$ptag},
     $FOverline{$ptag},
     $FStrike{$ptag},
     $FChangeBar{$ptag},
     $FPosition{$ptag},
     $FOutline{$ptag},
     $FShadow{$ptag},
     $FPairKern{$ptag},
     $FCase{$ptag},
     $FDX{$ptag},
     $FDY{$ptag},
     $FDW{$ptag},
     $FColor{$ptag},
     $FSeparation{$ptag});
}
##---------------------------------------------------------------------------##
##      MIFget_ptags() returns a sorted array of all paragraph tag names
##      defined in the paragraph catalog.
##
##      Usage:
##          @ptags = &'MIFget_ptags();
##
sub main'MIFget_ptags {
     return sort keys %PgfUseNextTag;
}
##---------------------------------------------------------------------------##
##	MIFreset_pgfc() resets all the associative arrays defining the
##	paragraph catalog.
##
sub main'MIFreset_pgfc {
    undef %PgfUseNextTag;
    undef %PgfNextTag;
    undef %PgfFIndent;
    undef %PgfLIndent;
    undef %PgfRIndent;
    undef %PgfAlignment;
    undef %PgfSpBefore;
    undef %PgfSpAfter;
    undef %PgfLineSpacing;
    undef %PgfLeading;
    undef %PgfNumTabs;
    undef %TabStops;
    undef %PgfPlacement;
    undef %PgfPlacementStyle;
    undef %PgfRunInDefaultPunct;
    undef %PgfWithPrev;
    undef %PgfWithNext;
    undef %PgfBlockSize;
    undef %PgfAutoNum;
    undef %PgfNumFormat;
    undef %PgfNumberFont;
    undef %PgfNumAtEnd;
    undef %PgfHyphenate;
    undef %HyphenMaxLines;
    undef %HyphenMinPrefix;
    undef %HyphenMinSuffix;
    undef %HyphenMinWord;
    undef %PgfLetterSpace;
    undef %PgfMinWordSpace;
    undef %PgfOptWordSpace;
    undef %PgfMaxWordSpace;
    undef %PgfLanguage;
    undef %PgfTopSeparator;
    undef %PgfBotSeparator;
    undef %PgfCellAlignment;
    undef %PgfCellMargins;
    undef %PgfCellLMarginFixed;
    undef %PgfCellTMarginFixed;
    undef %PgfCellRMarginFixed;
    undef %PgfCellBMarginFixed;

    undef %FTag;
    undef %FFamily;
    undef %FAngle;
    undef %FWeight;
    undef %FVar;
    undef %FPostScriptName;
    undef %FPlatformName;
    undef %FSize;
    undef %FColor;
    undef %FUnderline;
    undef %FDoubleUnderline;
    undef %FNumericUnderline;
    undef %FUnderlining;
    undef %FOverline;
    undef %FStrike;
    undef %FSupScript;
    undef %FSubScript;
    undef %FChangeBar;
    undef %FPosition;
    undef %FOutline;
    undef %FShadow;
    undef %FPairKern;
    undef %FCase;
    undef %FDX;
    undef %FDY;
    undef %FDW;
    undef %FPlain;
    undef %FBold;
    undef %FItalic;
    undef %FSeparation;
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the MIFread_mif() routine.  There purpose is to     ##
##	store the information contained in the paragraph catalog.	     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
##	PgfCatalog() is the token routine for 'PgfCatalog'.
##	It sets/restores token routines depending upon mode.
##
sub mif'PgfCatalog {
    local($token, $mode, *data) = @_;
    if ($mode == $MOpen) {
	($_fast, $_noidata) = ($mif'fast, $mif'no_import_data);
	($mif'fast, $mif'no_import_data) = (1, 1);
	$_pgf_orgfunc = &'MIFget_pgf_func();
	&'MIFset_pgf_func("mif_pgfc'pgf_close");
    } elsif ($mode == $MClose) {
	&'MIFset_pgf_func($_pgf_orgfunc);
        ($mif'fast, $mif'no_import_data) = ($_fast, $_noidata);
    }
}
##---------------------------------------------------------------------------
sub pgf_close {
    local($tag, $tmp);
    $tag = $mif_pgf'pgf_Tag;
  
    ($tmp,
     $PgfUseNextTag{$tag},
     $PgfNextTag{$tag},
     $PgfFIndent{$tag},
     $PgfLIndent{$tag},
     $PgfRIndent{$tag},
     $PgfAlignment{$tag},
     $PgfSpBefore{$tag},
     $PgfSpAfter{$tag},
     $PgfLineSpacing{$tag},
     $PgfLeading{$tag},
     $PgfNumTabs{$tag},
     $TabStops{$tag},
     $PgfPlacement{$tag},
     $PgfPlacementStyle{$tag},
     $PgfRunInDefaultPunct{$tag},
     $PgfWithPrev{$tag},
     $PgfWithNext{$tag},
     $PgfBlockSize{$tag},
     $PgfAutoNum{$tag},
     $PgfNumFormat{$tag},
     $PgfNumberFont{$tag},
     $PgfNumAtEnd{$tag},
     $PgfHyphenate{$tag},
     $HyphenMaxLines{$tag},
     $HyphenMinPrefix{$tag},
     $HyphenMinSuffix{$tag},
     $HyphenMinWord{$tag},
     $PgfLetterSpace{$tag},
     $PgfMinWordSpace{$tag},
     $PgfOptWordSpace{$tag},
     $PgfMaxWordSpace{$tag},
     $PgfLanguage{$tag},
     $PgfTopSeparator{$tag},
     $PgfBotSeparator{$tag},
     $PgfCellAlignment{$tag},
     $PgfCellMargins{$tag},
     $PgfCellLMarginFixed{$tag},
     $PgfCellTMarginFixed{$tag},
     $PgfCellRMarginFixed{$tag},
     $PgfCellBMarginFixed{$tag},
     $FTag{$tag},
     $FFamily{$tag},
     $FAngle{$tag},
     $FWeight{$tag},
     $FVar{$tag},
     $FPostScriptName{$tag},
     $FPlatformName{$tag},
     $FSize{$tag},
     $FColor{$tag},
     $FUnderline{$tag},
     $FDoubleUnderline{$tag},
     $FNumericUnderline{$tag},
     $FUnderlining{$tag},
     $FOverline{$tag},
     $FStrike{$tag},
     $FSupScript{$tag},
     $FSubScript{$tag},
     $FChangeBar{$tag},
     $FPosition{$tag},
     $FOutline{$tag},
     $FShadow{$tag},
     $FPairKern{$tag},
     $FCase{$tag},
     $FDX{$tag},
     $FDY{$tag},
     $FDW{$tag},
     $FPlain{$tag},
     $FBold{$tag},
     $FItalic{$tag},
     $FSeparation{$tag}) = &'MIFget_last_pgf_data();
}
##---------------------------------------------------------------------------
1;
