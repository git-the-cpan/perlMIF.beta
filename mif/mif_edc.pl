##---------------------------------------------------------------------------##
##  File:
##      mif_edc.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_edc" perl package.  It defines routines
##	to handle the ElementDefCatalog via MIFread_mif() defined in the
##	"mif" package.
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

package mif_edc;

$VERSION = "1.0.0";

##-------------------------------------------------##
## Add Element Catalog function to %MIFToken array ##
##-------------------------------------------------##
$mif'MIFToken{'ElementDefCatalog'} = 'ElementDefCatalog';

##------------------------------------##
## Element Catalog Associative Arrays ##
##------------------------------------##
%EDComments	= ();	# Comments
%EDObject	= ();	# Formatter object represented by the element
%EDHighLevel	= ();	# Can element be highest element in flow
%EDGenRule	= ();	# Content rules
%EDInclusions	= ();	# Included elements (Separated by $edc_or)
%EDExclusions	= ();	# Excluded elements (Separated by $edc_or)
%EDFmtRules	= ();	# Formatting properties (Stored MIF)


$edc_sep	= ',';
$edc_sep_e	= ',';
$edc_seq	= ',';
$edc_seq_e	= ',';
$edc_or		= '|';
$edc_or_e	= '\|';
$edc_and	= '&';
$edc_and_e	= '&';

$edc_grpo	= '(';
$edc_grpo_e	= '\(';
$edc_grpc	= ')';
$edc_grpc_e	= '\)';

$edc_plus	= '+';
$edc_plus_e	= '\+';
$edc_opt	= '?';
$edc_opt_e	= '\?';
$edc_rep	= '*';
$edc_rep_e	= '\*';

$MStore		= $mif'MStore;
$MOpen		= $mif'MOpen;
$MClose		= $mif'MClose;
$MLine		= $mif'MLine;
$mso		= $mif'mso;
$msc		= $mif'msc;
$stb		= $mif'stb;
$ste		= $mif'ste;
$como		= $mif'como;

$elem_keywords	= '<ANY\\\?>|<TEXT\\\?>|<TEXTONLY\\\?>';
$elem_spchars	= "$edc_seq_e$edc_or_e$edc_and_e$edc_grpo_e$edc_grpc_e".
		  "$edc_plus_e$edc_opt_e$edc_rep_e$mso$msc".
		  '\[\]%';
$model_chars	= "$edc_seq_e$edc_or_e$edc_and_e$edc_grpo_e$edc_grpc_e".
		  "$edc_plus_e$edc_opt_e$edc_rep_e";
$grp_chars	= "$edc_grpo_e$edc_grpc_e";
$oi_chars	= "$edc_plus_e$edc_opt_e$edc_rep_e";

%EmptyRule = (
    'EDAFrame', 1,
    'EDContainer', 0,
    'EDEmpty', 1,
    'EDEmptyPgf', 1,
    'EDEquation', 0,
    'EDImportedObject', 0,
    'EDMarker', 1,
    'EDTable', 1,
    'EDVariable', 1,
    'EDXRef', 1,
);

##------------------------------------------##
## Variables for current element definition ##
##------------------------------------------##
$edc_Com	= "";
$edc_FRules	= "";
$edc_GRule	= "";
$edc_High	= "";
$edc_Object	= "";
$edc_Tag	= "";
@edc_Exc	= ();
@edc_Inc	= ();

##---------------------------------------------------------------------------##
			    ##---------------##
			    ## Main Routines ##
			    ##---------------##
##---------------------------------------------------------------------------
##	MIFwrite_edc() outputs the element catalog in MIF as defined by the
##	above associative array.
##
##	Usage:
##	    &'MIFwrite_edc(FILEHANDLE);
##
sub main'MIFwrite_edc {
    local($handle, $l) = @_;
    local(@array);
    local($i0, $i1, $i2, $i3) =
	(" " x $l, " " x (1+$l), " " x (2+$l), " " x (3+$l));

    print $handle $i0, $mso, "ElementDefCatalog\n";
    foreach (sort keys %EDObject) {
	print $handle $i1, $mso, "ElementDef\n";
	print $handle $i2, $mso, "EDTag ", $stb, $_, $ste, $msc, "\n";
	print $handle $i2, $mso, "EDObject ", $EDObject{$_}, $msc, "\n";
	print $handle $i2, $mso, "EDValidHighestLevel ", $EDHighLevel{$_},
			   $msc, "\n";
	print $handle $i2, $mso, "EDGeneralRule ", $stb, $EDGenRule{$_}, $ste,
			   $msc, "\n" if $EDGenRule{$_};

	@array = split(/$edc_or_e/, $EDExclusions{$_});
	if ($#array >= 0) {
	    print $handle $i2, $mso, "EDExclusions\n";
	    foreach (@array) {
		print $handle $i3, $mso, "Exclusion ",
				   $stb, $_, $ste, $msc, "\n";
	    }
	    print $handle $i2, $msc, " $como end of EDExclusions\n";
	}
	@array = split(/$edc_or_e/, $EDInclusions{$_});
	if ($#array >= 0) {
	    print $handle $i2, $mso, "EDInclusions\n";
	    foreach (@array) {
		print $handle $i3, $mso, "Inclusion ",
				   $stb, $_, $ste, $msc, "\n";
	    }
	    print $handle $i2, $msc, " $como end of EDInclusions\n";
	}
	print $handle $EDFmtRules{$_};
	print $handle $i1, $msc, " $como end of ElementDef\n";
    }
    print $handle " " x $l, $msc, " $como end of ElementDefCatalog\n";
}
##---------------------------------------------------------------------------##
##	MIFget_element_data() gets the data of the Frame element $element.
##
##	Usage:
##	    ($comments, $object, $highest, $genrule, $inc, $exc) =
##		&'MIFget_element_data($element);
##
##	Note: $inc and $exc is a string of element names separated by
##	      the '|' character.
##
sub main'MIFget_element_data {
    local($element) = @_;
    ($EDComments{$element},
     $EDObject{$element},
     $EDHighLevel{$element},
     $EDGenRule{$element},
     $EDInclusions{$element},
     $EDExclusions{$element});
}
##---------------------------------------------------------------------------##
##	MIFget_elements() returns a sorted array of element names defined
##	in the element catalog.
##
##	Usage:
##	    @elements = &'MIFget_elements();
##
sub main'MIFget_elements {
    return sort keys %EDObject;
}
##---------------------------------------------------------------------------##
##	MIFget_top_elements() retrieves the top-most elements in the
##	element catalog.
##
sub main'MIFget_top_elements {
    &compute_parents() unless defined(%Parents);
    return sort keys %TopElement;
}
##---------------------------------------------------------------------------##
##	MIFget_parents() returns an array of elements that can be parent
##	elements of $elem.
##
sub main'MIFget_parents {
    local($elem) = shift;
    &compute_parents() unless defined(%Parents);
    return sort split(/$edc_sep_e/o, $Parents{$elem});
}
##---------------------------------------------------------------------------##
##      MIFget_gen_children() returns an array of the elements in
##      the general rule of $elem.
##
##      The $andcon is flag if the connector characters are included
##      in the array. (NULL or whitespace strings may be in returned array).
##
sub main'MIFget_gen_children {
    local($elem, $andcon) = @_;
    return &extract_elem_names($EDGenRule{$elem}, $andcon);
}
##---------------------------------------------------------------------------##
##      MIFget_inc_children() returns an array of the elements in
##      the inclusion group.
##
sub main'MIFget_inc_children {
    local($elem, $andcon) = @_;
    return &extract_elem_names($EDInclusions{$elem}, $andcon);
}
##---------------------------------------------------------------------------##
##      MIFget_exc_children() returns an array of the elements in
##      the exclusion group.
##
sub main'MIFget_exc_children {
    local($elem, $andcon) = @_;
    return &extract_elem_names($EDExclusions{$elem}, $andcon);
}
##---------------------------------------------------------------------------##
##      MIFis_elem_keyword() returns 1 if $word is an MIF reserved word
##      used in an element content rule.
##
sub main'MIFis_elem_keyword {
    local($word) = shift;
    ($word =~ /^\s*($elem_keywords)\s*$/oi ? 1 : 0);
}
##---------------------------------------------------------------------------##
##	MIFis_elem_high() returns 1 if $elem can be the highest element
##	in a Frame document.
##
sub main'MIFis_elem_high {
    local($elem) = shift;
    ($EDHighLevel{$elem} =~ /^\s*yes\s*/i ? 1 : 0);
}
##---------------------------------------------------------------------------##
##	MIFis_elem_empty_rule() returns 1 if $elem has an empty general
##	rule.
##
sub main'MIFis_elem_empty_rule {
    local($elem) = shift;
    local($type) = ($EDObject{$elem});
    $type =~ s/^\s*(.*[^\s])\s*$/\1/;
    ($EmptyRule{$type} ? 1 : 0);
}
##---------------------------------------------------------------------------##
##	MIFis_occur_indicator() returns 1 if $str is an occurance
##	indicator.
##
sub main'MIFis_occur_indicator {
    local($str) = shift;
    ($str =~ /^\s*[$edc_plus_e$edc_opt_e$edc_rep_e]\s*$/oi ? 1 : 0);
}
##---------------------------------------------------------------------------
##	MIFis_group_connector() returns 1 if $str is a group connector
##
sub main'MIFis_group_connector {
    local($str) = shift;
    ($str =~ /^\s*[$edc_seq_e$edc_and_e$edc_or_e]\s*$/oi ? 1 : 0);
}
##---------------------------------------------------------------------------##
##	MIFis_elem_name() returns 1 if $str is a legal element name.
##
sub main'MIFis_elem_name {
    local($str) = shift;
    ($str !~ /^\s*[$elem_spchars]\s*$/oi ? 1 : 0);
}
##---------------------------------------------------------------------------##
##      MIFreset_edc() resets the associative arrays for the element
##      catalog.
##
##      Usage:
##          &'MIFreset_edc();
##
sub main'MIFreset_edc {
    undef %EDComments;
    undef %EDObject;
    undef %EDHighLevel;
    undef %EDGenRule;
    undef %EDInclusions;
    undef %EDExclusions;
    undef %EDFmtRules;
    undef %Parents;
    undef %TopElement;
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------
##      compute_parents() generates the %Parents and %TopElement arrays.
##
sub compute_parents {
    local($elem, %exec);

    foreach $elem (&'MIFget_elements()) {
        foreach (&extract_elem_names($EDExclusions{$elem})) { $exc{$_} = 1; }
        foreach (&extract_elem_names($EDGenRule{$elem})) {
            $Parents{$_} .= ($Parents{$_} ? $edc_sep : '') . $elem
                unless $exc{$_} || &'MIFis_elem_keyword($_);
        }
        foreach (&extract_elem_names($EDInclusions{$elem})) {
            $Parents{$_} .= ($Parents{$_} ? $edc_sep : '') . $elem
                unless $exc{$_} || &'MIFis_elem_keyword($_);
        }
        undef %exc;
    }
    foreach (keys %EDGenRule) {
        $TopElement{$_} = 1 if !$Parents{$_} || $Parents{$_} eq $_;
    }

    # foreach (sort keys %Parents) {
	# print STDERR $_ , "\n",
		     # "\t", $Parents{$_}, "\n";
    # }
}
##---------------------------------------------------------------------------##
##      extract_elem_names() extracts just the element names of $str.
##      An array is returned.  The elements in $str are assumed to be
##      separated by connectors.
##
##      The $andcon is flag if the connector characters are included
##      in the array.
##
sub extract_elem_names {
    local($str, $andcon) = @_;
    local(@array);
    if ($andcon) {
        @array = split(/([$model_chars])/o, $str);
    }
    else {
        $str =~ s/[$grp_chars$oi_chars]//go;
        @array = split(/[$edc_seq_e$edc_and_e$edc_or_e]/o, $str);
    }
    grep(s/^\s*(.*[^\s])\s*$/\1/, @array);
    @array;
}
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the read_mif() routine.  There purpose is to	     ##
##	store the information contained in the element catalog.		     ##
##---------------------------------------------------------------------------##
##---------------------------------------------------------------------------
sub EDComments {
    local($token, $mode, *data) = @_;
    ($edc_Com) = $data =~ /^\s*$stb([^$ste]*)$ste\s*$/o;
}
##---------------------------------------------------------------------------
sub Exclusion {
    local($token, $mode, *data) = @_;
    local($tmp) = $data =~ /^\s*$stb([^$ste]*)$ste\s*$/o;
    push(@edc_Exc, $tmp);
}
##---------------------------------------------------------------------------
sub EDExclusions {
    local($token, $mode, *data) = @_;
}
##---------------------------------------------------------------------------
sub EDFormatRules {
    local($token, $mode, *data) = @_;
    if ($mode == $MClose) {
	$edc_FRules = $data;
	$edc_FRules .= "\n" unless $data =~ /\s*\n$/;
    }
}
##---------------------------------------------------------------------------
sub EDGeneralRule {
    local($token, $mode, *data) = @_;
    ($edc_GRule) = $data =~ /^\s*$stb([^$ste]*)$ste\s*$/o;
}
##---------------------------------------------------------------------------
sub Inclusion {
    local($token, $mode, *data) = @_;
    local($tmp) = $data =~ /^\s*$stb([^$ste]*)$ste\s*$/o;
    push(@edc_Inc, $tmp);
}
##---------------------------------------------------------------------------
sub EDInclusions {
    local($token, $mode, *data) = @_;
}
##---------------------------------------------------------------------------
sub EDObject {
    local($token, $mode, *data) = @_;
    ($edc_Object) = $data =~ /^\s*(\S*)/;
}
##---------------------------------------------------------------------------
sub EDTag {
    local($token, $mode, *data) = @_;
    ($edc_Tag) = $data =~ /^\s*$stb([^$ste]*)$ste\s*$/o;
}
##---------------------------------------------------------------------------
sub EDValidHighestLevel {
    local($token, $mode, *data) = @_;
    ($edc_High) = $data =~ /^\s*(\S*)/;
}
##---------------------------------------------------------------------------
sub ElementDef {
    local($token, $mode, *data) = @_;
    if ($mode == $MOpen) {
	$edc_Com = "";
	$edc_FRules = "";
	$edc_GRule = "";
	$edc_High = "";
	$edc_Object = "";
	$edc_Tag = "";
	@edc_Exc = ();
	@edc_Inc = ();
    } elsif ($mode == $MClose) {
	$EDComment{$edc_Tag} = $edc_Com;
	$EDObject{$edc_Tag} = $edc_Object;
	$EDHighLevel{$edc_Tag} = $edc_High;
	$EDGenRule{$edc_Tag} = $edc_GRule;
	$EDInclusions{$edc_Tag} = join($edc_or, @edc_Inc);
	$EDExclusions{$edc_Tag} = join($edc_or, @edc_Exc);
	$EDFmtRules{$edc_Tag} = $edc_FRules;
    } else {
	warn "Unexpected mode, $mode, passed to ElementDef function\n";
    }
}
##---------------------------------------------------------------------------
##	ElementDefCatalog() is the token function for "ElementDefCatalog".
##	It sets/restores token functions depending upon mode.
##
sub mif'ElementDefCatalog {
    local($token, $mode, *data) = @_;
    if ($mode == $MOpen) {
	($_fast, $_noidata) = ($mif'fast, $mif'no_import_data);
	($mif'fast, $mif'no_import_data) = (1, 1);
	@_ed_orgfunc = @mif'MIFToken{
			    'EDComments',
			    'Exclusion',
			    'EDExclusions',
			    'EDFormatRules',
			    'EDGeneralRule',
			    'Inclusion',
			    'EDInclusions',
			    'EDObject',
			    'EDTag',
			    'EDValidHighestLevel',
			    'ElementDef'
		        };
	@mif'MIFToken{
	    'EDComments',
	    'Exclusion',
	    'EDExclusions',
	    'EDFormatRules',
	    'EDGeneralRule',
	    'Inclusion',
	    'EDInclusions',
	    'EDObject',
	    'EDTag',
	    'EDValidHighestLevel',
	    'ElementDef'
	} = (
	    "mif_edc'EDComments",
	    "mif_edc'Exclusion",
	    "mif_edc'EDExclusions",
	    "$MStore,mif_edc'EDFormatRules",
	    "mif_edc'EDGeneralRule",
	    "mif_edc'Inclusion",
	    "mif_edc'EDInclusions",
	    "mif_edc'EDObject",
	    "mif_edc'EDTag",
	    "mif_edc'EDValidHighestLevel",
	    "mif_edc'ElementDef"
	);
    } elsif ($mode == $MClose) {
	@mif'MIFToken{
	    'EDComments',
	    'Exclusion',
	    'EDExclusions',
	    'EDFormatRules',
	    'EDGeneralRule',
	    'Inclusion',
	    'EDInclusions',
	    'EDObject',
	    'EDTag',
	    'EDValidHighestLevel',
	    'ElementDef'
	} = @_ed_orgfunc;
        ($mif'fast, $mif'no_import_data) = ($_fast, $_noidata);
    }
}
##---------------------------------------------------------------------------
1;
