##---------------------------------------------------------------------------##
##  File:
##      mif_font.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_font" perl package.  It defines
##	routines to handle Font/PgfFont via MIFread_mif() defined in
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

package mif_font;

##--------------------------------------##
## Add Font routines to %MIFToken array ##
##--------------------------------------##
$mif'MIFToken{'Font'} = "mif_font'Font";
$mif'MIFToken{'PgfFont'} = "mif_font'Font";
@mif'MIFToken{
	'FTag',
	'FFamily',
	'FAngle',
	'FWeight',
	'FVar',
	'FPostScriptName',
	'FPlatformName',
	'FSize',
	'FColor',
	'FUnderline',
	'FDoubleUnderline',
	'FNumericUnderline',
	'FUnderlining',
	'FOverline',
	'FStrike',
	'FSupScript',
	'FSubScript',
	'FChangeBar',
	'FPosition',
	'FOutline',
	'FShadow',
	'FPairKern',
	'FCase',
	'FDX',
	'FDY',
	'FDW',
	'FPlain',
	'FBold',
	'FItalic',
	'FSeparation'
} = (
	"mif_font'FTag",
	"mif_font'FFamily",
	"mif_font'FAngle",
	"mif_font'FWeight",
	"mif_font'FVar",
	"mif_font'FPostScriptName",
	"mif_font'FPlatformName",
	"mif_font'FSize",
	"mif_font'FColor",
	"mif_font'FUnderline",
	"mif_font'FDoubleUnderline",
	"mif_font'FNumericUnderline",
	"mif_font'FUnderlining",
	"mif_font'FOverline",
	"mif_font'FStrike",
	"mif_font'FSupScript",
	"mif_font'FSubScript",
	"mif_font'FChangeBar",
	"mif_font'FPosition",
	"mif_font'FOutline",
	"mif_font'FShadow",
	"mif_font'FPairKern",
	"mif_font'FCase",
	"mif_font'FDX",
	"mif_font'FDY",
	"mif_font'FDW",
	"mif_font'FPlain",
	"mif_font'FBold",
	"mif_font'FItalic",
	"mif_font'FSeparation"
);

##--------------------##
## mif_font variables ##
##--------------------##
$fnt_close_func = "";	# Function to call during Font closure.

##---------------------------------------##
## Variables for current Font definition ##
##---------------------------------------##
$fnt_Token	= "";
$fnt_Tag	= "";
$fnt_Family	= "";
$fnt_Angle	= "";
$fnt_Weight	= "";
$fnt_Var	= "";
$fnt_PostScriptName = "";
$fnt_PlatformName = "";
$fnt_Size	= "";
$fnt_Color	= "";
$fnt_Underline	= "";
$fnt_DoubleUnderline = "";
$fnt_NumericUnderline = "";
$fnt_Underlining = "";
$fnt_Overline	= "";
$fnt_Strike	= "";
$fnt_SupScript	= "";
$fnt_SubScript	= "";
$fnt_ChangeBar	= "";
$fnt_Position	= "";
$fnt_Outline	= "";
$fnt_Shadow	= "";
$fnt_PairKern	= "";
$fnt_Case	= "";
$fnt_DX		= "";
$fnt_DY		= "";
$fnt_DW		= "";
$fnt_Plain	= "";
$fnt_Bold	= "";
$fnt_Italic	= "";
$fnt_Separation	= "";

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
##	MIFget_font_func() returns the function that is called when the
##	Font/PgfFont statement closes.
##
##	Usage:
##	    $func = &'MIFget_font_func();
##
sub main'MIFget_font_func {
    $fnt_close_func;
}
##---------------------------------------------------------------------------
##	MIFset_font_func() sets the function that is called when the
##	Font/PgfFont statement closes.
##
##	Usage:
##	    &'MIFset_font_func($func);
##
sub main'MIFset_font_func {
    $fnt_close_func = $_[0];
}
##---------------------------------------------------------------------------
##	MIFwrite_font() outputs the Font/PgfFont in MIF.
##
##	Usage:
##	    &'MIFwrite_font(FILEHANDLE, $indent, $FontToken, <font vars ...>);
##
sub main'MIFwrite_font {
    local($handle, $l, $Font, 
	  $Tag,
	  $Family,
	  $Angle,
	  $Weight,
	  $Var,
	  $PostScriptName,
	  $PlatformName,
	  $Size,
	  $Color,
	  $Underline,
	  $DoubleUnderline,
	  $NumericUnderline,
	  $Underlining,
	  $Overline,
	  $Strike,
	  $SupScript,
	  $SubScript,
	  $ChangeBar,
	  $Position,
	  $Outline,
	  $Shadow,
	  $PairKern,
	  $Case,
	  $DX,
	  $DY,
	  $DW,
	  $Plain,
	  $Bold,
	  $Italic,
	  $Separation) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, "$Font\n";
    print $handle $i1, $mso, 'FTag ', $stb, $Tag, $ste, $msc, "\n";
    print $handle $i1, $mso, 'FFamily ', $stb, $Family, $ste, $msc, "\n"
	if $Family ne "";
    print $handle $i1, $mso, 'FVar ', $stb, $Var, $ste, $msc, "\n"
	if $Var ne "";
    print $handle $i1, $mso, 'FWeight ', $stb, $Weight, $ste, $msc, "\n"
	if $Weight ne "";
    print $handle $i1, $mso, 'FAngle ', $stb, $Angle, $ste, $msc, "\n"
	if $Angle ne "";
    print $handle $i1, $mso, 'FPostScriptName ', $stb, $PostScriptName, $ste,
		       $msc, "\n"
	if $PostScriptName ne "";
    print $handle $i1, $mso, 'FPlatformName ', $PlatformName, $msc, "\n"
	if $PlatformName ne "";
    print $handle $i1, $mso, 'FSize ', $Size, $msc, "\n"
	if $Size ne "";
    print $handle $i1, $mso, 'FUnderlining ', $Underlining, $msc, "\n"
	if $Underlining ne "";
    print $handle $i1, $mso, 'FUnderline ', $Underline, $msc, "\n"
	if $Underline ne "";
    print $handle $i1, $mso, 'FDoubleUnderline ', $DoubleUnderline, $msc, "\n"
	if $DoubleUnderline ne "";
    print $handle $i1, $mso, 'FNumericUnderline ', $NumericUnderline, $msc, "\n"
	if $NumericUnderline ne "";
    print $handle $i1, $mso, 'FOverline ', $Overline, $msc, "\n"
	if $Overline ne "";
    print $handle $i1, $mso, 'FStrike ', $Strike, $msc, "\n"
	if $Strike ne "";
    print $handle $i1, $mso, 'FChangeBar ', $ChangeBar, $msc, "\n"
	if $ChangeBar ne "";
    print $handle $i1, $mso, 'FOutline ', $Outline, $msc, "\n"
	if $Outline ne "";
    print $handle $i1, $mso, 'FShadow ', $Shadow, $msc, "\n"
	if $Shadow ne "";
    print $handle $i1, $mso, 'FPairKern ', $PairKern, $msc, "\n"
	if $PairKern ne "";
    print $handle $i1, $mso, 'FCase ', $Case, $msc, "\n"
	if $Case ne "";
    print $handle $i1, $mso, 'FPosition ', $Position, $msc, "\n"
	if $Position ne "";
    print $handle $i1, $mso, 'FSupScript ', $SupScript, $msc, "\n"
	if $SupScript ne "";
    print $handle $i1, $mso, 'FSubScript ', $SubScript, $msc, "\n"
	if $SubScript ne "";
    print $handle $i1, $mso, 'FDX ', $DX, $msc, "\n"
	if $DX ne "";
    print $handle $i1, $mso, 'FDY ', $DY, $msc, "\n"
	if $DY ne "";
    print $handle $i1, $mso, 'FDW ', $DW, $msc, "\n"
	if $DW ne "";
    print $handle $i1, $mso, 'FPlain ', $Plain, $msc, "\n"
	if $Plain ne "";
    print $handle $i1, $mso, 'FBold ', $Bold, $msc, "\n"
	if $Bold ne "";
    print $handle $i1, $mso, 'FItalic ', $Italic, $msc, "\n"
	if $Italic ne "";
    print $handle $i1, $mso, 'FSeparation ', $Separation, $msc, "\n"
	if $Separation ne "";
    print $handle $i1, $mso, 'FColor ', $stb, $Color, $ste, $msc, "\n"
	if $Color ne "";
    print $handle $i0, $msc, " $como end of $Font\n";
}
##---------------------------------------------------------------------------##
##	MIFget_last_font_data() is a convienence routine that returns the
##	data associated with the last Font/PgfFont statement.  This routine
##	is mainly used by other mif_* libraries that need to process
##	Font/PgfFont statements (eg. mif_fntc, mif_pgfc).
##
##	Usage:
##	    @array = &'MIFget_last_font_data();
##
sub main'MIFget_last_font_data {
    ($fnt_Token,
     $fnt_Tag,
     $fnt_Family,
     $fnt_Angle,
     $fnt_Weight,
     $fnt_Var,
     $fnt_PostScriptName,
     $fnt_PlatformName,
     $fnt_Size,
     $fnt_Color,
     $fnt_Underline,
     $fnt_DoubleUnderline,
     $fnt_NumericUnderline,
     $fnt_Underlining,
     $fnt_Overline,
     $fnt_Strike,
     $fnt_SupScript,
     $fnt_SubScript,
     $fnt_ChangeBar,
     $fnt_Position,
     $fnt_Outline,
     $fnt_Shadow,
     $fnt_PairKern,
     $fnt_Case,
     $fnt_DX,
     $fnt_DY,
     $fnt_DW,
     $fnt_Plain,
     $fnt_Bold,
     $fnt_Italic,
     $fnt_Separation);
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the MIFread_mif() routine.  There purpose is to     ##
##	store the information contained in Font/PgfFont statement.	     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
sub Font {
    local($token, $mode, *data) = @_;

    if ($mode == $MOpen) {
	$fnt_Token = $token;
	$fnt_Tag = "";
	$fnt_Family = "";
	$fnt_Angle = "";
	$fnt_Weight = "";
	$fnt_Var = "";
	$fnt_PostScriptName = "";
	$fnt_PlatformName = "";
	$fnt_Size = "";
	$fnt_Color = "";
	$fnt_Underline = "";
	$fnt_DoubleUnderline = "";
	$fnt_NumericUnderline = "";
	$fnt_Underlining = "";
	$fnt_Overline = "";
	$fnt_Strike = "";
	$fnt_SupScript = "";
	$fnt_SubScript = "";
	$fnt_ChangeBar = "";
	$fnt_Position = "";
	$fnt_Outline = "";
	$fnt_Shadow = "";
	$fnt_PairKern = "";
	$fnt_Case = "";
	$fnt_DX	= "";
	$fnt_DY	= "";
	$fnt_DW	= "";
	$fnt_Plain = "";
	$fnt_Bold = "";
	$fnt_Italic = "";
	$fnt_Separation = "";
    } elsif ($mode == $MClose) {
	&$fnt_close_func() if $fnt_close_func;
    } else {
	warn "Unexpected mode, $mode, passed to Font routine\n";
    }
}
##---------------------------------------------------------------------------
sub FTag {
    local($token, $mode, *data) = @_;
    ($fnt_Tag) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub FFamily {
    local($token, $mode, *data) = @_;
    ($fnt_Family) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub FAngle {
    local($token, $mode, *data) = @_;
    ($fnt_Angle) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub FWeight {
    local($token, $mode, *data) = @_;
    ($fnt_Weight) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub FVar {
    local($token, $mode, *data) = @_;
    ($fnt_Var) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub FPostScriptName {
    local($token, $mode, *data) = @_;
    ($fnt_PostScriptName) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub FColor {
    local($token, $mode, *data) = @_;
    ($fnt_Color) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub FSize {
    local($token, $mode, *data) = @_;
    ($fnt_Size) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FUnderline {
    local($token, $mode, *data) = @_;
    ($fnt_Underline) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FDoubleUnderline {
    local($token, $mode, *data) = @_;
    ($fnt_DoubleUnderline) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FNumericUnderline {
    local($token, $mode, *data) = @_;
    ($fnt_NumericUnderline) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FUnderlining {
    local($token, $mode, *data) = @_;
    ($fnt_Underlining) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FOverline {
    local($token, $mode, *data) = @_;
    ($fnt_Overline) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FStrike {
    local($token, $mode, *data) = @_;
    ($fnt_Strike) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FSupScript {
    local($token, $mode, *data) = @_;
    ($fnt_SupScript) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FSubScript {
    local($token, $mode, *data) = @_;
    ($fnt_SubScript) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FChangeBar {
    local($token, $mode, *data) = @_;
    ($fnt_ChangeBar) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FPosition {
    local($token, $mode, *data) = @_;
    ($fnt_Position) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FOutline {
    local($token, $mode, *data) = @_;
    ($fnt_Outline) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FShadow {
    local($token, $mode, *data) = @_;
    ($fnt_Shadow) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FPairKern {
    local($token, $mode, *data) = @_;
    ($fnt_PairKern) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FCase {
    local($token, $mode, *data) = @_;
    ($fnt_Case) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FDX {
    local($token, $mode, *data) = @_;
    ($fnt_DX) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FDY {
    local($token, $mode, *data) = @_;
    ($fnt_DY) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FDW {
    local($token, $mode, *data) = @_;
    ($fnt_DW) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FPlain {
    local($token, $mode, *data) = @_;
    ($fnt_Plain) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FBold {
    local($token, $mode, *data) = @_;
    ($fnt_Bold) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FItalic {
    local($token, $mode, *data) = @_;
    ($fnt_Italic) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FSeparation {
    local($token, $mode, *data) = @_;
    ($fnt_Separation) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub FColor {
    local($token, $mode, *data) = @_;
    ($fnt_Color) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub FPlatformName {
    local($token, $mode, *data) = @_;
    ($fnt_PlatformName) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
1;
