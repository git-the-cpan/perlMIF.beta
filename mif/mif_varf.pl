##---------------------------------------------------------------------------##
##  File:
##      mif_varf.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_varf" perl package.  It defines
##	routines to handle the VariableFormats via MIFread_mif() defined in
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

package mif_varf;

##-------------------------------------------------##
## Add VariableFormats function to %MIFToken array ##
##-------------------------------------------------##
$mif'MIFToken{'VariableFormats'} = 'VariableFormats';

##------------------------------------##
## VariableFormats associative arrays ##
##------------------------------------##
%VariableDef	= ();	# Variable definition

##-------------------------------------------------##
## Variables for current VariableFormat definition ##
##-------------------------------------------------##
$var_Name	= "";
$var_Def	= "";

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
##	MIFwrite_varf() outputs the VariableFormats as defined by the
##	associative arrays.
##
##	Usage:
##	    &'MIFwrite_varf(FILEHANDLE);
##
sub main'MIFwrite_varf {
    local($handle, $l) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, 'VariableFormats', "\n";
    foreach (sort keys %VariableDef) {
	print $handle $i1, $mso, "VariableFormat\n";
	print $handle $i2, $mso, 'VariableName ', $stb, $_, $ste, $msc, "\n";
	print $handle $i2, $mso, 'VariableDef ', $stb, $VariableDef{$_},
			   $ste, $msc, "\n";
	print $handle $i1, $msc, " $como end of VariableFormat\n";
    }
    print $handle $i0, $msc, " $como end of VariableFormats\n";
}
##---------------------------------------------------------------------------##
##	MIFget_variable_data() returns the data associated with the Frame
##	variable $variable.
##
##	Usage:
##	    ($def) = &'MIFget_variable_data($variable);
##
sub main'MIFget_variable_data {
    local($variable) = @_;
    ($VariableDef{$variable});
}
##---------------------------------------------------------------------------##
##	MIFget_variables() returns a sorted array of all variables defined
##	in variable formats.
##
##	Usage:
##	    @variables = &'MIFget_variables();
##
sub main'MIFget_variables {
    return sort keys %VariableDef;
}
##---------------------------------------------------------------------------##
##	MIFreset_varf() resets the associative arrays for the variable
##	formats.
##
##	Usage:
##	    &'MIFreset_varf();
##
sub main'MIFreset_varf {
    undef %VariableDef;
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the read_mif() routine.  There purpose is to	     ##
##	store the information contained in VariableFormats.		     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
##	VariableFormats() is the token routine for 'VariableFormats'.
##	It sets/restores token routines depending upon mode.
##
sub mif'VariableFormats {
    local($token, $mode, *data) = @_;
    if ($mode == $MOpen) {
	($_fast, $_noidata) = ($mif'fast, $mif'no_import_data);
	($mif'fast, $mif'no_import_data) = (1, 1);
	@_v_orgfunc = @mif'MIFToken{
				'VariableFormat',
				'VariableName',
				'VariableDef'
			};
	@mif'MIFToken{
		'VariableFormat',
		'VariableName',
		'VariableDef'
	} = (
		"mif_varf'VariableFormat",
		"mif_varf'VariableName",
		"mif_varf'VariableDef"
	);
    } elsif ($mode == $MClose) {
	@mif'MIFToken{
		'VariableFormat',
		'VariableName',
		'VariableDef'
	} = @_v_orgfunc;
        ($mif'fast, $mif'no_import_data) = ($_fast, $_noidata);
    }
}
##---------------------------------------------------------------------------
sub VariableFormat {
    local($token, $mode, *data) = @_;

    if ($mode == $MOpen) {
	$var_Name = "";
	$var_Def = "";
    } elsif ($mode == $MClose) {
	$VariableDef{$var_Name} = $var_Def;
    } else {
	warn "Unexpected mode, $mode, passed to VariableFormat routine\n";
    }
}
##---------------------------------------------------------------------------
sub VariableName {
    local($token, $mode, *data) = @_;
    ($var_Name) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub VariableDef {
    local($token, $mode, *data) = @_;
    ($var_Def) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
1;
