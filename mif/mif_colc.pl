##---------------------------------------------------------------------------##
##  File:
##      mif_colc.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_colc" perl package.  It defines
##	routines to handle the ColorCatalog via MIFread_mif() defined in
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

package mif_colc;

##----------------------------------------------##
## Add ColorCatalog function to %MIFToken array ##
##----------------------------------------------##
$mif'MIFToken{'ColorCatalog'} = 'ColorCatalog';

##---------------------------------##
## ColorCatalog associative arrays ##
##---------------------------------##
%ColorCyan	= ();	# Percentage of cyan
%ColorMagenta	= ();	# Percentage of magenta
%ColorYellow	= ();	# Percentage of yellow
%ColorBlack	= ();	# Percentage of black
%ColorPantone	= ();	# Name of PANTONE color
%ColorAttribute = ();	# $; separated string of attributes

##----------------------------------------##
## Variables for current Color definition ##
##----------------------------------------##
$col_Attribute	= "";
$col_Black	= "";
$col_Cyan	= "";
$col_Magenta	= "";
$col_Pantone	= "";
$col_Tag	= "";
$col_Yellow	= "";

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
##	MIFwrite_colc() outputs the ColorCatalog as defined by the
##	associative arrays.
##
##	Usage:
##	    &'MIFwrite_colc(FILEHANDLE);
##
sub main'MIFwrite_colc {
    local($handle, $l) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, 'ColorCatalog', "\n";
    foreach (sort keys %ColorCyan) {
	print $handle $i1, $mso, "Color\n";
	print $handle $i2, $mso, 'ColorTag ', $stb, $_, $ste, $msc, "\n";
	print $handle $i2, $mso, 'ColorCyan ', $ColorCyan{$_}, $msc, "\n";
	print $handle $i2, $mso, 'ColorMagenta ', $ColorMagenta{$_}, $msc, "\n";
	print $handle $i2, $mso, 'ColorYellow ', $ColorYellow{$_}, $msc, "\n";
	print $handle $i2, $mso, 'ColorBlack ', $ColorBlack{$_}, $msc, "\n";
	print $handle $i2, $mso, 'ColorPantoneValue ', $stb,
			   $ColorPantone{$_}, $ste, $msc, "\n"
	    if $ColorPantone{$_};
	if ($ColorAttribute{$_}) {
	    foreach (split(/$;/, $ColorAttribute{$_})) {
		print $handle $i2, $mso, 'ColorAttribute ', $_, $msc, "\n";
	    }
	}
	print $handle $i1, $msc, " $como end of Color\n";
    }
    print $handle $i0, $msc, " $como end of ColorCatalog\n";
}
##---------------------------------------------------------------------------##
##	MIFget_color_data() returns the data associated with the Frame
##	color $color.
##
##	Usage:
##	    ($cyan, $magenta, $yellow, $black, $pantone, $attr) =
##		    &'MIFget_color_data($color);
##
##	Note: $attr is a $; separated string of attributes.
##
sub main'MIFget_color_data {
    local($color) = @_;
    ($ColorCyan{$color}, 
     $ColorMagenta{$color}, 
     $ColorYellow{$color}, 
     $ColorBlack{$color}, 
     $ColorPantone{$color}, 
     $ColorAttribute{$color});
}
##---------------------------------------------------------------------------##
##	Usage:
##	    &'MIFset_color_data($color, $C, $M, $Y, $K, $pantone, $attr);
##
sub main'MIFset_color_data {
    local($color) = shift @_;
    ($ColorCyan{$color}, 
     $ColorMagenta{$color}, 
     $ColorYellow{$color}, 
     $ColorBlack{$color}, 
     $ColorPantone{$color}, 
     $ColorAttribute{$color}) = @_;
}
##---------------------------------------------------------------------------##
##	MIFget_colors() returns a sorted array of all color names defined
##	in the color catalog.
##
##	Usage:
##	    @colors = &'MIFget_colors();
##
sub main'MIFget_colors {
    return sort keys %ColorCyan;
}
##---------------------------------------------------------------------------##
##	MIFreset_colc() resets the associative arrays for the color
##	catalog.
##
##	Usage:
##	    &'MIFreset_colc();
##
sub main'MIFreset_colc {
    undef %ColorCyan;
    undef %ColorMagenta;
    undef %ColorYellow;
    undef %ColorBlack;
    undef %ColorPantone;
    undef %ColorAttribute;
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the read_mif() routine.  There purpose is to	     ##
##	store the information contained in the color catalog.		     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
##	ColorCatalog() is the token routine for 'ColorCatalog'.
##	It sets/restores token routines depending upon mode.
##
sub mif'ColorCatalog {
    local($token, $mode, *data) = @_;
    if ($mode == $MOpen) {
	($_fast, $_noidata) = ($mif'fast, $mif'no_import_data);
	($mif'fast, $mif'no_import_data) = (1, 1);
	@_col_orgfunc = @mif'MIFToken{
				'Color',
				'ColorTag',
				'ColorCyan',
				'ColorMagenta',
				'ColorYellow',
				'ColorBlack',
				'ColorPantoneValue',
				'ColorAttribute'
			};
	@mif'MIFToken{
		'Color',
		'ColorTag',
		'ColorCyan',
		'ColorMagenta',
		'ColorYellow',
		'ColorBlack',
		'ColorPantoneValue',
		'ColorAttribute'
	} = (
		"mif_colc'Color",
		"mif_colc'ColorTag",
		"mif_colc'ColorCyan",
		"mif_colc'ColorMagenta",
		"mif_colc'ColorYellow",
		"mif_colc'ColorBlack",
		"mif_colc'ColorPantoneValue",
		"mif_colc'ColorAttribute"
	);
    } elsif ($mode == $MClose) {
	@mif'MIFToken{
		'Color',
		'ColorTag',
		'ColorCyan',
		'ColorMagenta',
		'ColorYellow',
		'ColorBlack',
		'ColorPantoneValue',
		'ColorAttribute'
	} = @_col_orgfunc;
	($mif'fast, $mif'no_import_data) = ($_fast, $_noidata);
    }
}
##---------------------------------------------------------------------------
sub Color {
    local($token, $mode, *data) = @_;

    if ($mode == $MOpen) {
	$col_Attribute = "";
	$col_Black = "";
	$col_Cyan = "";
	$col_Magenta = "";
	$col_Pantone = "";
	$col_Tag = "";
	$col_Yellow = "";
    } elsif ($mode == $MClose) {
	$ColorCyan{$col_Tag} = $col_Cyan;
	$ColorMagenta{$col_Tag} = $col_Magenta;
	$ColorYellow{$col_Tag} = $col_Yellow;
	$ColorBlack{$col_Tag} = $col_Black;
	$ColorPantone{$col_Tag} = $col_Pantone;
	$ColorAttribute{$col_Tag} = $col_Attribute;
    } else {
	warn "Unexpected mode, $mode, passed to Color routine\n";
    }
}
##---------------------------------------------------------------------------
sub ColorTag {
    local($token, $mode, *data) = @_;
    ($col_Tag) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub ColorPantoneValue {
    local($token, $mode, *data) = @_;
    ($col_Pantone) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub ColorCyan {
    local($token, $mode, *data) = @_;
    ($col_Cyan) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub ColorMagenta {
    local($token, $mode, *data) = @_;
    ($col_Magenta) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub ColorYellow {
    local($token, $mode, *data) = @_;
    ($col_Yellow) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub ColorBlack {
    local($token, $mode, *data) = @_;
    ($col_Black) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub ColorAttribute {
    local($token, $mode, *data) = @_;
    local($tmp);
    $col_Attribute .= $; if $col_Attribute ne "";
    ($tmp) = $data =~ /^\s*(.*)$/o;
    $col_Attribute .= $tmp;
}
##---------------------------------------------------------------------------
1;
