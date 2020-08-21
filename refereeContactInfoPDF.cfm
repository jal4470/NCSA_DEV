 <!--- 
	FileName:	refereeContactInfoPDF.cfm
	Created on: 05/04/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

07/20/17 - apinzone (27024) - Added state registered, certified and sorting results from UI page.
 --->
 
<!--- <cfinclude template="cfudfs.cfm"> ---> 
<cfinclude template="_checkLogin.cfm">

<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qGetRefs">
</cfinvoke>

<cfquery name="qStateReg" dbtype="query">
	select DISTINCT STATEREGISTEREDIN from qGetRefs 
</cfquery>

<cfif isDefined("FORM.sortOrder")>
	<cfset sortBy = FORM.sortOrder >
<cfelse>
	<cfset sortBy = "NAME" >
</cfif>
<cfswitch expression="#UCASE(sortBy)#">
	<cfcase value="TOWN">	<cfset orderByCol = " STATE, CITY, LastName, FirstNAme " ></cfcase>
	<cfcase value="RSTATE">	<cfset orderByCol = " STATEREGISTEREDIN " ></cfcase>
	<cfcase value="GRADE">	<cfset orderByCol = " GRADE, LastName, FirstNAme" ></cfcase>
	<cfcase value="NCSAL">	<cfset orderByCol = " REF_LEVEL, LastName, FirstNAme" ></cfcase>
	<cfcase value="AGE">	<cfset orderByCol = " BIRTH_DATE, LastName, FirstNAme" ></cfcase>
	<cfcase value="YRSERVICE">	<cfset orderByCol = " CERTIFIED_1ST_YEAR, LastName, FirstNAme" ></cfcase>
	<cfdefaultcase> 	<cfset orderByCol = " LastName, FirstNAme " >	</cfdefaultcase>
</cfswitch>

<cfif isDefined("FORM.selCert")>
	<cfset selCert = FORM.selCert >
<cfelse>
	<cfset selCert = "" >
</cfif>
<cfif isDefined("FORM.selState")>
	<cfset selState = FORM.selState >
<cfelse>
	<cfset selState = "" >
</cfif>

<cfset whereClause = "">

<CFIF len(trim(selCert))>  
	<CFSET whereClause = "WHERE certified_yn = '#selCert#' "> 
</CFIF>

<CFIF len(trim(selState))> 
	<cfif len(trim(whereClause))>
		<CFSET whereClause = whereClause & " AND " >
	<cfelse>
		<CFSET whereClause = whereClause & " WHERE " >
	</cfif>
	<CFSET whereClause = whereClause & " STATEREGISTEREDIN = '#selState#' ">
</CFIF>

<cfquery name="qGetRefs" dbtype="query">
	select * from qGetRefs
	#preservesinglequotes(whereClause)#
	order by #orderByCol#
</cfquery>

<cfdocument format="pdf" 
			marginBottom=".2"
			marginLeft=".2"
			marginRight=".2"
			marginTop=".5"  >

	<cfhtmlhead text="<link rel='STYLESHEET' type='text/css' href='2col_leftNav.css'>">	
		
	<cfoutput>
	<cfdocumentitem type="header"> 
	 	<table cellspacing="0" cellpadding="2" border="0" width="100%" >
			<tr class="tblHeading">
				<TD colspan="6">NCSA - Referee Contact Info </TD>
			</tr>
			<tr class="tblHeading">		
				<td width="20%" align=Left><br> Referee	</td>
				<td width="15%" align=Left><br> Cell	</td>
				<td width="15%" align=Left><br> Home	</td>
				<td width="25%" align=Left><br> Email	</td>
				<td width="15%" align=Left><br> City	</td>
				<td width="10%" align=center><br> State 	</td>
			</tr>
		</table>
	</cfdocumentitem>
	<table cellspacing="0" cellpadding="3" border="0" width="100%">
		<CFLOOP query="qGetRefs">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<TD width="20%" class="tdUnderLine" align=Left>		#LastName#, #FirstName#			</td>
				<TD width="15%" class="tdUnderLine" align=Left> 	#phoneCell# </td>
				<TD width="15%" class="tdUnderLine" align=Left> 	#phoneHome#	</td>
				<TD width="25%" class="tdUnderLine" align=Left> 	#Email#		</td>
				<TD width="15%" class="tdUnderLine" align=Left>		#CITY#		</td>
				<TD width="10%" class="tdUnderLine" align=center>   #State#		</td>
			</tr>
		</CFLOOP>
	</TABLE>
	</cfoutput>
</cfdocument>