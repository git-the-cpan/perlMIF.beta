##---------------------------------------------------------------------------##
##  File:
##      mif_tab.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_tab" perl package.  It defines
##	routines to handle TabStop via MIFread_mif() defined in
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

package mif_tab;

##-----------------------------------------##
## Add TabStop routines to %MIFToken array ##
##-----------------------------------------##
$mif'MIFToken{'TabStop'} = "mif_tab'TabStop";
@mif'MIFToken{
	'TSX',
	'TSType',
	'TSLeaderStr',
	'TSDecimalChar'
} = (
	"mif_tab'TSX",
	"mif_tab'TSType",
	"mif_tab'TSLeaderStr",
	"mif_tab'TSDecimalChar"
);

##-------------------##
## mif_tab variables ##
##-------------------##
$tab_close_func = "";	# Function to call during TabStop closure.

##------------------------------------------##
## Variables for current TabStop definition ##
##------------------------------------------##
$ts_X			= "";
$ts_Type		= "";
$ts_LeaderStr		= "";
$ts_DecimalChar		= "";

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
##	MIFget_tab_func() returns the function that is called when the
##	TabStop statement closes.
##
##	Usage:
##	    $func = &'MIFget_tab_func();
##
sub main'MIFget_tab_func {
    $tab_close_func;
}
##---------------------------------------------------------------------------
##	MIFset_tab_func() sets the function that is called when the
##	TabStop statement closes.
##
##	Usage:
##	    &'MIFset_tab_func($func);
##
sub main'MIFset_tab_func {
    $tab_close_func = $_[0];
}
##---------------------------------------------------------------------------
##	MIFwrite_tab() outputs the TabStop in MIF.
##
##	Usage:
##	    &'MIFwrite_tab(FILEHANDLE, $indent,
##			   $X, $Type, $LeaderStr, $DecimalChar);
##
sub main'MIFwrite_tab {
    local($handle, $l, $X, $Type, $LeaderStr, $DecimalChar) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, "TabStop\n";
    print $handle $i1, $mso, 'TSX ', $X, $msc, "\n";
    print $handle $i1, $mso, 'TSType ', $Type, $msc, "\n";
    print $handle $i1, $mso, 'TSLeaderStr ', $stb, $LeaderStr, $ste, $msc, "\n";
    print $handle $i1, $mso, 'TSDecimalChar ', $stb, $DecimalChar, $ste,
		       $msc, "\n" if $DecimalChar ne "";
    print $handle $i0, $msc, " $como end of TabStop\n";
}
##---------------------------------------------------------------------------##
##	MIFget_last_tab_data() is a convienence routine that returns the
##	data associated with the last TabStop statement.  This routine
##	is mainly used by other mif_* libraries that need to process
##	TabStop statements (eg. mif_pgfc).
##
##	Usage:
##	    ($x, $type, $leader, $decimalch) = &'MIFget_last_tab_data();
##
sub main'MIFget_last_tab_data {
    ($ts_X,
     $ts_Type,
     $ts_LeaderStr,
     $ts_DecimalChar);
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the MIFread_mif() routine.  There purpose is to     ##
##	store the information contained in TabStop statement.		     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
sub TabStop {
    local($token, $mode, *data) = @_;

    if ($mode == $MOpen) {
	$ts_X			= "";
	$ts_Type		= "";
	$ts_LeaderStr		= "";
	$ts_DecimalChar		= "";
    } elsif ($mode == $MClose) {
	&$tab_close_func() if $tab_close_func;
    } else {
	warn "Unexpected mode, $mode, passed to TabStop routine\n";
    }
}
##---------------------------------------------------------------------------
sub TSX {
    local($token, $mode, *data) = @_;
    ($ts_X) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub TSType {
    local($token, $mode, *data) = @_;
    ($ts_Type) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
sub TSLeaderStr {
    local($token, $mode, *data) = @_;
    ($ts_LeaderStr) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub TSDecimalChar {
    local($token, $mode, *data) = @_;
    ($ts_DecimalChar) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
1;
