##---------------------------------------------------------------------------##
##  File:
##      mif_char.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_char" perl package.  It defines
##	routines to handle Char via MIFread_mif() defined in
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

package mif_char;

##--------------------------------------##
## Add Chat routine to %MIFToken array ##
##--------------------------------------##
$mif'MIFToken{'Char'} = "Char";

##--------------------##
## mif_font variables ##
##--------------------##
$char_close_func = "";	# Function to call after Char statement.

##---------------------------------------##
## Variables for current Char definition ##
##---------------------------------------##
$Char		= "";

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
##	MIFget_char_func() returns the function that is called when the
##	Char statement closes.
##
##	Usage:
##	    $func = &'MIFget_char_func();
##
sub main'MIFget_char_func {
    $char_close_func;
}
##---------------------------------------------------------------------------
##	MIFset_char_func() sets the function that is called when the
##	Char statement closes.
##
##	Usage:
##	    &'MIFset_char_func($func);
##
sub main'MIFset_tab_func {
    $char_close_func = shift;
}
##---------------------------------------------------------------------------
##	MIFwrite_char() outputs the Char in MIF.
##
##	Usage:
##	    &'MIFwrite_char(FILEHANDLE, $indent, $name);
##
sub main'MIFwrite_char {
    local($handle, $l, $name) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, 'Char ' , $name, $msc, "\n";;
}
##---------------------------------------------------------------------------##
##	MIFget_last_char_data() is a convienence routine that returns the
##	data associated with the last Char statement.  This routine
##	is mainly used by other mif_* libraries that need to process
##	Char statements.
##
##	Usage:
##	    ($char_name) = &'MIFget_last_char_data();
##
sub main'MIFget_last_char_data {
    ($Char);
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the MIFread_mif() routine.  There purpose is to     ##
##	store the information contained in a Char statement.		     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
sub Char {
    local($token, $mode, *data) = @_;
    ($Char) = $data =~ /^\s*(.*)$/o;
    &$char_close_func($Char) if $char_close_func;
}
##---------------------------------------------------------------------------
1;
