##---------------------------------------------------------------------------##
##  File:
##      mif_fntc.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_fntc" perl package.  It defines
##	routines to handle the FontCatalog via MIFread_mif() defined in
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
require 'mif/mif_font.pl' || die "Unable to require mif_font.pl\n";

package mif_fntc;

##---------------------------------------------##
## Add FontCatalog function to %MIFToken array ##
##---------------------------------------------##
$mif'MIFToken{'FontCatalog'} = 'FontCatalog';

##--------------------------------##
## FontCatalog associative arrays ##
##--------------------------------##
%FFamily	= ();	# Name of font family
%FAngle		= ();	# Name of angle
%FWeight	= ();	# Name of weight
%FVar		= ();	# Name of variation
%FPostScriptName = ();	# Name of font sent to PostScript	    # Frame 4.x
%FPlatformName	= ();	# Platform-specific font name (Mac/Windows) # Frame 4.x
%FSize		= ();	# Size in points
%FColor		= ();	# Font color
%FUnderline	= ();	# Underline boolean flag		    # Frame 3.x
%FDoubleUnderline = ();	# DoubleUnderline boolean flag		    # Frame 3.x
%FNumericUnderline = ();# NumericUnderline boolean flag		    # Frame 3.x
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
##	MIFwrite_fntc() outputs the FontCatalog as defined by the
##	associative arrays.
##
##	Usage:
##	    &'MIFwrite_fntc(FILEHANDLE);
##
sub main'MIFwrite_fntc {
    local($handle, $l) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, 'FontCatalog', "\n";
    foreach (sort keys %FFamily) {
	&'MIFwrite_font($handle, 1+$l, 'Font',
		        $_,
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
    print $handle $i0, $msc, " $como end of FontCatalog\n";
}
##---------------------------------------------------------------------------##
##	MIFget_ftag_data() is a convienence routine that returns the
##	data associated with the font tag $font.  The data returned
##	is specific to MIF version 4.x, except it will also return the
##	FSeparation value.
##
##	Usage:
##	    ($family, $angle, $weight, $var, $size, $undlining, $overline,
##	     $strike, $chngbar, $position, $outline, $shadow, $pairkern,
##	     $case, $dx, $dy, $dw, $color, $separation)
##		=
##	    &'MIFget_ftag_data($font);
##
sub main'MIFget_ftag_data {
    local($font) = @_;
    ($FFamily{$font},
     $FAngle{$font},
     $FWeight{$font},
     $FVar{$font},
     $FSize{$font},
     $FUnderlining{$font},
     $FOverline{$font},
     $FStrike{$font},
     $FChangeBar{$font},
     $FPosition{$font},
     $FOutline{$font},
     $FShadow{$font},
     $FPairKern{$font},
     $FCase{$font},
     $FDX{$font},
     $FDY{$font},
     $FDW{$font},
     $FColor{$font},
     $FSeparation{$font});
}
##---------------------------------------------------------------------------##
##      MIFget_ftags() returns a sorted array of all font tag names
##      defined in the font catalog.
##
##      Usage:
##          @ftags = &'MIFget_ftags();
##
sub main'MIFget_ftags {
     return sort keys %FFamily;
}
##---------------------------------------------------------------------------##
##	MIFreset_fntc() resets all the associative arrays defining the
##	font catalog.
##
sub main'MIFreset_fntc {
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
##	store the information contained in the font catalog.		     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
##	FontCatalog() is the token routine for 'FontCatalog'.
##	It sets/restores token routines depending upon mode.
##
sub mif'FontCatalog {
    local($token, $mode, *data) = @_;
    if ($mode == $MOpen) {
	($_fast, $_noidata) = ($mif'fast, $mif'no_import_data);
	($mif'fast, $mif'no_import_data) = (1, 1);
	$_fntc_orgfunc = &'MIFget_font_func();
	&'MIFset_font_func("mif_fntc'font_close");
    } elsif ($mode == $MClose) {
	&'MIFset_font_func($_fntc_orgfunc);
        ($mif'fast, $mif'no_import_data) = ($_fast, $_noidata);
    }
}
##---------------------------------------------------------------------------
sub font_close {
    local($token, $tag, $tmp);
    $tag = $mif_font'fnt_Tag;
  
    ($token,
     $tmp,
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
     $FSeparation{$tag}) = &'MIFget_last_font_data();
}
##---------------------------------------------------------------------------
1;
