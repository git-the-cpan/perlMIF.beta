##---------------------------------------------------------------------------##
##  File:
##      mif.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##      This file defines the "mif" perl package.  This file defines the
##	core routine "MIFread_mif()" to parse Frame MIF, and base routines
##	for outputing MIF.
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

package mif;

$VERSION = "1.0.0";

##-------------------##
## Markup characters ##
##-------------------##
$mso	= '<';		# Markup statement open
$msc	= '>';		# Markup statement close
$stb	= '`';		# Mif string begin
$ste	= "'";		# Mif string end
$como	= '#';		# End-of-line comment open
$ido	= '=';		# Import data opener
$idlo	= '&';		# Import data line begin chars
$idcstr	= '=EndInset';	# Import data close

##----------------------##
## read_mif() variables ##
##----------------------##
@OpenTokens = ();	# Stack of current open tokens

$MClose	= -1;		# Variable constants used as 2nd argument
$MLine	=  0;		#	to token functions.
$MOpen	=  1;		#	...

$fast = 0;		# Flag if comments are skipped and not stripped
$no_import_data = 0;	# Flag if import data should be checked

$rm_Ignore = 0;		# Determines if current statement is ignored
$rm_Store = 0;		# Determines if current statement will be stored

$func =			# Calling token function
$stline =		# Stored MIF if in store mode
$stfunc =		# Store token function in store mode
$carry =		# Carry over text to help preserve formatting
$token = "";		# MIF token

##----------------------------------------------------##
## Associative array mapping token names to functions ##
##----------------------------------------------------##
%MIFToken = ();
$MStore	= 'STORE';	# Special map value to tell MIFread_mif() to store
			# MIF text unprocessed.

$MImportData = 'import_data';
			# Name of token for imported data.

##---------------------------------------------------------------------------##
##	MIFread_mif() reads MIF from filehandle $handle.
##
sub main'MIFread_mif {
    local($handle) = @_;
    local($line, $tmp);
    local($old) = select($handle);

    while (!eof($handle)) {
	#--------------#
	# Get next '<' #
	#--------------#
	$/ = $mso;  $line = <$handle>;
	&delete_comments(*line) unless $fast;
	GETMSO: while (1) {
	    if (eof($handle)) {				# Break if EOF
		$line .= "\n";
		last GETMSO;
	    } elsif ($line !~ /$mso$/o) {		# MSO in comment
		$/ = "\n";  <$handle>;  $/ = $mso;
		$line .= "\n";
		next GETMSO;
	    } elsif ($line =~ /\n$idlo.*$mso$/o) {	# Import data
		next GETMSO;
	    } else {
		last GETMSO;
	    }
	} continue {
	    $tmp = <$handle>;
	    &delete_comments(*tmp) unless $fast;
	    $line .= $tmp;
	}
	&check_importdata(*line, 'check_closures')
	    if !$no_import_data && $OpenTokens[$#OpenTokens] eq 'ImportObject';
	$carry = $line;
	&check_closures(*line);
	last if eof($handle);

	#--------------#
	# Get next '>' #
	#--------------#
	$/ = $msc;  $line = <$handle>;
	&delete_comments(*line) unless $fast;
	GETMSC: while (1) {
	    if ($line !~ /$msc$/o) {		  	# MSC in comment
		$/ = "\n";  <$handle>;  $/ = $msc;
		$line .= "\n";
		next GETMSC;
	    } elsif ($line =~ /\\$msc$/o ||		# Escaped MSC
		     $line =~ /\n$idlo.*$msc$/o) {	# Import data
		next GETMSC;
	    } else {
		last GETMSC;
	    }
	} continue {
	    $tmp = <$handle>;
	    &delete_comments(*tmp) unless $fast;
	    $line .= $tmp;
	}
	&check_importdata(*line, 'check_opens') unless $no_import_data;
	&check_opens(*line);

	#------------------------------------------------------------#
	# At this point, there is only a statement with non-MIF data #
	#------------------------------------------------------------#
	if ($rm_Store) {
	    $stline .= $carry . $line;
	} elsif (!$rm_Ignore) {
	    chop $line;			# Discard '>'
	    $line =~ s/^\s*(\S+)\s*//;	# Get token
	    $token = $1;
	    if ($func = $MIFToken{$token}) {
		($func) = (split(/[,\s]+/, $func))[1] if $func =~ /^$MStore/o;
		&$func($token, $MLine, *line) if $func;
	    }
	}
    }
    $/ = "\n";
    select($old);
}
##---------------------------------------------------------------------------##
##	check_closures() checks for any closures in *line.
##
sub check_closures {
    local(*line) = @_;
    local($tmp);

    while ($line =~ s/^([^$msc]*$msc)//o) {
	$tmp = $1;
	$token = pop(@OpenTokens);	# Pop token off stack
	die "Unexpected token closure, Empty Stack ($token):\n",
	    "$tmp$line\n"
	    unless $token;

	## See what to do depending on mode ##
	if ($rm_Store) {	# Store mode
	    $stline .= $tmp;		# Append $tmp to stored text
	    $rm_Store--;		# Decrement counter
	    if (!$rm_Store) {		# Store token closed
		$line =~ s/^([^$msc$mso\n]*\n?)//o; 	# Grab 'til end-of-line
		$stline .= $1;			    	# Append it.
		&$stfunc($token, $MClose, *stline); 	# Call store function
		$stline = "";			    	# Reset store text
	    } else {
		$carry = $line;
	    }
	} elsif (!$rm_Ignore && $MIFToken{$token}) {
	    $func = $MIFToken{$token};
	    &$func($token, $MClose)
		unless $func =~ /^$MStore/o;
	} else {
	    $rm_Ignore-- if $rm_Ignore;
	}
    }
}
##---------------------------------------------------------------------------##
##	check_opens() checks for any opening tokens in *line.
##
sub check_opens {
    local(*line) = @_;
    local($tmp);
 
    while ($line =~ s/^([^$stb$mso]*$mso)//o) {
	$tmp = $1;
	if ($tmp =~ /^\s*([^$mso\s]+)/o) {
	    $token = $1;
	} else {		# Just whitespace
	    if ($rm_Store) {
		$stline .= $carry . $tmp;
		$carry = "";
	    }
	    next;		# Continue at top of loop
	}
	push(@OpenTokens, $token);

	## See what to do depending on mode ##
	if ($rm_Store) {
	    $stline .= $carry . $tmp;
	    $carry = "";
	    $rm_Store++;
	} elsif (!$rm_Ignore && ($func = $MIFToken{$token})) {
	    if ($func =~ /^$MStore/o) {
		($stfunc) = (split(/[,\s]+/, $func))[1];
		$rm_Store++;
		($carry) = $carry =~ /([ \t\r\f]*$mso)$/o;
		$stline = $carry . $tmp;
		$carry = "";
	    } else {
		&$func($token, $MOpen);
	    }
	} else {
	    $rm_Ignore++;
	}
    }
}
##---------------------------------------------------------------------------##
##	check_importdata() determines if there exists in imported data
##	in the string *line.  If there is, the function specified by
##	%MIFToken{$MImportData} is called if it is defined.
##
sub check_importdata {
    local(*line, $chkfunc) = @_;

    if ($line =~ /\n$ido/o) {
	local($prev, $data);
	do {
	    $line =~ s/^([^$ido]*$ido)//o;
	    $prev .= $1;
	} while ($prev !~ /\n$ido$/o);
	$data = chop $prev;
	$line =~ s/^([^\000]*\n\s*$idcstr)//o;
	$data .= $1;

	&$chkfunc(*prev);
	if ($chkfunc eq 'check_opens' && $prev =~ /^\s*(\S+)\s*$/) {
	    $token = $1;
	    push(@OpenTokens, $token);
	    if ($rm_Store) {
		$stline .= $carry . $prev;
		$prev = "";  $carry = "";
		$rm_Store++;
	    } elsif (!$rm_Ignore && ($func = $MIFToken{$token})) {
		if ($func =~ /^$MStore/o) {
		    ($stfunc) = (split(/[,\s]+/, $func))[1];
		    $rm_Store++;
		    ($carry) = $carry =~ /([ \t\r\f]*$mso)$/o;
		    $stline = $carry . $prev;
		    $carry = "";  $prev = "";
		} else {
		    &$func($token, $MOpen);
		}
	    } else {
		$rm_Ignore++;
	    }
	}

	if ($rm_Store) {
	    $stline .= $prev . $data;
	} elsif (!$rm_Ignore && ($func = $MIFToken{$MImportData})) {
	    &$func($MImportData, $MLine, *data);
	}
    }
}
##---------------------------------------------------------------------------##
##	delete_comments() removes any end-of-line comments.  Care must be
##	taken when the $como character appears in strings and when there
##	is import data.
##
sub delete_comments {
    local(*txt) = @_;
    local(@array) = split(/\n/, $txt);

    foreach (@array) {
	next if $_ !~ /$como/o ||	# Continue if no '#'
		/^\s*$idlo/o ||		# Ignore import data
		s/^\s*$como.*$//o;	# Comment line

	s/^([^$stb]*)$como.*$/\1/o;
	s/^([^$ste]*$ste[^$como]*)$como.*$/\1/o;
    }
    $txt = join("\n", @array);
}
##---------------------------------------------------------------------------##

###############################################################################
## 			  CORE MIF OUTPUT ROUTINES			     ##
###############################################################################

##---------------------------------------------------------------------------
sub main'MIFwrite_open {
    local($handle, $token, $indent) = @_;
    local($i0) = (' ' x $indent);
    print $handle $i0, $mso, $token, "\n";
}
##---------------------------------------------------------------------------
sub main'MIFwrite_close {
    local($handle, $indent) = @_;
    local($i0) = (' ' x $indent);
    print $handle $i0, $msc, "\n";
}
##---------------------------------------------------------------------------
sub main'MIFwrite_statment {
    local($handle, $token, $data, $indent) = @_;
    local($i0) = (' ' x $indent);
    print $handle $i0, $mso, $token, ' ', $data, $msc, "\n";
}
##---------------------------------------------------------------------------
sub main'MIFwrite_str_statment {
    local($handle, $token, $data, $indent) = @_;
    local($i0) = (' ' x $indent);
    print $handle $i0, $mso, $token, ' ', $stb, $data, $ste, $msc, "\n";
}
##---------------------------------------------------------------------------
##	MIFescape_string() converts certain characters in string *str to
##	Frame backslash sequences.
##
sub main'MIFescape_string {
    local(*str) = shift;
    $str = s/\\/\\\\/g;
    $str = s/\t/\\t/g;
    $str = s/>/\\>/g;
    $str = s/'/\\q/g;
    $str = s/`/\\Q/g;
}
##---------------------------------------------------------------------------##

1;
