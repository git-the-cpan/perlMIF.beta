##---------------------------------------------------------------------------##
##  File:
##      mif_xrefs.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_xrefs" perl package.  It defines
##	routines to handle the XRefFormats via MIFread_mif() defined in
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

package mif_xrefs;

##---------------------------------------------##
## Add XRefFormats function to %MIFToken array ##
##---------------------------------------------##
$mif'MIFToken{'XRefFormats'} = 'XRefFormats';

##--------------------------------##
## XRefFormats associative arrays ##
##--------------------------------##
%XRefDef	= ();	# Cross-reference definition

##---------------------------------------------##
## Variables for current XRefFormat definition ##
##---------------------------------------------##
$x_Name	= "";
$x_Def	= "";

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
##	MIFwrite_xrefs() outputs the XRefFormats as defined by the
##	associative arrays.
##
##	Usage:
##	    &'MIFwrite_xrefs(FILEHANDLE);
##
sub main'MIFwrite_xrefs {
    local($handle, $l) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, 'XRefFormats', "\n";
    foreach (sort keys %XRefDef) {
	print $handle $i1, $mso, "XRefFormat\n";
	print $handle $i2, $mso, 'XRefName ', $stb, $_, $ste, $msc, "\n";
	print $handle $i2, $mso, 'XRefDef ', $stb, $XRefDef{$_},
			   $ste, $msc, "\n";
	print $handle $i1, $msc, " $como end of XRefFormat\n";
    }
    print $handle $i0, $msc, " $como end of XRefFormats\n";
}
##---------------------------------------------------------------------------##
##	MIFget_xref_data() returns the data associated with the Frame
##	xref $xref.
##
##	Usage:
##	    ($def) = &'MIFget_xref_data($xref);
##
sub main'MIFget_xref_data {
    local($xref) = @_;
    ($XRefDef{$xref});
}
##---------------------------------------------------------------------------##
##	MIFget_xrefs() returns a sorted array of all xrefs defined
##	in xref formats.
##
##	Usage:
##	    @xrefs = &'MIFget_xrefs();
##
sub main'MIFget_xrefs {
    return sort keys %XRefDef;
}
##---------------------------------------------------------------------------##
##	MIFreset_xrefs() resets the associative arrays for the xrefs
##	formats.
##
##	Usage:
##	    &'MIFreset_xrefs();
##
sub main'MIFreset_xrefs {
    undef %XRefDef;
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the read_mif() routine.  There purpose is to	     ##
##	store the information contained in XRefFormats.			     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
##	XRefFormats() is the token routine for 'XRefFormats'.
##	It sets/restores token routines depending upon mode.
##
sub mif'XRefFormats {
    local($token, $mode, *data) = @_;
    if ($mode == $MOpen) {
	($_fast, $_noidata) = ($mif'fast, $mif'no_import_data);
	($mif'fast, $mif'no_import_data) = (1, 1);
	@_x_orgfunc = @mif'MIFToken{
				'XRefFormat',
				'XRefName',
				'XRefDef'
			};
	@mif'MIFToken{
		'XRefFormat',
		'XRefName',
		'XRefDef'
	} = (
		"mif_xrefs'XRefFormat",
		"mif_xrefs'XRefName",
		"mif_xrefs'XRefDef"
	);
    } elsif ($mode == $MClose) {
	@mif'MIFToken{
		'XRefFormat',
		'XRefName',
		'XRefDef'
	} = @_x_orgfunc;
        ($mif'fast, $mif'no_import_data) = ($_fast, $_noidata);
    }
}
##---------------------------------------------------------------------------
sub XRefFormat {
    local($token, $mode, *data) = @_;

    if ($mode == $MOpen) {
	$x_Name = "";
	$x_Def = "";
    } elsif ($mode == $MClose) {
	$XRefDef{$x_Name} = $x_Def;
    } else {
	warn "Unexpected mode, $mode, passed to XRefFormat routine\n";
    }
}
##---------------------------------------------------------------------------
sub XRefName {
    local($token, $mode, *data) = @_;
    ($x_Name) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub XRefDef {
    local($token, $mode, *data) = @_;
    ($x_Def) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
1;
