##---------------------------------------------------------------------------##
##  File:
##      mif_dict.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_dict" perl package.  It defines
##	routines to handle the Dictionary via MIFread_mif() defined in
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

package mif_dict;

##--------------------------------------------##
## Add Dictionary function to %MIFToken array ##
##--------------------------------------------##
$mif'MIFToken{'Dictionary'} = 'Dictionary';

##-------------------------------##
## Dictionary associative arrays ##
##-------------------------------##
%OKWord		= ();

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
##	MIFwrite_dict() outputs the Dictionary as defined by the
##	associative arrays.
##
##	Usage:
##	    &'MIFwrite_dict(FILEHANDLE);
##
sub main'MIFwrite_dict {
    local($handle, $l) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, 'Dictionary', "\n";
    foreach (sort keys %OKWord) {
	print $handle $i2, $mso, 'OKWord ', $stb, $_, $ste, $msc, "\n"
	    if $_;
    }
    print $handle $i0, $msc, " $como end of Dictionary\n";
}
##---------------------------------------------------------------------------##
##	MIFget_dict_words() returns a sorted array of all words defined
##	in the dictionary.
##
##	Usage:
##	    @words = &'MIFget_dict_words();
##
sub main'MIFget_dict_words {
    return sort keys %OKWord;
}
##---------------------------------------------------------------------------##
##	MIFreset_dict() resets the associative arrays for the dictionary.
##
##	Usage:
##	    &'MIFreset_dict();
##
sub main'MIFreset_dict {
    undef %OKWord;
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the read_mif() routine.  There purpose is to	     ##
##	store the information contained in the dictionary.		     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
##	Dictionary() is the token routine for 'Dictionary'.
##	It sets/restores token routines depending upon mode.
##
sub mif'Dictionary {
    local($token, $mode, *data) = @_;
    if ($mode == $MOpen) {
	($_fast, $_noidata) = ($mif'fast, $mif'no_import_data);
	($mif'fast, $mif'no_import_data) = (1, 1);
	@_orgfunc = @mif'MIFToken{
				'OKWord'
			};
	@mif'MIFToken{
		'OKWord'
	} = (
		"mif_dict'OKWord"
	);
    } elsif ($mode == $MClose) {
	@mif'MIFToken{
		'OKWord'
	} = @_orgfunc;
	($mif'fast, $mif'no_import_data) = ($_fast, $_noidata);
    }
}
##---------------------------------------------------------------------------
sub OKWord {
    local($token, $mode, *data) = @_;
    $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
    $OKWord{$1} = 1;
}
##---------------------------------------------------------------------------
1;
