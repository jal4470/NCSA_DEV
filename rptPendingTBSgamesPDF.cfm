<!--- 
	FileName:	rptPendingTBSgamesPDF.cfm
	Created on: 05/19/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
	
MODS: mm/dd/yyyy - filastname - comments
05/19/09 - aarnone - #7311 printer friendly


	NOTE! - changes to this page may also have to be included into rptPendingTBSgames.cfm

 --->
 
<!--- <cfinclude template="cfudfs.cfm"> ---> 
<cfinclude template="_checkLogin.cfm">



<CFIF isDefined("URL.SBY")>
	<CFSET sortBy = URL.SBY>
<CFELSE>
	<CFSET sortBy = "">
</CFIF>

<CFSWITCH expression="#UCASE(VARIABLES.sortBy)#">
	<CFCASE value="FIELD">
		<CFSET orderByClause = " FIELDNAME, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">
	</CFCASE>
	<CFCASE value="DIV">
		<CFSET orderByClause = " division_id, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">
	</CFCASE>
	<CFCASE value="HTEAM">
		<CFSET orderByClause = " HOME_TEAMNAME, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">
	</CFCASE>
	<CFCASE value="VTEAM">
		<CFSET orderByClause = " VISITOR_TEAMNAME, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">
	</CFCASE>
	<cfdefaultcase>
		<CFSET orderByClause = " GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24') ">
	</cfdefaultcase>
</CFSWITCH>

<CFQUERY name="qTeams" datasource="#SESSION.DSN#">
	select GAME_ID, GAME_DATE, GAME_TIME, FIELDNAME, division_id, VISITOR_TEAMNAME, HOME_TEAMNAME,
			Home_CLUB_ID, Visitor_CLUB_ID 
	  from V_GAMES 
	 where field_ID in 
	 				(select Field_id 
					   from TBL_FIELD 
					  where CLUB_ID = 1)
	ORDER BY #preserveSingleQuotes(VARIABLES.orderByClause)#
</CFQUERY>

<cfif listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0>
	<cfquery name="qTeams" dbtype="query">
		SELECT * FROM qTeams	
		  WHERE Home_CLUB_ID    = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CLUBID#">
		     OR Visitor_CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CLUBID#">
	</cfquery> 
</cfif>

<!---  --->
<cfdocument format="pdf" 
			marginBottom=".5"
			marginLeft=".4"
			marginRight=".4"
			marginTop=".85"
			orientation="landscape" > 
	<cfoutput>
	<cfdocumentitem type="header" > <!--- has heading but not spaced right --->
		<cfhtmlhead text="<link rel='STYLESHEET' type='text/css' href='2col_leftNav.css'>">	
		<div id="contentText">
			<table border="0" width="100%" cellpadding="2" cellspacing="0">
				<tr><td colspan="4" align="left">
						<H1 class="pageheading">NCSA - Pending TBS Games</H1>
					</td>
					<td colspan="2" align="right">
						<br>Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
					</td>
				</tr>
				<tr class="tblHeading">
					<TD width="10%">Game ID</TD>
					<TD width="15%">Game DateTime</TD>
					<TD width="14%">Field Name</TD>
					<TD width="10%">Division</TD>
					<TD width="24%">Home Team</TD>
					<TD width="27%">Visitor Team</TD>
				</tr>
			</table>
		</div>
	
	</cfdocumentitem>
	
	<div id="contentText">
		<table cellspacing="0" cellpadding="4" align="left" border="0" width="100%">
			<CFLOOP query="qTeams">
				<tr  bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
					<TD class="tdUnderLinePDF" width="09%" valign="top">&nbsp; #GAME_ID#</TD>
					<TD class="tdUnderLinePDF" width="16%" valign="top">&nbsp; #dateFormat(GAME_DATE,"mm/dd/yy")# @ #timeFormat(GAME_TIME,"hh:mm tt")#</TD>
					<TD class="tdUnderLinePDF" width="15%" valign="top">&nbsp; #FIELDNAME# </TD>
					<TD class="tdUnderLinePDF" width="10%" valign="top">&nbsp; #division_id# </TD>
					<TD class="tdUnderLinePDF" width="25%" valign="top">&nbsp; #HOME_TEAMNAME# </TD>
					<TD class="tdUnderLinePDF" width="25%" valign="top">&nbsp; #VISITOR_TEAMNAME# </TD>
				</tr>
			</CFLOOP>
		</table>
	</div>
	</cfoutput>



</cfdocument>
