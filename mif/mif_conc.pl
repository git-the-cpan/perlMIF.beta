##---------------------------------------------------------------------------##
##  File:
##      mif_conc.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_conc" perl package.  It defines
##	routines to handle the ConditionCatalog via MIFread_mif() defined in
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

package mif_conc;

##--------------------------------------------------##
## Add ConditionCatalog function to %MIFToken array ##
##--------------------------------------------------##
$mif'MIFToken{'ConditionCatalog'} = 'ConditionCatalog';

##-------------------------------------##
## ConditionCatalog associative arrays ##
##-------------------------------------##
%CState		= ();
%CStyle		= ();
%CColor		= ();	# Frame 4.x
%CSeparation	= ();	# Frame 3.x

##--------------------------------------------##
## Variables for current Condition definition ##
##--------------------------------------------##
$cc_Color	= "";
$cc_Separation	= "";
$cc_State	= "";
$cc_Style	= "";
$cc_Tag		= "";

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
##	MIFwrite_conc() outputs the ConditionCatalog as defined by the
##	associative arrays.
##
##	Usage:
##	    &'MIFwrite_conc(FILEHANDLE);
##
sub main'MIFwrite_conc {
    local($handle, $l) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, 'ConditionCatalog', "\n";
    foreach (sort keys %CState) {
	print $handle $i1, $mso, "Condition\n";
	print $handle $i2, $mso, 'CTag ', $stb, $_, $ste, $msc, "\n";
	print $handle $i2, $mso, 'CState ', $CState{$_}, $msc, "\n";
	print $handle $i2, $mso, 'CStyle ', $CStyle{$_}, $msc, "\n";
	print $handle $i2, $mso, 'CSeparation ', $CSeparation{$_}, $msc, "\n"
	    if $CSeparation{$_} ne "";
	print $handle $i2, $mso, 'CColor ', $stb, $CColor{$_}, $ste, $msc, "\n"
	    if $CColor{$_} ne "";
	print $handle $i1, $msc, " $como end of Condition\n";
    }
    print $handle $i0, $msc, " $como end of ConditionCatalog\n";
}
##---------------------------------------------------------------------------##
##	MIFget_condition_data() is a convienence routine that returns
##	the data associated with a Frame condition.
##
##	Usage:
##	    ($state, $style, $color, $sep) =
##		&'MIFget_condition_data($condition);
##
sub main'MIFget_condition_data {
    local($condition) = @_;
    ($CState{$condition},
     $CStyle{$condition}, 
     $CColor{$condition}, 
     $CSeparation{$condition});
}
##---------------------------------------------------------------------------##
##      MIFget_conditions() returns a sorted array of all condition names
##	defined in the condition catalog.
##
##      Usage:
##          @conditions = &'MIFget_conditions();
##
sub main'MIFget_conditions {
    return sort keys %CState;
}
##---------------------------------------------------------------------------##
##	MIFreset_conc() resets the associative arrays for the condition
##	catalog.
##
##	Usage:
##	    &'MIFreset_conc();
##
sub main'MIFreset_conc {
    undef %CState;
    undef %CStyle;
    undef %CColor;
    undef %CSeparation;
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the read_mif() routine.  There purpose is to	     ##
##	store the information contained in the condition catalog.	     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
##	ConditionCatalog() is the token routine for 'ConditionCatalog'.
##	It sets/restores token routines depending upon mode.
##
sub mif'ConditionCatalog {
    local($token, $mode, *data) = @_;
    if ($mode == $MOpen) {
	($_fast, $_noidata) = ($mif'fast, $mif'no_import_data);
	($mif'fast, $mif'no_import_data) = (1, 1);
	@_conc_orgfunc = @mif'MIFToken{
				'Condition',
				'CTag',
				'CState',
				'CStyle',
				'CColor',
				'CSeparation'
			};
	@mif'MIFToken{
		'Condition',
		'CTag',
		'CState',
		'CStyle',
		'CColor',
		'CSeparation'
	} = (
		"mif_conc'Condition",
		"mif_conc'CTag",
		"mif_conc'CState",
		"mif_conc'CStyle",
		"mif_conc'CColor",
		"mif_conc'CSeparation"
	);
    } elsif ($mode == $MClose) {
	@mif'MIFToken{
		'Condition',
		'CTag',
		'CState',
		'CStyle',
		'CColor',
		'CSeparation'
	} = @_conc_orgfunc;
        ($mif'fast, $mif'no_import_data) = ($_fast, $_noidata);
    }
}
##---------------------------------------------------------------------------
sub Condition {
    local($token, $mode, *data) = @_;

    if ($mode == $MOpen) {
	$cc_Color = "";
	$cc_Separation = "";
	$cc_State = "";
	$cc_Style = "";
	$cc_Tag	 = "";
    } elsif ($mode == $MClose) {
	$CState{$cc_Tag} = $cc_State;
	$CStyle{$cc_Tag} = $cc_Style;
	$CColor{$cc_Tag} = $cc_Color;
	$CSeparation{$cc_Tag} = $cc_Separation;
    } else {
	warn "Unexpected mode, $mode, passed to Condition routine\n";
    }
}
##---------------------------------------------------------------------------
sub CTag {
    local($token, $mode, *data) = @_;
    ($cc_Tag) = $data =~ /^\s*$stb([^$ste]*)$ste\s*$/o;
}
##---------------------------------------------------------------------------
sub CState {
    local($token, $mode, *data) = @_;
    ($cc_State) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub CStyle {
    local($token, $mode, *data) = @_;
    ($cc_Style) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub CSeparation {
    local($token, $mode, *data) = @_;
    ($cc_Separation) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub CColor {
    local($token, $mode, *data) = @_;
    ($cc_Color) = $data =~ /^\s*$stb([^$ste]*)$ste\s*$/o;
}
##---------------------------------------------------------------------------
1;
