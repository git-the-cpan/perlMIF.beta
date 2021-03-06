##---------------------------------------------------------------------------##
##  File:
##      mif_id.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_id" perl package.  It defines
##	routines to handle the MIFFile statement via MIFread_mif() defined in
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

package mif_id;

##-------------------------------------------------##
## Add Units function to %MIFToken array ##
##-------------------------------------------------##
$mif'MIFToken{'MIFFile'} = 'MIFFile';

##----------------------------------------##
## Variable that stores the defaule units ##
##----------------------------------------##
$rel = '4.00';

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
##---------------------------------------------------------------------------##
##      MIFwrite_mif_id() outputs the <MIFFile> statement to $handle.
##      $release is the release number (defaults to $rel), and
##      $comment is the end-of-line comment (defaults to "Generated
##      by mif.pl") without the begining '#' character.
##
sub main'MIFwrite_mif_id {
    local($handle, $release, $comment) = @_;

    $release = $rel unless $release;
    $comment = "Generated by mif.pl" unless $comment;
    $comment =~ s/\n/ /g;
    print $handle $mso, 'MIFFile ', $release, $msc, " $como ", $comment, "\n";
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the read_mif() routine.  There purpose is to	     ##
##	store the information contained in the MIFFile statement.	     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
sub mif'MIFFile {
    local($token, $mode, *data) = @_;
    if ($data !~ /^\s*$/) {
	($rel) = $data =~ /^\s*(\S*)/o;
    }
}
##---------------------------------------------------------------------------
1;
