##---------------------------------------------------------------------------##
##  File:
##      mif_rulc.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_rulc" perl package.  It defines
##	routines to handle the RulingCatalog via MIFread_mif() defined in
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

package mif_rulc;

##-----------------------------------------------##
## Add RulingCatalog function to %MIFToken array ##
##-----------------------------------------------##
$mif'MIFToken{'RulingCatalog'} = 'RulingCatalog';

##----------------------------------##
## RulingCatalog associative arrays ##
##----------------------------------##
%RulingPenWidth	= ();
%RulingGap	= ();
%RulingColor	= ();	# Frame 4.x
%RulingSeparation = ();	# Frame 3.x
%RulingPen	= ();
%RulingLines	= ();

##-----------------------------------------##
## Variables for current Ruling definition ##
##-----------------------------------------##
$rulc_Tag	= "";
$rulc_PenWidth	= "";
$rulc_Gap	= "";
$rulc_Color	= "";
$rulc_Separation = "";
$rulc_Pen	= "";
$rulc_Lines	= "";

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
##	MIFwrite_rulc() outputs the RulingCatalog as defined by the
##	associative arrays.
##
##	Usage:
##	    &'MIFwrite_rulc(FILEHANDLE);
##
sub main'MIFwrite_rulc {
    local($handle, $l) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, 'RulingCatalog', "\n";
    foreach (sort keys %RulingPenWidth) {
	print $handle $i1, $mso, "Ruling\n";
	print $handle $i2, $mso, 'RulingTag ', $stb, $_, $ste, $msc, "\n";
	print $handle $i2, $mso, 'RulingPenWidth ', $RulingPenWidth{$_}, $msc,
			   "\n"
	    if $RulingPenWidth{$_} ne "";
	print $handle $i2, $mso, 'RulingGap ', $RulingGap{$_}, $msc,
			   "\n"
	    if $RulingGap{$_} ne "";
	print $handle $i2, $mso, 'RulingSeparation ', $RulingSeparation{$_},
			   $msc, "\n"
	    if $RulingSeparation{$_} ne "";
	print $handle $i2, $mso, 'RulingColor ', $stb, $RulingColor{$_}, $ste,
			   $msc, "\n"
	    if $RulingColor{$_} ne "";
	print $handle $i2, $mso, 'RulingPen ', $RulingPen{$_}, $msc,
			   "\n"
	    if $RulingPen{$_} ne "";
	print $handle $i2, $mso, 'RulingLines ', $RulingLines{$_}, $msc,
			   "\n"
	    if $RulingLines{$_} ne "";
	print $handle $i1, $msc, " $como end of Ruling\n";
    }
    print $handle $i0, $msc, " $como end of RulingCatalog\n";
}
##---------------------------------------------------------------------------##
##	MIFget_ruling_data() is a convienence routine that returns
##	the data associated with the ruling $ruling.
##
##	Usage:
##	    ($penwidth, $gap, $color, $sep, $pen, $lines) =
##		&'MIFget_ruling_data($ruling);
##
sub main'MIFget_ruling_data {
    local($ruling) = @_;
    ($RulingPenWidth{$ruling},
     $RulingGap{$ruling}, 
     $RulingColor{$ruling}, 
     $RulingSeparation{$ruling}, 
     $RulingPen{$ruling}, 
     $RulingLines{$ruling});
}
##---------------------------------------------------------------------------##
##      MIFget_rulings() returns a sorted array of all ruling names
##	defined in the ruling catalog.
##
##      Usage:
##          @rulings = &'MIFget_rulings();
##
sub main'MIFget_rulings {
    return sort keys %RulingPenWidth;
}
##---------------------------------------------------------------------------##
##	MIFreset_rulc() resets the associative arrays for the ruling
##	catalog.
##
##	Usage:
##	    &'MIFreset_rulc();
##
sub main'MIFreset_rulc {
    undef %RulingPenWidth;
    undef %RulingGap;
    undef %RulingColor;
    undef %RulingSeparation;
    undef %RulingPen;
    undef %RulingLines;
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the read_mif() routine.  There purpose is to	     ##
##	store the information contained in the ruling catalog.		     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
##	RulingCatalog() is the token routine for 'RulingCatalog'.
##	It sets/restores token routines depending upon mode.
##
sub mif'RulingCatalog {
    local($token, $mode, *data) = @_;
    if ($mode == $MOpen) {
	($_fast, $_noidata) = ($mif'fast, $mif'no_import_data);
	($mif'fast, $mif'no_import_data) = (1, 1);
	@_rulc_orgfunc = @mif'MIFToken{
				'Ruling',
				'RulingTag',
				'RulingPenWidth',
				'RulingGap',
				'RulingColor',
				'RulingSeparation',
				'RulingPen',
				'RulingLines'
			};
	@mif'MIFToken{
		'Ruling',
		'RulingTag',
		'RulingPenWidth',
		'RulingGap',
		'RulingColor',
		'RulingSeparation',
		'RulingPen',
		'RulingLines'
	} = (
		"mif_rulc'Ruling",
		"mif_rulc'RulingTag",
		"mif_rulc'RulingPenWidth",
		"mif_rulc'RulingGap",
		"mif_rulc'RulingColor",
		"mif_rulc'RulingSeparation",
		"mif_rulc'RulingPen",
		"mif_rulc'RulingLines"
	);
    } elsif ($mode == $MClose) {
	@mif'MIFToken{
		'Ruling',
		'RulingTag',
		'RulingPenWidth',
		'RulingGap',
		'RulingColor',
		'RulingSeparation',
		'RulingPen',
		'RulingLines'
	} = @_rulc_orgfunc;
        ($mif'fast, $mif'no_import_data) = ($_fast, $_noidata);
    }
}
##---------------------------------------------------------------------------
sub Ruling {
    local($token, $mode, *data) = @_;

    if ($mode == $MOpen) {
	$rulc_Tag = "";
	$rulc_PenWidth = "";
	$rulc_Gap = "";
	$rulc_Color = "";
	$rulc_Separation = "";
	$rulc_Pen = "";
	$rulc_Lines = "";
    } elsif ($mode == $MClose) {
	$RulingPenWidth{$rulc_Tag} = $rulc_PenWidth;
	$RulingGap{$rulc_Tag} = $rulc_Gap;
	$RulingColor{$rulc_Tag} = $rulc_Color;
	$RulingSeparation{$rulc_Tag} = $rulc_Separation;
	$RulingPen{$rulc_Tag} = $rulc_Pen;
	$RulingLines{$rulc_Tag} = $rulc_Lines;
    } else {
	warn "Unexpected mode, $mode, passed to Ruling routine\n";
    }
}
##---------------------------------------------------------------------------
sub RulingTag {
    local($token, $mode, *data) = @_;
    ($rulc_Tag) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub RulingColor {
    local($token, $mode, *data) = @_;
    ($rulc_Color) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub RulingPenWidth {
    local($token, $mode, *data) = @_;
    ($rulc_PenWidth) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub RulingGap {
    local($token, $mode, *data) = @_;
    ($rulc_Gap) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub RulingPen {
    local($token, $mode, *data) = @_;
    ($rulc_Pen) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub RulingLines {
    local($token, $mode, *data) = @_;
    ($rulc_Lines) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub RulingSeparation {
    local($token, $mode, *data) = @_;
    ($rulc_Separation) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
1;
