##---------------------------------------------------------------------------##
##  File:
##      mif_pgf.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_pgf" perl package.  It defines
##	routines to handle Pgf via MIFread_mif() defined in
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
require 'mif/mif_tab.pl' || die "Unable to require mif_tab.pl\n";

package mif_pgf;

##-------------------------------------##
## Add Pgf routines to %MIFToken array ##
##-------------------------------------##
$mif'MIFToken{'Pgf'} = "mif_pgf'Pgf";
@mif'MIFToken{
	'PgfTag',
	'PgfUseNextTag',
	'PgfNextTag',
	'PgfFIndent',
	'PgfLIndent',
	'PgfRIndent',
	'PgfAlignment',
	'PgfSpBefore',
	'PgfSpAfter',
	'PgfLineSpacing',
	'PgfLeading',
	'PgfNumTabs',
	'PgfPlacement',
	'PgfPlacementStyle',
	'PgfRunInDefaultPunct',
	'PgfWithPrev',
	'PgfWithNext',
	'PgfBlockSize',
	'PgfAutoNum',
	'PgfNumFormat',
	'PgfNumberFont',
	'PgfNumAtEnd',
	'PgfHyphenate',
	'HyphenMaxLines',
	'HyphenMinPrefix',
	'HyphenMinSuffix',
	'HyphenMinWord',
	'PgfLetterSpace',
	'PgfMinWordSpace',
	'PgfOptWordSpace',
	'PgfMaxWordSpace',
	'PgfLanguage',
	'PgfTopSeparator',
	'PgfBotSeparator',
	'PgfCellAlignment',
	'PgfCellMargins',
	'PgfCellLMarginFixed',
	'PgfCellTMarginFixed',
	'PgfCellRMarginFixed',
	'PgfCellBMarginFixed'
} = (
	"mif_pgf'PgfTag",
	"mif_pgf'PgfUseNextTag",
	"mif_pgf'PgfNextTag",
	"mif_pgf'PgfFIndent",
	"mif_pgf'PgfLIndent",
	"mif_pgf'PgfRIndent",
	"mif_pgf'PgfAlignment",
	"mif_pgf'PgfSpBefore",
	"mif_pgf'PgfSpAfter",
	"mif_pgf'PgfLineSpacing",
	"mif_pgf'PgfLeading",
	"mif_pgf'PgfNumTabs",
	"mif_pgf'PgfPlacement",
	"mif_pgf'PgfPlacementStyle",
	"mif_pgf'PgfRunInDefaultPunct",
	"mif_pgf'PgfWithPrev",
	"mif_pgf'PgfWithNext",
	"mif_pgf'PgfBlockSize",
	"mif_pgf'PgfAutoNum",
	"mif_pgf'PgfNumFormat",
	"mif_pgf'PgfNumberFont",
	"mif_pgf'PgfNumAtEnd",
	"mif_pgf'PgfHyphenate",
	"mif_pgf'HyphenMaxLines",
	"mif_pgf'HyphenMinPrefix",
	"mif_pgf'HyphenMinSuffix",
	"mif_pgf'HyphenMinWord",
	"mif_pgf'PgfLetterSpace",
	"mif_pgf'PgfMinWordSpace",
	"mif_pgf'PgfOptWordSpace",
	"mif_pgf'PgfMaxWordSpace",
	"mif_pgf'PgfLanguage",
	"mif_pgf'PgfTopSeparator",
	"mif_pgf'PgfBotSeparator",
	"mif_pgf'PgfCellAlignment",
	"mif_pgf'PgfCellMargins",
	"mif_pgf'PgfCellLMarginFixed",
	"mif_pgf'PgfCellTMarginFixed",
	"mif_pgf'PgfCellRMarginFixed",
	"mif_pgf'PgfCellBMarginFixed"
);

##-------------------##
## mif_pgf variables ##
##-------------------##
$pgf_close_func = "";	# Function to call during Pgf closure.

$tf	= "'";		# Character separating TabStop fields.
$ts	= ${;};		# Character separating TabStops.

##--------------------------------------##
## Variables for current Pgf definition ##
##--------------------------------------##
$pgf_Tag		= "";
$pgf_UseNextTag		= "";
$pgf_NextTag		= "";
$pgf_FIndent		= "";
$pgf_LIndent		= "";
$pgf_RIndent		= "";
$pgf_Alignment		= "";
$pgf_SpBefore		= "";
$pgf_SpAfter		= "";
$pgf_LineSpacing	= "";
$pgf_Leading		= "";
$pgf_NumTabs		= "";
$pgf_TabStops		= "";
$pgf_Placement		= "";
$pgf_PlacementStyle	= "";
$pgf_RunInDefaultPunct	= "";
$pgf_WithPrev		= "";
$pgf_WithNext		= "";
$pgf_BlockSize		= "";
$pgf_AutoNum		= "";
$pgf_NumFormat		= "";
$pgf_NumberFont		= "";
$pgf_NumAtEnd		= "";
$pgf_Hyphenate		= "";
$pgf_HyphenMaxLines	= "";
$pgf_HyphenMinPrefix	= "";
$pgf_HyphenMinSuffix	= "";
$pgf_HyphenMinWord	= "";
$pgf_LetterSpace	= "";
$pgf_MinWordSpace	= "";
$pgf_OptWordSpace	= "";
$pgf_MaxWordSpace	= "";
$pgf_Language		= "";
$pgf_TopSeparator	= "";
$pgf_BotSeparator	= "";
$pgf_CellAlignment	= "";
$pgf_CellMargins	= "";
$pgf_CellLMarginFixed	= "";
$pgf_CellTMarginFixed	= "";
$pgf_CellRMarginFixed	= "";
$pgf_CellBMarginFixed	= "";

$fnt_Tag		= "";
$fnt_Family		= "";
$fnt_Angle		= "";
$fnt_Weight		= "";
$fnt_Var		= "";
$fnt_PostScriptName	= "";
$fnt_PlatformName	= "";
$fnt_Size		= "";
$fnt_Color		= "";
$fnt_Underline		= "";
$fnt_DoubleUnderline	= "";
$fnt_NumericUnderline	= "";
$fnt_Underlining	= "";
$fnt_Overline		= "";
$fnt_Strike		= "";
$fnt_SupScript		= "";
$fnt_SubScript		= "";
$fnt_ChangeBar		= "";
$fnt_Position		= "";
$fnt_Outline		= "";
$fnt_Shadow		= "";
$fnt_PairKern		= "";
$fnt_Case		= "";
$fnt_DX			= "";
$fnt_DY			= "";
$fnt_DW			= "";
$fnt_Plain		= "";
$fnt_Bold		= "";
$fnt_Italic		= "";
$fnt_Separation		= "";

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
##	MIFget_pgf_func() returns the function that is called when the
##	Pgf statement closes.
##
##	Usage:
##	    $func = &'MIFget_pgf_func();
##
sub main'MIFget_pgf_func {
    $pgf_close_func;
}
##---------------------------------------------------------------------------
##	MIFset_pgf_func() sets the function that is called when the
##	Pgf statement closes.
##
##	Usage:
##	    &'MIFset_pgf_func($func);
##
sub main'MIFset_pgf_func {
    $pgf_close_func = $_[0];
}
##---------------------------------------------------------------------------
##	MIFwrite_pgf() outputs the Pgf in MIF.
##
##	Usage:
##	    &'MIFwrite_pgf(FILEHANDLE, $indent, <pgf vars ...>);
##
sub main'MIFwrite_pgf {
    local($handle, $l,
	  $Tag,
	  $UseNextTag,
	  $NextTag,
	  $FIndent,
	  $LIndent,
	  $RIndent,
	  $Alignment,
	  $SpBefore,
	  $SpAfter,
	  $LineSpacing,
	  $Leading,
	  $NumTabs,
	  $TabStops,
	  $Placement,
	  $PlacementStyle,
	  $RunInDefaultPunct,
	  $WithPrev,
	  $WithNext,
	  $BlockSize,
	  $AutoNum,
	  $NumFormat,
	  $NumberFont,
	  $NumAtEnd,
	  $Hyphenate,
	  $HyphenMaxLines,
	  $HyphenMinPrefix,
	  $HyphenMinSuffix,
	  $HyphenMinWord,
	  $LetterSpace,
	  $MinWordSpace,
	  $OptWordSpace,
	  $MaxWordSpace,
	  $Language,
	  $TopSeparator,
	  $BotSeparator,
	  $CellAlignment,
	  $CellMargins,
	  $CellLMarginFixed,
	  $CellTMarginFixed,
	  $CellRMarginFixed,
	  $CellBMarginFixed,
	  @font_data) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, "Pgf\n";
    print $handle $i1, $mso, 'PgfTag ', $stb, $Tag, $ste, $msc, "\n"
	if $Tag ne "";
    print $handle $i1, $mso, 'PgfUseNextTag ', $UseNextTag, $msc, "\n"
	if $UseNextTag ne "";
    print $handle $i1, $mso, 'PgfNextTag ', $stb, $NextTag, $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'PgfAlignment ', $Alignment, $msc, "\n"
	if $Alignment ne "";
    print $handle $i1, $mso, 'PgfFIndent ', $FIndent, $msc, "\n"
	if $FIndent ne "";
    print $handle $i1, $mso, 'PgfLIndent ', $LIndent, $msc, "\n"
	if $LIndent ne "";
    print $handle $i1, $mso, 'PgfRIndent ', $RIndent, $msc, "\n"
	if $RIndent ne "";
    print $handle $i1, $mso, 'PgfTopSeparator ', $stb, $TopSeparator, $ste,
		       $msc, "\n"
	;
    print $handle $i1, $mso, 'PgfBotSeparator ', $stb, $BotSeparator, $ste,
		       $msc, "\n"
	;
    print $handle $i1, $mso, 'PgfPlacement ', $Placement, $msc, "\n"
	if $Placement ne "";
    print $handle $i1, $mso, 'PgfPlacementStyle ', $PlacementStyle, $msc, "\n"
	if $PlacementStyle ne "";
    print $handle $i1, $mso, 'PgfRunInDefaultPunct ', $stb,
		       $RunInDefaultPunct, $ste, $msc, "\n"
	if $RunInDefaultPunct ne "";
    print $handle $i1, $mso, 'PgfSpBefore ', $SpBefore, $msc, "\n"
	if $SpBefore ne "";
    print $handle $i1, $mso, 'PgfSpAfter ', $SpAfter, $msc, "\n"
	if $SpAfter ne "";
    print $handle $i1, $mso, 'PgfWithPrev ', $WithPrev, $msc, "\n"
	if $WithPrev ne "";
    print $handle $i1, $mso, 'PgfWithNext ', $WithNext, $msc, "\n"
	if $WithNext ne "";
    print $handle $i1, $mso, 'PgfBlockSize ', $BlockSize, $msc, "\n"
	if $BlockSize ne "";

    &'MIFwrite_font($handle, 1+$l, 'PgfFont', shift @font_data, @font_data);

    print $handle $i1, $mso, 'PgfLineSpacing ', $LineSpacing, $msc, "\n"
	if $LineSpacing ne "";
    print $handle $i1, $mso, 'PgfLeading ', $Leading, $msc, "\n"
	if $Leading ne "";
    print $handle $i1, $mso, 'PgfAutoNum ', $AutoNum, $msc, "\n"
	if $AutoNum ne "";
    print $handle $i1, $mso, 'PgfNumFormat ', $stb, $NumFormat, $ste,
		       $msc, "\n"
	if $NumFormat ne "";
    print $handle $i1, $mso, 'PgfNumberFont ', $stb, $NumberFont, $ste,
		       $msc, "\n"
	if $NumFormat ne "";
    print $handle $i1, $mso, 'PgfNumAtEnd ', $NumAtEnd, $msc, "\n"
	if $NumAtEnd ne "";
    print $handle $i1, $mso, 'PgfNumTabs ', $NumTabs, $msc, "\n"
	if $NumTabs ne "";

    foreach (split(/$ts/o, $TabStops)) {
	&'MIFwrite_tab($handle, 1+$l, split(/$tf/o, $_, 4));
    }

    print $handle $i1, $mso, 'PgfHyphenate ', $Hyphenate, $msc, "\n"
	if $Hyphenate ne "";
    print $handle $i1, $mso, 'HyphenMaxLines ', $HyphenMaxLines, $msc, "\n"
	if $HyphenMaxLines ne "";
    print $handle $i1, $mso, 'HyphenMinPrefix ', $HyphenMinPrefix,
		       $msc, "\n"
	if $HyphenMinPrefix ne "";
    print $handle $i1, $mso, 'HyphenMinSuffix ', $HyphenMinSuffix,
		       $msc, "\n"
	if $HyphenMinSuffix ne "";
    print $handle $i1, $mso, 'HyphenMinWord ', $HyphenMinWord, $msc, "\n"
	if $HyphenMinWord ne "";
    print $handle $i1, $mso, 'PgfLetterSpace ', $LetterSpace, $msc, "\n"
	if $LetterSpace ne "";
    print $handle $i1, $mso, 'PgfMinWordSpace ', $MinWordSpace, $msc, "\n"
	if $MinWordSpace ne "";
    print $handle $i1, $mso, 'PgfOptWordSpace ', $OptWordSpace, $msc, "\n"
	if $OptWordSpace ne "";
    print $handle $i1, $mso, 'PgfMaxWordSpace ', $MaxWordSpace, $msc, "\n"
	if $MaxWordSpace ne "";
    print $handle $i1, $mso, 'PgfLanguage ', $Language, $msc, "\n"
	if $Language ne "";
    print $handle $i1, $mso, 'PgfCellAlignment ', $CellAlignment, $msc, "\n"
	if $CellAlignment ne "";
    print $handle $i1, $mso, 'PgfCellMargins ', $CellMargins, $msc, "\n"
	if $CellMargins ne "";
    print $handle $i1, $mso, 'PgfCellLMarginFixed ', $CellLMarginFixed,
		       $msc, "\n"
	if $CellLMarginFixed ne "";
    print $handle $i1, $mso, 'PgfCellTMarginFixed ', $CellTMarginFixed,
		       $msc, "\n"
	if $CellTMarginFixed ne "";
    print $handle $i1, $mso, 'PgfCellRMarginFixed ', $CellRMarginFixed,
		       $msc, "\n"
	if $CellRMarginFixed ne "";
    print $handle $i1, $mso, 'PgfCellBMarginFixed ', $CellBMarginFixed,
		       $msc, "\n"
	if $CellBMarginFixed ne "";
    print $handle $i0, $msc, " $como end of Pgf\n";
}
##---------------------------------------------------------------------------##
##	MIFget_last_pgf_data() is a convienence routine that returns the
##	data associated with the last Pgf statement.  This routine
##	is mainly used by other mif_* libraries that need to process
##	Pgf statements (eg. mif_pgfc).
##
##	Usage:
##	    @array = &'MIFget_last_pgf_data();
##
sub main'MIFget_last_pgf_data {
    ($pgf_Tag,
     $pgf_UseNextTag,
     $pgf_NextTag,
     $pgf_FIndent,
     $pgf_LIndent,
     $pgf_RIndent,
     $pgf_Alignment,
     $pgf_SpBefore,
     $pgf_SpAfter,
     $pgf_LineSpacing,
     $pgf_Leading,
     $pgf_NumTabs,
     $pgf_TabStops,
     $pgf_Placement,
     $pgf_PlacementStyle,
     $pgf_RunInDefaultPunct,
     $pgf_WithPrev,
     $pgf_WithNext,
     $pgf_BlockSize,
     $pgf_AutoNum,
     $pgf_NumFormat,
     $pgf_NumberFont,
     $pgf_NumAtEnd,
     $pgf_Hyphenate,
     $pgf_HyphenMaxLines,
     $pgf_HyphenMinPrefix,
     $pgf_HyphenMinSuffix,
     $pgf_HyphenMinWord,
     $pgf_LetterSpace,
     $pgf_MinWordSpace,
     $pgf_OptWordSpace,
     $pgf_MaxWordSpace,
     $pgf_Language,
     $pgf_TopSeparator,
     $pgf_BotSeparator,
     $pgf_CellAlignment,
     $pgf_CellMargins,
     $pgf_CellLMarginFixed,
     $pgf_CellTMarginFixed,
     $pgf_CellRMarginFixed,
     $pgf_CellBMarginFixed,
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
##	store the information contained in Pgf statement.		     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
sub Pgf {
    local($token, $mode, *data) = @_;

    if ($mode == $MOpen) {
	$_font_orgfunc = &'MIFget_font_func();
	&'MIFset_font_func("mif_pgf'font_close");
	$_tab_orgfunc = &'MIFget_tab_func();
	&'MIFset_tab_func("mif_pgf'tab_close");

	$pgf_Tag		= "";
	$pgf_UseNextTag		= "";
	$pgf_NextTag		= "";
	$pgf_FIndent		= "";
	$pgf_LIndent		= "";
	$pgf_RIndent		= "";
	$pgf_Alignment		= "";
	$pgf_SpBefore		= "";
	$pgf_SpAfter		= "";
	$pgf_LineSpacing	= "";
	$pgf_Leading		= "";
	$pgf_NumTabs		= "";
	$pgf_TabStops		= "";
	$pgf_Placement		= "";
	$pgf_PlacementStyle	= "";
	$pgf_RunInDefaultPunct	= "";
	$pgf_WithPrev		= "";
	$pgf_WithNext		= "";
	$pgf_BlockSize		= "";
	$pgf_AutoNum		= "";
	$pgf_NumFormat		= "";
	$pgf_NumberFont		= "";
	$pgf_NumAtEnd		= "";
	$pgf_Hyphenate		= "";
	$pgf_HyphenMaxLines	= "";
	$pgf_HyphenMinPrefix	= "";
	$pgf_HyphenMinSuffix	= "";
	$pgf_HyphenMinWord	= "";
	$pgf_LetterSpace	= "";
	$pgf_MinWordSpace	= "";
	$pgf_OptWordSpace	= "";
	$pgf_MaxWordSpace	= "";
	$pgf_Language		= "";
	$pgf_TopSeparator	= "";
	$pgf_BotSeparator	= "";
	$pgf_CellAlignment	= "";
	$pgf_CellMargins	= "";
	$pgf_CellLMarginFixed	= "";
	$pgf_CellTMarginFixed	= "";
	$pgf_CellRMarginFixed	= "";
	$pgf_CellBMarginFixed	= "";

	$fnt_Tag		= "";
	$fnt_Family		= "";
	$fnt_Angle		= "";
	$fnt_Weight		= "";
	$fnt_Var		= "";
	$fnt_PostScriptName	= "";
	$fnt_PlatformName	= "";
	$fnt_Size		= "";
	$fnt_Color		= "";
	$fnt_Underline		= "";
	$fnt_DoubleUnderline	= "";
	$fnt_NumericUnderline	= "";
	$fnt_Underlining	= "";
	$fnt_Overline		= "";
	$fnt_Strike		= "";
	$fnt_SupScript		= "";
	$fnt_SubScript		= "";
	$fnt_ChangeBar		= "";
	$fnt_Position		= "";
	$fnt_Outline		= "";
	$fnt_Shadow		= "";
	$fnt_PairKern		= "";
	$fnt_Case		= "";
	$fnt_DX			= "";
	$fnt_DY			= "";
	$fnt_DW			= "";
	$fnt_Plain		= "";
	$fnt_Bold		= "";
	$fnt_Italic		= "";
	$fnt_Separation		= "";
    } elsif ($mode == $MClose) {
	&$pgf_close_func() if $pgf_close_func;
	&'MIFset_font_func($_font_orgfunc);
	&'MIFset_tab_func($_tab_orgfunc);
    } else {
	warn "Unexpected mode, $mode, passed to Pgf routine\n";
    }
}
##---------------------------------------------------------------------------
sub PgfTag {
    local($token, $mode, *data) = @_;
    ($pgf_Tag) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub PgfUseNextTag {
    local($token, $mode, *data) = @_;
    ($pgf_UseNextTag) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfNextTag {
    local($token, $mode, *data) = @_;
    ($pgf_NextTag) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub PgfFIndent {
    local($token, $mode, *data) = @_;
    ($pgf_FIndent) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfLIndent {
    local($token, $mode, *data) = @_;
    ($pgf_LIndent) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfRIndent {
    local($token, $mode, *data) = @_;
    ($pgf_RIndent) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfAlignment {
    local($token, $mode, *data) = @_;
    ($pgf_Alignment) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfSpBefore {
    local($token, $mode, *data) = @_;
    ($pgf_SpBefore) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfSpAfter {
    local($token, $mode, *data) = @_;
    ($pgf_SpAfter) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfLineSpacing {
    local($token, $mode, *data) = @_;
    ($pgf_LineSpacing) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfLeading {
    local($token, $mode, *data) = @_;
    ($pgf_Leading) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfNumTabs {
    local($token, $mode, *data) = @_;
    ($pgf_NumTabs) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfPlacement {
    local($token, $mode, *data) = @_;
    ($pgf_Placement) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfPlacementStyle {
    local($token, $mode, *data) = @_;
    ($pgf_PlacementStyle) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfRunInDefaultPunct {
    local($token, $mode, *data) = @_;
    ($pgf_RunInDefaultPunct) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub PgfWithPrev {
    local($token, $mode, *data) = @_;
    ($pgf_WithPrev) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfWithNext {
    local($token, $mode, *data) = @_;
    ($pgf_WithNext) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfBlockSize {
    local($token, $mode, *data) = @_;
    ($pgf_BlockSize) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfAutoNum {
    local($token, $mode, *data) = @_;
    ($pgf_AutoNum) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfNumFormat {
    local($token, $mode, *data) = @_;
    ($pgf_NumFormat) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub PgfNumberFont {
    local($token, $mode, *data) = @_;
    ($pgf_NumberFont) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub PgfNumAtEnd {
    local($token, $mode, *data) = @_;
    ($pgf_NumAtEnd) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfHyphenate {
    local($token, $mode, *data) = @_;
    ($pgf_Hyphenate) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub HyphenMaxLines {
    local($token, $mode, *data) = @_;
    ($pgf_HyphenMaxLines) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub HyphenMinPrefix {
    local($token, $mode, *data) = @_;
    ($pgf_HyphenMinPrefix) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub HyphenMinSuffix {
    local($token, $mode, *data) = @_;
    ($pgf_HyphenMinSuffix) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub HyphenMinWord {
    local($token, $mode, *data) = @_;
    ($pgf_HyphenMinWord) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfLetterSpace {
    local($token, $mode, *data) = @_;
    ($pgf_LetterSpace) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfMinWordSpace {
    local($token, $mode, *data) = @_;
    ($pgf_MinWordSpace) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfOptWordSpace {
    local($token, $mode, *data) = @_;
    ($pgf_OptWordSpace) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfMaxWordSpace {
    local($token, $mode, *data) = @_;
    ($pgf_MaxWordSpace) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfLanguage {
    local($token, $mode, *data) = @_;
    ($pgf_Language) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfTopSeparator {
    local($token, $mode, *data) = @_;
    ($pgf_TopSeparator) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub PgfBotSeparator {
    local($token, $mode, *data) = @_;
    ($pgf_BotSeparator) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub PgfCellAlignment {
    local($token, $mode, *data) = @_;
    ($pgf_CellAlignment) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfCellMargins {
    local($token, $mode, *data) = @_;
    ($pgf_CellMargins) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfCellLMarginFixed {
    local($token, $mode, *data) = @_;
    ($pgf_CellLMarginFixed) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfCellTMarginFixed {
    local($token, $mode, *data) = @_;
    ($pgf_CellTMarginFixed) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfCellRMarginFixed {
    local($token, $mode, *data) = @_;
    ($pgf_CellRMarginFixed) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub PgfCellBMarginFixed {
    local($token, $mode, *data) = @_;
    ($pgf_CellBMarginFixed) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub tab_close {
    $pgf_TabStops .= $ts if $pgf_TabStops;
    $pgf_TabStops .= join($tf, &'MIFget_last_tab_data());
}
##---------------------------------------------------------------------------
sub font_close {
    local($token);
    ($token,
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
     $fnt_Separation) = &'MIFget_last_font_data();
}
##---------------------------------------------------------------------------
1;
