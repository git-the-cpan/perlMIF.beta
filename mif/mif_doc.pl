##---------------------------------------------------------------------------##
##  File:
##      mif_doc.pl
##  Author:
##      Earl Hood       ehood@convex.com
##  Description:
##	This file is defines the "mif_doc" perl package.  It defines
##	routines to handle the Document via MIFread_mif() defined in
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
##---------------------------------------------------------------------------##
##  Status:
##	o DMathCatalog is ignored.
##---------------------------------------------------------------------------##

require 'mif/mif.pl' || die "Unable to require mif.pl\n";

package mif_doc;

##------------------------------------------##
## Add Document function to %MIFToken array ##
##------------------------------------------##
$mif'MIFToken{'Document'} = 'Document';
$mif'MIFToken{'DNextUnique'} = "mif_doc'data_token";
$mif'MIFToken{'DViewRect'} = "mif_doc'data_token";
$mif'MIFToken{'DWindowRect'} = "mif_doc'data_token";
$mif'MIFToken{'DViewScale'} = "mif_doc'data_token";
$mif'MIFToken{'DMargins'} = "mif_doc'data_token";
$mif'MIFToken{'DColumns'} = "mif_doc'data_token";
$mif'MIFToken{'DColumnGap'} = "mif_doc'data_token";
$mif'MIFToken{'DPageSize'} = "mif_doc'data_token";
$mif'MIFToken{'DStartPage'} = "mif_doc'data_token";
$mif'MIFToken{'DPageNumStyle'} = "mif_doc'data_token";
$mif'MIFToken{'DPagePointStyle'} = "mif_doc'data_token";
$mif'MIFToken{'DTwoSides'} = "mif_doc'data_token";
$mif'MIFToken{'DParity'} = "mif_doc'data_token";
$mif'MIFToken{'DFrozenPages'} = "mif_doc'data_token";
$mif'MIFToken{'DPageRounding'} = "mif_doc'data_token";
$mif'MIFToken{'DMaxInterLine'} = "mif_doc'data_token";
$mif'MIFToken{'DMaxInterPgf'} = "mif_doc'data_token";
$mif'MIFToken{'DFNoteMaxH'} = "mif_doc'data_token";
$mif'MIFToken{'FNoteStartNum'} = "mif_doc'data_token";
$mif'MIFToken{'DFNoteRestart'} = "mif_doc'data_token";
$mif'MIFToken{'DFNoteTag'} = "mif_doc'string_token";
$mif'MIFToken{'DFNoteLabels'} = "mif_doc'string_token";
$mif'MIFToken{'DFNoteNumStyle'} = "mif_doc'data_token";
$mif'MIFToken{'DFNoteAnchorPos'} = "mif_doc'data_token";
$mif'MIFToken{'DFNoteNumberPos'} = "mif_doc'data_token";
$mif'MIFToken{'DFNoteAnchorPrefix'} = "mif_doc'string_token";
$mif'MIFToken{'DFNoteAnchorSuffix'} = "mif_doc'string_token";
$mif'MIFToken{'DFNoteNumberPrefix'} = "mif_doc'string_token";
$mif'MIFToken{'DFNoteNumberSuffix'} = "mif_doc'string_token";
$mif'MIFToken{'DTblFNoteTag'} = "mif_doc'string_token";
$mif'MIFToken{'DTblFNoteLabels'} = "mif_doc'string_token";
$mif'MIFToken{'DTblFNoteNumStyle'} = "mif_doc'data_token";
$mif'MIFToken{'DTblFNoteAnchorPos'} = "mif_doc'data_token";
$mif'MIFToken{'DTblFNoteNumberPos'} = "mif_doc'data_token";
$mif'MIFToken{'DTblFNoteAnchorPrefix'} = "mif_doc'string_token";
$mif'MIFToken{'DTblFNoteAnchorSuffix'} = "mif_doc'string_token";
$mif'MIFToken{'DTblFNoteNumberPrefix'} = "mif_doc'string_token";
$mif'MIFToken{'DTblFNoteNumberSuffix'} = "mif_doc'string_token";
$mif'MIFToken{'DLinebreakChars'} = "mif_doc'string_token";
$mif'MIFToken{'DPunctuationChars'} = "mif_doc'string_token";
$mif'MIFToken{'DChBarGap'} = "mif_doc'data_token";
$mif'MIFToken{'DChBarWidth'} = "mif_doc'data_token";
$mif'MIFToken{'DChBarPosition'} = "mif_doc'data_token";
$mif'MIFToken{'DChBarColor'} = "mif_doc'string_token";
$mif'MIFToken{'DAutoChBars'} = "mif_doc'data_token";
$mif'MIFToken{'DShowAllConditions'} = "mif_doc'data_token";
$mif'MIFToken{'DDisplayOverrides'} = "mif_doc'data_token";
$mif'MIFToken{'DViewOnly'} = "mif_doc'data_token";
$mif'MIFToken{'DViewOnlyXRef'} = "mif_doc'data_token";
$mif'MIFToken{'DViewOnlySelect'} = "mif_doc'data_token";
$mif'MIFToken{'DViewOnlyNoOp'} = "mif_doc'data_token";
$mif'MIFToken{'DViewOnlyWinBorders'} = "mif_doc'data_token";
$mif'MIFToken{'DViewOnlyWinMenubar'} = "mif_doc'data_token";
$mif'MIFToken{'DViewOnlyWinPopup'} = "mif_doc'data_token";
$mif'MIFToken{'DViewOnlyWinPalette'} = "mif_doc'data_token";
$mif'MIFToken{'DGridOn'} = "mif_doc'data_token";
$mif'MIFToken{'DPageGrid'} = "mif_doc'data_token";
$mif'MIFToken{'DSnapGrid'} = "mif_doc'data_token";
$mif'MIFToken{'DSnapRotation'} = "mif_doc'data_token";
$mif'MIFToken{'DRulersOn'} = "mif_doc'data_token";
$mif'MIFToken{'DFullRulers'} = "mif_doc'data_token";
$mif'MIFToken{'DGraphicsOff'} = "mif_doc'data_token";
$mif'MIFToken{'DCurrentView'} = "mif_doc'data_token";
$mif'MIFToken{'DBordersOn'} = "mif_doc'data_token";
$mif'MIFToken{'DSymbolsOn'} = "mif_doc'data_token";
$mif'MIFToken{'DSmartQuotesOn'} = "mif_doc'data_token";
$mif'MIFToken{'DSmartSpacesOn'} = "mif_doc'data_token";
$mif'MIFToken{'DLanguage'} = "mif_doc'data_token";
$mif'MIFToken{'DSuperscriptSize'} = "mif_doc'data_token";
$mif'MIFToken{'DSubscriptSize'} = "mif_doc'data_token";
$mif'MIFToken{'DSmallCapsSize'} = "mif_doc'data_token";
$mif'MIFToken{'DSuperscriptShift'} = "mif_doc'data_token";
$mif'MIFToken{'DSubscriptShift'} = "mif_doc'data_token";
$mif'MIFToken{'DMathAlphaCharFontFamily'} = "mif_doc'string_token";
$mif'MIFToken{'DMathSmallIntegral'} = "mif_doc'data_token";
$mif'MIFToken{'DMathMediumIntegral'} = "mif_doc'data_token";
$mif'MIFToken{'DMathLargeIntegral'} = "mif_doc'data_token";
$mif'MIFToken{'DMathSmallSigma'} = "mif_doc'data_token";
$mif'MIFToken{'DMathMediumSigma'} = "mif_doc'data_token";
$mif'MIFToken{'DMathLargeSigma'} = "mif_doc'data_token";
$mif'MIFToken{'DMathSmallLevel1'} = "mif_doc'data_token";
$mif'MIFToken{'DMathMediumLevel1'} = "mif_doc'data_token";
$mif'MIFToken{'DMathLargeLevel1'} = "mif_doc'data_token";
$mif'MIFToken{'DMathSmallLevel2'} = "mif_doc'data_token";
$mif'MIFToken{'DMathMediumLevel2'} = "mif_doc'data_token";
$mif'MIFToken{'DMathLargeLevel2'} = "mif_doc'data_token";
$mif'MIFToken{'DMathSmallLevel3'} = "mif_doc'data_token";
$mif'MIFToken{'DMathMediumLevel3'} = "mif_doc'data_token";
$mif'MIFToken{'DMathLargeLevel3'} = "mif_doc'data_token";
$mif'MIFToken{'DMathSmallHoriz'} = "mif_doc'data_token";
$mif'MIFToken{'DMathMediumHoriz'} = "mif_doc'data_token";
$mif'MIFToken{'DMathLargeHoriz'} = "mif_doc'data_token";
$mif'MIFToken{'DMathSmallVert'} = "mif_doc'data_token";
$mif'MIFToken{'DMathMediumVert'} = "mif_doc'data_token";
$mif'MIFToken{'DMathLargeVert'} = "mif_doc'data_token";
$mif'MIFToken{'DMathShowCustom'} = "mif_doc'data_token";
$mif'MIFToken{'DMathFunctions'} = "mif_doc'string_token";
$mif'MIFToken{'DMathNumbers'} = "mif_doc'string_token";
$mif'MIFToken{'DMathVariables'} = "mif_doc'string_token";
$mif'MIFToken{'DMathStrings'} = "mif_doc'string_token";
$mif'MIFToken{'DMathGreek'} = "mif_doc'string_token";
$mif'MIFToken{'DMathCatalog'} = "mif_doc'data_token";
$mif'MIFToken{'DElementCatalogScope'} = "mif_doc'data_token";
$mif'MIFToken{'DElementBordersOn'} = "mif_doc'data_token";
$mif'MIFToken{'DExclusions'} = "mif_doc'data_token";
$mif'MIFToken{'DInclusions'} = "mif_doc'data_token";
$mif'MIFToken{'DApplyFormatRules'} = "mif_doc'data_token";
$mif'MIFToken{'DNoPrintSepColor'} = "mif_doc'string_token";
$mif'MIFToken{'DPrintProcessColor'} = "mif_doc'string_token";
$mif'MIFToken{'DPrintSkipBlankPages'} = "mif_doc'data_token";
$mif'MIFToken{'DPrintSeparations'} = "mif_doc'data_token";

##--------------------##
## Document variables ##
##--------------------##
$DNextUnique		= "";
$DViewRect		= "";
$DWindowRect		= "";
$DViewScale 		= "";
$DMargins		= "";	# Used by filters
$DColumns		= "";	# Used by filters
$DColumnGap		= "";	# Used by filters
$DPageSize		= "";
$DStartPage		= "";
$DPageNumStyle		= "";
$DPagePointStyle	= "";
$DTwoSides		= "";
$DParity		= "";
$DFrozenPages		= "";
$DPageRounding		= "";
$DMaxInterLine		= "";
$DMaxInterPgf		= "";
$DFNoteMaxH		= "";
$FNoteStartNum		= "";
$DFNoteRestart		= "";
$DFNoteTag		= "";
$DFNoteLabels		= "";
$DFNoteNumStyle		= "";
$DFNoteAnchorPos	= "";
$DFNoteNumberPos	= "";
$DFNoteAnchorPrefix	= "";
$DFNoteAnchorSuffix	= "";
$DFNoteNumberPrefix	= "";
$DFNoteNumberSuffix	= "";
$DTblFNoteTag		= "";
$DTblFNoteLabels	= "";
$DTblFNoteNumStyle	= "";
$DTblFNoteAnchorPos	= "";
$DTblFNoteNumberPos	= "";
$DTblFNoteAnchorPrefix	= "";
$DTblFNoteAnchorSuffix	= "";
$DTblFNoteNumberPrefix	= "";
$DTblFNoteNumberSuffix	= "";
$DLinebreakChars	= "";
$DPunctuationChars	= "";
$DChBarGap		= "";
$DChBarWidth		= "";
$DChBarPosition		= "";
$DChBarColor		= "";
$DAutoChBars		= "";
$DShowAllConditions	= "";
$DDisplayOverrides	= "";
$DViewOnly		= "";
$DViewOnlyXRef		= "";
$DViewOnlySelect	= "";
$DViewOnlyNoOp		= "";
$DViewOnlyWinBorders	= "";
$DViewOnlyWinMenubar	= "";
$DViewOnlyWinPopup	= "";
$DViewOnlyWinPalette	= "";
$DGridOn		= "";
$DPageGrid		= "";
$DSnapGrid 		= "";
$DSnapRotation 		= "";
$DRulersOn		= "";
$DFullRulers		= "";
$DGraphicsOff		= "";
$DCurrentView		= "";
$DBordersOn		= "";
$DSymbolsOn		= "";
$DSmartQuotesOn		= "";
$DSmartSpacesOn		= "";
$DLanguage		= "";
$DSuperscriptSize 	= "";
$DSubscriptSize 	= "";
$DSmallCapsSize 	= "";
$DSuperscriptShift 	= "";
$DSubscriptShift 	= "";
$DMathAlphaCharFontFamily = "";
$DMathSmallIntegral	= "";
$DMathMediumIntegral	= "";
$DMathLargeIntegral	= "";
$DMathSmallSigma	= "";
$DMathMediumSigma	= "";
$DMathLargeSigma	= "";
$DMathSmallLevel1	= "";
$DMathMediumLevel1	= "";
$DMathLargeLevel1	= "";
$DMathSmallLevel2	= "";
$DMathMediumLevel2	= "";
$DMathLargeLevel2	= "";
$DMathSmallLevel3	= "";
$DMathMediumLevel3	= "";
$DMathLargeLevel3	= "";
$DMathSmallHoriz	= "";
$DMathMediumHoriz	= "";
$DMathLargeHoriz	= "";
$DMathSmallVert		= "";
$DMathMediumVert	= "";
$DMathLargeVert		= "";
$DMathShowCustom	= "";
$DMathFunctions		= "";
$DMathNumbers		= "";
$DMathVariables		= "";
$DMathStrings		= "";
$DMathGreek		= "";
$DMathCatalog		= "";
$DElementCatalogScope	= "";
$DElementBordersOn	= "";
$DExclusions		= "";
$DInclusions		= "";
$DApplyFormatRules	= "";
$DNoPrintSepColor	= "";
$DPrintProcessColor	= "";
$DPrintSkipBlankPages	= "";
$DPrintSeparations	= "";

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
##	MIFwrite_doc() outputs Document as defined by the variables
##
##	Usage:
##	    &'MIFwrite_doc(FILEHANDLE);
##
sub main'MIFwrite_doc {
    local($handle, $l) = @_;
    local($i0, $i1, $i2) = (' ' x $l, ' ' x (1+$l), ' ' x (2+$l));

    print $handle $i0, $mso, 'Document', "\n";
    print $handle $i1, $mso, 'DViewRect ', $DViewRect, $msc, "\n"
	if $DViewRect ne "";
    print $handle $i1, $mso, 'DWindowRect ', $DWindowRect, $msc, "\n"
	if $DWindowRect ne "";
    print $handle $i1, $mso, 'DViewScale ', $DViewScale, $msc, "\n"
	if $DViewScale ne "";
    print $handle $i1, $mso, 'DMargins ', $DMargins, $msc, "\n"
	if $DMargins ne "";
    print $handle $i1, $mso, 'DColumns ', $DColumns, $msc, "\n"
	if $DColumns ne "";
    print $handle $i1, $mso, 'DColumnGap ', $DColumnGap, $msc, "\n"
	if $DColumnGap ne "";
    print $handle $i1, $mso, 'DPageSize ', $DPageSize, $msc, "\n"
	if $DPageSize ne "";
    print $handle $i1, $mso, 'DStartPage ', $DStartPage, $msc, "\n"
	if $DStartPage ne "";
    print $handle $i1, $mso, 'DPageNumStyle ', $DPageNumStyle, $msc, "\n"
	if $DPageNumStyle ne "";
    print $handle $i1, $mso, 'DPagePointStyle ', $DPagePointStyle, $msc, "\n"
	if $DPagePointStyle ne "";
    print $handle $i1, $mso, 'DTwoSides ', $DTwoSides, $msc, "\n"
	if $DTwoSides ne "";
    print $handle $i1, $mso, 'DParity ', $DParity, $msc, "\n"
	if $DParity ne "";
    print $handle $i1, $mso, 'DFrozenPages ', $DFrozenPages, $msc, "\n"
	if $DFrozenPages ne "";
    print $handle $i1, $mso, 'DPageRounding ', $DPageRounding, $msc, "\n"
	if $DPageRounding ne "";
    print $handle $i1, $mso, 'DMaxInterLine ', $DMaxInterLine, $msc, "\n"
	if $DMaxInterLine ne "";
    print $handle $i1, $mso, 'DMaxInterPgf ', $DMaxInterPgf, $msc, "\n"
	if $DMaxInterPgf ne "";
    print $handle $i1, $mso, 'DFNoteMaxH ', $DFNoteMaxH, $msc, "\n"
	if $DFNoteMaxH ne "";
    print $handle $i1, $mso, 'FNoteStartNum ', $FNoteStartNum, $msc, "\n"
	if $FNoteStartNum ne "";
    print $handle $i1, $mso, 'DFNoteRestart ', $DFNoteRestart, $msc, "\n"
	if $DFNoteRestart ne "";
    print $handle $i1, $mso, 'DFNoteTag ', $stb, $DFNoteTag, $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DFNoteLabels ', $stb, $DFNoteLabels, $ste,
		       $msc, "\n"
	;
    print $handle $i1, $mso, 'DFNoteNumStyle ', $DFNoteNumStyle, $msc, "\n"
	if $DFNoteNumStyle ne "";
    print $handle $i1, $mso, 'DFNoteAnchorPos ', $DFNoteAnchorPos, $msc, "\n"
	if $DFNoteAnchorPos ne "";
    print $handle $i1, $mso, 'DFNoteNumberPos ', $DFNoteNumberPos, $msc, "\n"
	if $DFNoteNumberPos ne "";
    print $handle $i1, $mso, 'DFNoteAnchorPrefix ', $stb, $DFNoteAnchorPrefix, 
		       $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DFNoteAnchorSuffix ', $stb, $DFNoteAnchorSuffix, 
		       $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DFNoteNumberPrefix ', $stb, $DFNoteNumberPrefix, 
		       $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DFNoteNumberSuffix ', $stb, $DFNoteNumberSuffix, 
		       $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DTblFNoteTag ', $stb, $DTblFNoteTag, $ste, 
		       $msc, "\n"
	;
    print $handle $i1, $mso, 'DTblFNoteLabels ', $stb, $DTblFNoteLabels, $ste, 
		       $msc, "\n"
	;
    print $handle $i1, $mso, 'DTblFNoteNumStyle ', $DTblFNoteNumStyle, 
		       $msc, "\n"
	if $DTblFNoteNumStyle ne "";
    print $handle $i1, $mso, 'DTblFNoteAnchorPos ', $DTblFNoteAnchorPos, 
		       $msc, "\n"
	if $DTblFNoteAnchorPos ne "";
    print $handle $i1, $mso, 'DTblFNoteNumberPos ', $DTblFNoteNumberPos, 
		       $msc, "\n"
	if $DTblFNoteNumberPos ne "";
    print $handle $i1, $mso, 'DTblFNoteAnchorPrefix ', $stb, 
		       $DTblFNoteAnchorPrefix, $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DTblFNoteAnchorSuffix ', $stb, 
		       $DTblFNoteAnchorSuffix, $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DTblFNoteNumberPrefix ', $stb, 
		       $DTblFNoteNumberPrefix, $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DTblFNoteNumberSuffix ', $stb, 
		       $DTblFNoteNumberSuffix, $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DLinebreakChars ', $stb, $DLinebreakChars, 
		       $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DPunctuationChars ', $stb, $DPunctuationChars, 
		       $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DChBarGap ', $DChBarGap, $msc, "\n"
	if $DChBarGap ne "";
    print $handle $i1, $mso, 'DChBarWidth ', $DChBarWidth, $msc, "\n"
	if $DChBarWidth ne "";
    print $handle $i1, $mso, 'DChBarPosition ', $DChBarPosition, $msc, "\n"
	if $DChBarPosition ne "";
    print $handle $i1, $mso, 'DChBarColor ', $stb, $DChBarColor, $ste, 
		       $msc, "\n"
	if $DChBarColor ne "";
    print $handle $i1, $mso, 'DAutoChBars ', $DAutoChBars, $msc, "\n"
	if $DAutoChBars ne "";
    print $handle $i1, $mso, 'DShowAllConditions ', $DShowAllConditions, 
		       $msc, "\n"
	if $DShowAllConditions ne "";
    print $handle $i1, $mso, 'DDisplayOverrides ', $DDisplayOverrides, 
		       $msc, "\n"
	if $DDisplayOverrides ne "";
    print $handle $i1, $mso, 'DViewOnly ', $DViewOnly, $msc, "\n"
	if $DViewOnly ne "";
    print $handle $i1, $mso, 'DViewOnlyXRef ', $DViewOnlyXRef, $msc, "\n"
	if $DViewOnlyXRef ne "";
    print $handle $i1, $mso, 'DViewOnlySelect ', $DViewOnlySelect, $msc, "\n"
	if $DViewOnlySelect ne "";
    print $handle $i1, $mso, 'DViewOnlyNoOp ', $DViewOnlyNoOp, $msc, "\n"
	if $DViewOnlyNoOp ne "";
    print $handle $i1, $mso, 'DViewOnlyWinBorders ', $DViewOnlyWinBorders, 
		       $msc, "\n"
	if $DViewOnlyWinBorders ne "";
    print $handle $i1, $mso, 'DViewOnlyWinMenubar ', $DViewOnlyWinMenubar, 
		       $msc, "\n"
	if $DViewOnlyWinMenubar ne "";
    print $handle $i1, $mso, 'DViewOnlyWinPopup ', $DViewOnlyWinPopup, 
		       $msc, "\n"
	if $DViewOnlyWinPopup ne "";
    print $handle $i1, $mso, 'DViewOnlyWinPalette ', $DViewOnlyWinPalette, 
		       $msc, "\n"
	if $DViewOnlyWinPalette ne "";
    print $handle $i1, $mso, 'DGridOn ', $DGridOn, $msc, "\n"
	if $DGridOn ne "";
    print $handle $i1, $mso, 'DPageGrid ', $DPageGrid, $msc, "\n"
	if $DPageGrid ne "";
    print $handle $i1, $mso, 'DSnapGrid ', $DSnapGrid, $msc, "\n"
	if $DSnapGrid ne "";
    print $handle $i1, $mso, 'DSnapRotation ', $DSnapRotation, $msc, "\n"
	if $DSnapRotation ne "";
    print $handle $i1, $mso, 'DRulersOn ', $DRulersOn, $msc, "\n"
	if $DRulersOn ne "";
    print $handle $i1, $mso, 'DFullRulers ', $DFullRulers, $msc, "\n"
	if $DFullRulers ne "";
    print $handle $i1, $mso, 'DGraphicsOff ', $DGraphicsOff, $msc, "\n"
	if $DGraphicsOff ne "";
    print $handle $i1, $mso, 'DCurrentView ', $DCurrentView, $msc, "\n"
	if $DCurrentView ne "";
    print $handle $i1, $mso, 'DBordersOn ', $DBordersOn, $msc, "\n"
	if $DBordersOn ne "";
    print $handle $i1, $mso, 'DSymbolsOn ', $DSymbolsOn, $msc, "\n"
	if $DSymbolsOn ne "";
    print $handle $i1, $mso, 'DSmartQuotesOn ', $DSmartQuotesOn, $msc, "\n"
	if $DSmartQuotesOn ne "";
    print $handle $i1, $mso, 'DSmartSpacesOn ', $DSmartSpacesOn, $msc, "\n"
	if $DSmartSpacesOn ne "";
    print $handle $i1, $mso, 'DLanguage ', $DLanguage, $msc, "\n"
	if $DLanguage ne "";
    print $handle $i1, $mso, 'DSuperscriptSize ', $DSuperscriptSize, $msc, "\n"
	if $DSuperscriptSize ne "";
    print $handle $i1, $mso, 'DSubscriptSize ', $DSubscriptSize, $msc, "\n"
	if $DSubscriptSize ne "";
    print $handle $i1, $mso, 'DSmallCapsSize ', $DSmallCapsSize, $msc, "\n"
	if $DSmallCapsSize ne "";
    print $handle $i1, $mso, 'DSuperscriptShift ', $DSuperscriptShift, 
		       $msc, "\n"
	if $DSuperscriptShift ne "";
    print $handle $i1, $mso, 'DSubscriptShift ', $DSubscriptShift, $msc, "\n"
	if $DSubscriptShift ne "";
    print $handle $i1, $mso, 'DMathAlphaCharFontFamily ', $stb,
		       $DMathAlphaCharFontFamily, $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DMathSmallIntegral ', $DMathSmallIntegral, 
		       $msc, "\n"
	if $DMathSmallIntegral ne "";
    print $handle $i1, $mso, 'DMathMediumIntegral ', $DMathMediumIntegral, 
		       $msc, "\n"
	if $DMathMediumIntegral ne "";
    print $handle $i1, $mso, 'DMathLargeIntegral ', $DMathLargeIntegral, 
		       $msc, "\n"
	if $DMathLargeIntegral ne "";
    print $handle $i1, $mso, 'DMathSmallSigma ', $DMathSmallSigma, $msc, "\n"
	if $DMathSmallSigma ne "";
    print $handle $i1, $mso, 'DMathMediumSigma ', $DMathMediumSigma, $msc, "\n"
	if $DMathMediumSigma ne "";
    print $handle $i1, $mso, 'DMathLargeSigma ', $DMathLargeSigma, $msc, "\n"
	if $DMathLargeSigma ne "";
    print $handle $i1, $mso, 'DMathSmallLevel1 ', $DMathSmallLevel1, $msc, "\n"
	if $DMathSmallLevel1 ne "";
    print $handle $i1, $mso, 'DMathMediumLevel1 ', $DMathMediumLevel1, 
		       $msc, "\n"
	if $DMathMediumLevel1 ne "";
    print $handle $i1, $mso, 'DMathLargeLevel1 ', $DMathLargeLevel1, $msc, "\n"
	if $DMathLargeLevel1 ne "";
    print $handle $i1, $mso, 'DMathSmallLevel2 ', $DMathSmallLevel2, $msc, "\n"
	if $DMathSmallLevel2 ne "";
    print $handle $i1, $mso, 'DMathMediumLevel2 ', $DMathMediumLevel2, 
		       $msc, "\n"
	if $DMathMediumLevel2 ne "";
    print $handle $i1, $mso, 'DMathLargeLevel2 ', $DMathLargeLevel2, $msc, "\n"
	if $DMathLargeLevel2 ne "";
    print $handle $i1, $mso, 'DMathSmallLevel3 ', $DMathSmallLevel3, $msc, "\n"
	if $DMathSmallLevel3 ne "";
    print $handle $i1, $mso, 'DMathMediumLevel3 ', $DMathMediumLevel3, 
		       $msc, "\n"
	if $DMathMediumLevel3 ne "";
    print $handle $i1, $mso, 'DMathLargeLevel3 ', $DMathLargeLevel3, $msc, "\n"
	if $DMathLargeLevel3 ne "";
    print $handle $i1, $mso, 'DMathSmallHoriz ', $DMathSmallHoriz, $msc, "\n"
	if $DMathSmallHoriz ne "";
    print $handle $i1, $mso, 'DMathMediumHoriz ', $DMathMediumHoriz, $msc, "\n"
	if $DMathMediumHoriz ne "";
    print $handle $i1, $mso, 'DMathLargeHoriz ', $DMathLargeHoriz, $msc, "\n"
	if $DMathLargeHoriz ne "";
    print $handle $i1, $mso, 'DMathSmallVert ', $DMathSmallVert, $msc, "\n"
	if $DMathSmallVert ne "";
    print $handle $i1, $mso, 'DMathMediumVert ', $DMathMediumVert, $msc, "\n"
	if $DMathMediumVert ne "";
    print $handle $i1, $mso, 'DMathLargeVert ', $DMathLargeVert, $msc, "\n"
	if $DMathLargeVert ne "";
    print $handle $i1, $mso, 'DMathShowCustom ', $DMathShowCustom, $msc, "\n"
	if $DMathShowCustom ne "";
    print $handle $i1, $mso, 'DMathFunctions ', $stb, $DMathFunctions, $ste, 
		       $msc, "\n"
	;
    print $handle $i1, $mso, 'DMathNumbers ', $stb, $DMathNumbers, $ste, 
		       $msc, "\n"
	;
    print $handle $i1, $mso, 'DMathVariables ', $stb, $DMathVariables, $ste, 
		       $msc, "\n"
	;
    print $handle $i1, $mso, 'DMathStrings ', $stb, $DMathStrings, $ste, 
		       $msc, "\n"
	;
    print $handle $i1, $mso, 'DMathGreek ', $stb, $DMathGreek, $ste, $msc, "\n"
	;
    print $handle $i1, $mso, 'DMathCatalog ', $DMathCatalog, $msc, "\n"
	if $DMathCatalog ne "";
    print $handle $i1, $mso, 'DElementCatalogScope ', $DElementCatalogScope, 
		       $msc, "\n"
	if $DElementCatalogScope ne "";
    print $handle $i1, $mso, 'DElementBordersOn ', $DElementBordersOn, 
		       $msc, "\n"
	if $DElementBordersOn ne "";
    print $handle $i1, $mso, 'DExclusions ', $DExclusions, $msc, "\n"
	if $DExclusions ne "";
    print $handle $i1, $mso, 'DInclusions ', $DInclusions, $msc, "\n"
	if $DInclusions ne "";
    print $handle $i1, $mso, 'DApplyFormatRules ', $DApplyFormatRules, 
		       $msc, "\n"
	if $DApplyFormatRules ne "";
    print $handle $i1, $mso, 'DNoPrintSepColor ', $stb, $DNoPrintSepColor, 
		       $ste, $msc, "\n"
	if $DNoPrintSepColor ne "";
    print $handle $i1, $mso, 'DPrintProcessColor ', $stb, $DPrintProcessColor, 
		       $ste, $msc, "\n"
	if $DPrintProcessColor ne "";
    print $handle $i1, $mso, 'DPrintSkipBlankPages ', $DPrintSkipBlankPages, 
		       $msc, "\n"
	if $DPrintSkipBlankPages ne "";
    print $handle $i1, $mso, 'DPrintSeparations ', $DPrintSeparations, 
		       $msc, "\n"
	if $DPrintSeparations ne "";
    print $handle $i0, $msc, " $como end of Document\n";
}
##---------------------------------------------------------------------------##
##	Usage:
##	    ($view_rect, $window_rect, $scale) = &'MIFget_doc_win_prop();
##
sub main'MIFget_doc_win_prop {
    ($DViewRect, $DWindowRect, $DViewScale);
}
##---------------------------------------------------------------------------##
##	Usage:
##	    &'MIFset_doc_win_prop($view_rect, $window_rect, $scale);
##
sub main'MIFset_doc_win_prop {
    ($DViewRect, $DWindowRect, $DViewScale) = @_;
}
##---------------------------------------------------------------------------##
##	Usage:
##	    ($margins, $columns, $gap, $pgsize) = &'MIFget_doc_col_prop();
##
sub main'MIFget_doc_col_prop {
    ($DMargins, $DColumns, $DColumnGap, $PageSize);
}
##---------------------------------------------------------------------------##
##	Usage:
##	    &'MIFset_doc_col_prop($margins, $columns, $gap, $pgsize);
##
sub main'MIFset_doc_col_prop {
    ($DMargins, $DColumns, $DColumnGap, $PageSize) = @_;
}
##---------------------------------------------------------------------------##
##	Usage:
##	    ($start, $num_style, $pt_num_style, $twosides, $parity,
##	     $rounding, $frozen) = &'MIFget_doc_pagination();
##
sub main'MIFget_doc_pagination {
    ($DStartPage, $DPageNumStyle, $DPagePointStyle, $DTwoSides, $DParity,
     $DPageRounding, $DFrozenPages);
}
##---------------------------------------------------------------------------##
##	Usage:
##	    &'MIFset_doc_pagination($start, $num_style, $pt_num_style,
##				    $twosides, $parity, $rounding, $frozen);
##
sub main'MIFset_doc_pagination {
    ($DStartPage, $DPageNumStyle, $DPagePointStyle, $DTwoSides, $DParity,
     $DPageRounding, $DFrozenPages) = @_;
}
##---------------------------------------------------------------------------##
##	MIFreset_doc() resets the variables for Document.
##
##	Usage:
##	    &'MIFreset_doc();
##
sub main'MIFreset_doc {
    $DNextUnique = "";
    $DViewRect = "";
    $DWindowRect = "";
    $DViewScale = "";
    $DMargins = "";
    $DColumns = "";
    $DColumnGap = "";
    $DPageSize = "";
    $DStartPage = "";
    $DPageNumStyle = "";
    $DPagePointStyle = "";
    $DTwoSides = "";
    $DParity = "";
    $DFrozenPages = "";
    $DPageRounding = "";
    $DMaxInterLine = "";
    $DMaxInterPgf = "";
    $DFNoteMaxH = "";
    $FNoteStartNum = "";
    $DFNoteRestart = "";
    $DFNoteTag = "";
    $DFNoteLabels = "";
    $DFNoteNumStyle = "";
    $DFNoteAnchorPos = "";
    $DFNoteNumberPos = "";
    $DFNoteAnchorPrefix = "";
    $DFNoteAnchorSuffix = "";
    $DFNoteNumberPrefix = "";
    $DFNoteNumberSuffix = "";
    $DTblFNoteTag = "";
    $DTblFNoteLabels = "";
    $DTblFNoteNumStyle = "";
    $DTblFNoteAnchorPos = "";
    $DTblFNoteNumberPos = "";
    $DTblFNoteAnchorPrefix = "";
    $DTblFNoteAnchorSuffix = "";
    $DTblFNoteNumberPrefix = "";
    $DTblFNoteNumberSuffix = "";
    $DLinebreakChars = "";
    $DPunctuationChars = "";
    $DChBarGap = "";
    $DChBarWidth = "";
    $DChBarPosition = "";
    $DChBarColor = "";
    $DAutoChBars = "";
    $DShowAllConditions = "";
    $DDisplayOverrides = "";
    $DViewOnly = "";
    $DViewOnlyXRef = "";
    $DViewOnlySelect = "";
    $DViewOnlyNoOp = "";
    $DViewOnlyWinBorders = "";
    $DViewOnlyWinMenubar = "";
    $DViewOnlyWinPopup = "";
    $DViewOnlyWinPalette = "";
    $DGridOn = "";
    $DPageGrid = "";
    $DSnapGrid = "";
    $DSnapRotation = "";
    $DRulersOn = "";
    $DFullRulers = "";
    $DGraphicsOff = "";
    $DCurrentView = "";
    $DBordersOn = "";
    $DSymbolsOn = "";
    $DSmartQuotesOn = "";
    $DSmartSpacesOn = "";
    $DLanguage = "";
    $DSuperscriptSize = "";
    $DSubscriptSize = "";
    $DSmallCapsSize = "";
    $DSuperscriptShift = "";
    $DSubscriptShift = "";
    $DMathAlphaCharFontFamily = "";
    $DMathSmallIntegral = "";
    $DMathMediumIntegral = "";
    $DMathLargeIntegral = "";
    $DMathSmallSigma = "";
    $DMathMediumSigma = "";
    $DMathLargeSigma = "";
    $DMathSmallLevel1 = "";
    $DMathMediumLevel1 = "";
    $DMathLargeLevel1 = "";
    $DMathSmallLevel2 = "";
    $DMathMediumLevel2 = "";
    $DMathLargeLevel2 = "";
    $DMathSmallLevel3 = "";
    $DMathMediumLevel3 = "";
    $DMathLargeLevel3 = "";
    $DMathSmallHoriz = "";
    $DMathMediumHoriz = "";
    $DMathLargeHoriz = "";
    $DMathSmallVert = "";
    $DMathMediumVert = "";
    $DMathLargeVert = "";
    $DMathShowCustom = "";
    $DMathFunctions = "";
    $DMathNumbers = "";
    $DMathVariables = "";
    $DMathStrings = "";
    $DMathGreek = "";
    $DMathCatalog = "";
    $DElementCatalogScope = "";
    $DElementBordersOn = "";
    $DExclusions = "";
    $DInclusions = "";
    $DApplyFormatRules = "";
    $DNoPrintSepColor = "";
    $DPrintProcessColor = "";
    $DPrintSkipBlankPages = "";
    $DPrintSeparations = "";
}
##---------------------------------------------------------------------------##
			    ##--------------##
			    ## Mif Routines ##
			    ##--------------##
##---------------------------------------------------------------------------##
##	The routines definded below are all registered in the %MIFToken	     ##
##	array for use in the MIFread_mif() routine.  There purpose is to     ##
##	store the information contained in the Document statement.	     ##
##---------------------------------------------------------------------------##

##---------------------------------------------------------------------------
sub mif'Document {
    local($token, $mode, *data) = @_;

    if ($mode == $MOpen) {
	($_fast, $_noidata) = ($mif'fast, $mif'no_import_data);
	($mif'fast, $mif'no_import_data) = (1, 1);
    } elsif ($mode == $MClose) {
        ($mif'fast, $mif'no_import_data) = ($_fast, $_noidata);
    }
}
##---------------------------------------------------------------------------
sub string_token {
    local(*token, $mode, *data) = @_;
    ($token) = $data =~ /^\s*$stb([^$ste]*)$ste.*$/o;
}
##---------------------------------------------------------------------------
sub data_token {
    local(*token, $mode, *data) = @_;
    ($token) = $data =~ /^\s*(.*)$/o;
}
##---------------------------------------------------------------------------
1;
