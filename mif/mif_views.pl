##---------------------------------------------------------------------------##
##  File:
##      mif_views.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_views" perl package.  It defines
##	routines to handle the Views via MIFread_mif() defined in
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

package mif_views;

##---------------------------------------##
## Add Views function to %MIFToken array ##
##---------------------------------------##
$mif'MIFToken{'Views'} = 'Views';

##--------------------------##
## Views associative arrays ##
##--------------------------##
%ViewCutout	= ();	# $; separated string of cutout colors
%ViewInvisible	= ();	# $; separated string of hidden colors

##---------------------------------------##
## Variables for current View definition ##
##---------------------------------------##
$v_Number	= "";
$v_Cutout	= "";
$v_Invisible	= "";

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
##	MIFwrite_views() outputs the Views as defined by the
##	associative arrays.
##
##	Usage:
##	    &'MIFwrite_views(FILEHANDLE);
##
sub main'MIFwrite_views {
    local($handle, $l) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, 'Views', "\n";
    foreach (sort keys %ViewCutout) {
	print $handle $i1, $mso, "View\n";
	print $handle $i2, $mso, 'ViewNumber ', $_, $msc, "\n";
	if ($ViewCutout{$_}) {
	    foreach (split(/$;/, $ViewCutout{$_})) {
		print $handle $i2, $mso, 'ViewCutout ', $stb, $_,
				   $ste, $msc, "\n";
	    }
	}
	if ($ViewInvisible{$_}) {
	    foreach (split(/$;/, $ViewInvisible{$_})) {
		print $handle $i2, $mso, 'ViewInvisible ', $stb,
				   $_, $ste, $msc, "\n";
	    }
	}
	print $handle $i1, $msc, " $como end of View\n";
    }
    print $handle $i0, $msc, " $como end of Views\n";
}
##---------------------------------------------------------------------------##
##	MIFget_view_data() returns the data associated with the Frame
##	view $view.
##
##	Usage:
##	    ($cutout, $invisible) = &'MIFget_view_data($color);
##
##	Note: Return strings contain $; separated values.
##
sub main'MIFget_view_data {
    local($view) = @_;
    ($ViewCutout{$view}, $ViewInvisible{$view});
}
##---------------------------------------------------------------------------##
##	MIFget_views() returns a sorted array of all view numbers defined
##	in the view catalog.
##
##	Usage:
##	    @views = &'MIFget_views();
##
sub main'MIFget_views {
    return sort keys %ViewCutout;
}
##---------------------------------------------------------------------------##
##	MIFreset_views() resets the associative arrays for the views.
##
##	Usage:
##	    &'MIFreset_views();
##
sub main'MIFreset_views {
    undef %ViewCutout;
    undef %ViewInvisible;
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the read_mif() routine.  There purpose is to	     ##
##	store the information contained in the views statement.		     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
##	Views() is the token routine for 'Views'.
##	It sets/restores token routines depending upon mode.
##
sub mif'Views {
    local($token, $mode, *data) = @_;
    if ($mode == $MOpen) {
	($_fast, $_noidata) = ($mif'fast, $mif'no_import_data);
	($mif'fast, $mif'no_import_data) = (1, 1);
	@_v_orgfunc = @mif'MIFToken{
				'View',
				'ViewNumber',
				'ViewCutout',
				'ViewInvisible'
			};
	@mif'MIFToken{
		'View',
		'ViewNumber',
		'ViewCutout',
		'ViewInvisible'
	} = (
		"mif_views'View",
		"mif_views'ViewNumber",
		"mif_views'ViewCutout",
		"mif_views'ViewInvisible"
	);
    } elsif ($mode == $MClose) {
	@mif'MIFToken{
		'View',
		'ViewNumber',
		'ViewCutout',
		'ViewInvisible'
	} = @_v_orgfunc;
        ($mif'fast, $mif'no_import_data) = ($_fast, $_noidata);
    }
}
##---------------------------------------------------------------------------
sub View {
    local($token, $mode, *data) = @_;

    if ($mode == $MOpen) {
	$v_Number = "";
	$v_Cutout = "";
	$v_Invisible = "";
    } elsif ($mode == $MClose) {
	$ViewCutout{$v_Number} = $v_Cutout;
	$ViewInvisible{$v_Number} = $v_Invisible;
    } else {
	warn "Unexpected mode, $mode, passed to View routine\n";
    }
}
##---------------------------------------------------------------------------
sub ViewCutout {
    local($token, $mode, *data) = @_;
    local($tmp);
    $v_Cutout .= $; if $v_Cutout ne "";
    ($tmp) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
    $v_Cutout .= $tmp;
}
##---------------------------------------------------------------------------
sub ViewInvisible {
    local($token, $mode, *data) = @_;
    local($tmp);
    $v_Invisible .= $; if $v_Invisible ne "";
    ($tmp) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
    $v_Invisible .= $tmp;
}
##---------------------------------------------------------------------------
sub ViewNumber {
    local($token, $mode, *data) = @_;
    ($v_Number) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
1;
