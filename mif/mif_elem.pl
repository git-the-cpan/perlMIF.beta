##---------------------------------------------------------------------------##
##  File:
##      mif_elem.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_elem" perl package.  It defines
##	routines to handle ElementBegin/End via MIFread_mif() defined in
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

package mif_elem;

##--------------------------------------##
## Add Font routines to %MIFToken array ##
##--------------------------------------##
$mif'MIFToken{'ElementBegin'} = 'ElementBegin';
$mif'MIFToken{'ElementEnd'} = 'ElementEnd';
$mif'MIFToken{'ETag'} = "mif_elem'ETag";
$mif'MIFToken{'Collapsed'} = "mif_elem'Collapsed";
$mif'MIFToken{'SpecialCase'} = "mif_elem'SpecialCase";

##--------------------##
## mif_elem variables ##
##--------------------##
$eb_func = "";	# Function to call during ElementBegin closure.
$ee_func = "";	# Function to call when ElementEnd occurs (passed tagstring)

##-----------------------------------------------##
## Variables for current ElementBegin definition ##
##-----------------------------------------------##
$ETag			= "";
$Collapsed		= "";
$SpecialCase		= "";

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
##	MIFget_elem_funcs() returns the functions that are called for
##	ElementBegin and ElementEnd statements.
##
##	Usage:
##	    ($beginfunc, $endfunc) = &'MIFget_elem_funcs();
##
sub main'MIFget_elem_funcs {
    ($eb_func, $ee_func);
}
##---------------------------------------------------------------------------
##	MIFset_elem_funcs() sets the functions that are called for
##	ElementBegin and ElementEnd statements.
##
##	Usage:
##	    &'MIFset_elem_funcs($beginfunc, $endfunc);
##
sub main'MIFset_elem_funcs {
    ($eb_func, $ee_func) = @_;
}
##---------------------------------------------------------------------------
##	MIFwrite_elem_beg() outputs the ElementBegin in MIF.
##
##	Usage:
##	    &'MIFwrite_elem_beg(FILEHANDLE,$indent,$tag,$collapsed,$specase);
##
sub main'MIFwrite_elem_beg {
    local($handle, $l, $tag, $collapsed, $specase) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, "ElementBegin\n";
    print $handle $i1, $mso, 'ETag ', $stb, $tag, $ste, $msc, "\n";
    print $handle $i1, $mso, 'Collapsed ', $collapsed, $msc, "\n"
	if $collapsed ne "";
    print $handle $i1, $mso, 'SpecialCase ', $specase, $msc, "\n"
	if $SpecialCase ne "";
    print $handle $i0, $msc, " $como end of ElementBegin\n";
}
##---------------------------------------------------------------------------##
##	MIFwrite_elem_end() outputs ElementEnd in MIF.
##
##	Usage:
##	    &'MIFwrite_elem_end(FILEHANDLE, $indent, $tag);
##
sub main'MIFwrite_elem_end {
    local($handle, $l, $tag);
    local($i0) = (' ' x $l);
    local($tmp) = (($tag ne "" ? $stb.$tag.$ste : ""));
    print $handle $i0, $mso, 'ElementEnd ', $tmp, $msc, "\n";
}
##---------------------------------------------------------------------------##
##	MIFget_last_elem_beg() is a convienence routine that returns the
##	data associated with the last ElementBegin statement.  This routine
##	is mainly used by other mif_* libraries that need to process
##	ElementBegin statements.
##
##	Usage:
##	    ($tag, $collapsed, $specase) = &'MIFget_last_elem_beg();
##
sub main'MIFget_last_elem_beg {
    ($ETag, $Collapsed, $SpecialCase);
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the MIFread_mif() routine.  There purpose is to     ##
##	store the information contained in ElementBegin/End statements.	     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
sub mif'ElementBegin {
    local($token, $mode, *data) = @_;

    if ($mode == $MOpen) {
	$ETag		= "";
	$Collapsed	= "";
	$SpecialCase	= "";
    } elsif ($mode == $MClose) {
	&$eb_func() if $eb_func;
    } else {
	warn "Unexpected mode, $mode, passed to ElementBegin routine\n";
    }
}
##---------------------------------------------------------------------------
sub mif'ElementEnd {
    local($token, $mode, *data) = @_;
    $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
    &$ee_func($1) if $ee_func;
}
##---------------------------------------------------------------------------
sub ETag {
    local($token, $mode, *data) = @_;
    ($ETag) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub Collapsed {
    local($token, $mode, *data) = @_;
    ($Collapsed) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub SpecialCase {
    local($token, $mode, *data) = @_;
    ($SpecialCase) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
1;
