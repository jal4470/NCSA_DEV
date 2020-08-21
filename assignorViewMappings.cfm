<!--- 
	FileName:	assignorViewMappings.cfm
	Created on: 11/04/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: maps fields to specific assignors
	
MODS: mm/dd/yyyy - filastname - comments

 --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- DW6 -->
<head>
<!-- Copyright 2005 Macromedia, Inc. All rights reserved. -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Northern Counties Soccer Association &copy;</title>

<link rel="STYLESHEET" type="text/css" href="2col_leftNav.css">
</head>

<!--- <cfinclude template="cfudfs.cfm"> --->
<body>

<div id="contentText">
<cfoutput>

<cfset orderbyValue = " f.FIELDNAME ">

<cfif isDefined("URL.s") and isNumeric(URL.s)>
	<cfif URL.s eq 1>
		<cfset orderbyValue = " f.FIELDABBR ">
	<cfelseif URL.s eq 2>
		<cfset orderbyValue = " f.FIELDNAME ">
	<cfelseif URL.s eq 3>
		<cfset orderbyValue = " C.LastName, f.FIELDNAME ">
	</cfif>
</cfif>



<CFQUERY name="qAssignedFields" datasource="#SESSION.DSN#">
	SELECT f.FIELD_ID, f.FIELDABBR, f.FIELDNAME, C.FirstName, C.LastName
	  FROM XREF_ASSIGNOR_FIELD xaf
				INNER JOIN TBL_FIELD F ON F.FIELD_ID = xaf.FIELD_ID
				INNER JOIN TBL_CONTACT C ON C.CONTACT_ID = xaf.ASSIGNOR_CONTACT_ID
	 ORDER BY #orderbyValue#
</CFQUERY>

<CFQUERY name="qUNAssignedFields" datasource="#SESSION.DSN#">
	SELECT f.FIELD_ID, f.FIELDABBR, f.FIELDNAME
	  FROM TBL_FIELD f
	 WHERE f.FIELD_ID NOT IN (SELECT FIELD_ID FROM XREF_ASSIGNOR_FIELD)
	   AND f.ACTIVE_YN = 'Y'
	 ORDER BY f.FIELDNAME
</CFQUERY>


<H1 class="pageheading">NCSA - Fields Assigned to a Referee Assignor</H1>
<!--- <br> <h2>Club Name </h2> --->

<table cellspacing="0" cellpadding="3" align="left" border="0" width="600"  >
	<tr class="tblHeading">
		<TD colspan="3">Fields Assigned to a Referee Assignor</TD>
	</tr>
	<tr class="tblHeading">
		<TD><a href="assignorViewMappings.cfm?s=1"> Field Abbr </a> </TD>
		<TD><a href="assignorViewMappings.cfm?s=2"> Field Name </a> </TD>
		<TD><a href="assignorViewMappings.cfm?s=3"> Assignor </a> </TD>
	</tr>
	<CFLOOP query="qAssignedFields">
		<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
			<TD class="tdUnderLine"> &nbsp; #FIELDABBR#</TD>
			<TD class="tdUnderLine"> &nbsp; #FIELDNAME#</TD>
			<TD class="tdUnderLine"> &nbsp; #LastName#, #FirstName#</TD>
		</tr>
	</CFLOOP>
	
	<tr class="tblHeading">
		<TD colspan="3">Fields NOT Assigned to any Referee Assignor</TD>
	</tr>
	<CFLOOP query="qUNAssignedFields">
		<TR bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
			<TD class="tdUnderLine"> &nbsp; #FIELDABBR#</TD>
			<TD class="tdUnderLine"> &nbsp; #FIELDNAME#</TD>
			<TD class="tdUnderLine"> not assigned</TD>
		</tr>
	</CFLOOP>
</table>	

</cfoutput>
</div>
</body>
</html>
