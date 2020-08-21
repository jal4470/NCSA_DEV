<!--- 
	FileName:	refereeGameReport.cfm
	Created on: 10/24/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
04/03/2009 - aarnone - only show league games
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfoutput>

<cfset Weekend	= dateformat(now(),"mm/dd/yyyy")>


<!--- <CFIF isDefined("SESSION.GLOBALVARS.REFASSIGNVIEWDATEYN") AND SESSION.GLOBALVARS.REFASSIGNVIEWDATEYN EQ "Y">
	<CFIF SESSION.menuRoleID EQ 25 AND isDate(SESSION.GLOBALVARS.REFASSIGNVIEWDATE)>
		<CFSET Weekend = SESSION.GLOBALVARS.REFASSIGNVIEWDATE >
	</CFIF>
</CFIF> --->


<cfset ListType	= "missing"> <!--- there may be other types (via URL param?) --->

<cfset refHold = "">

<cfif ListType EQ "missing">
	<cfset title = "Games with Missing Referee Reports">


	<cfquery name="qGetGames" datasource="#SESSION.DSN#">
		select g.GAME_ID, g.GAME_DATE, g.GAME_TIME, g.SCORE_HOME, g.SCORE_VISITOR,
			   g.HOME_TEAM_ID, g.HOME_TEAMNAME, g.VISITOR_TEAM_ID, g.VISITOR_TEAMNAME,
			   g.TYPE, g.RefReportSBM, g.DIVISION, g.REFID, g.FieldAbbr, g.FIELD_ID,
			   r.FirstName,     r.LastName
		  from V_Games G inner join V_Referees r on r.contact_id = g.REFID
		 Where g.GAME_DATE <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#Weekend#">
		   AND g.GAME_ID not in
					   (select GAME_ID
					      from TBL_REFEREE_RPT_HEADER
					     where STARTTIME is not NULL)
		   AND ( g.RefReportSbm is null OR g.RefReportSbm = 'N')
		   AND ( g.TYPE is null or g.TYPE = '' or g.Type = 'L')
			<CFIF SESSION.MENUROLEID EQ 25><!--- referee is logged in --->
			   AND g.REF_ACCEPT_YN = 'Y'
			   AND r.contact_id = #SESSION.USER.CONTACTID#
			</CFIF>
		Order by r.LastName, r.FirstName, g.GAME_DATE, dbo.formatDateTime(g.GAME_TIME,'HH:MM 24')
	</cfquery>
</cfif>


<div id="contentText">
<H1 class="pageheading">NCSA - #VARIABLES.title#</H1>
<table width="100%">
<tr><td align="left"><h2>as of #dateFormat(Weekend,"mm/dd/yyyy")# </h2>
	</td>
	<td align="right">
		<FORM name="Games" action="refereeGameReport.cfm"  method="post" >
			<input type="Submit" name="printme" value="Printer Friendly" >  
		</FORM>
	</td>
</tr>
</table>



<!--- 
<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*">
 --->

<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD width="5%">&nbsp;</TD>
		<TD width="13%" align=left>   Date Time</TD>
		<TD width="05%" align=center> Div</TD>
		<TD width="09%" align=left> Game </TD>
		<TD width="20%" align=left>	Home Team</TD>
		<TD width="22%" align=left>	VisitorTeam</TD>
		<TD width="18%" align=left>	Field</TD>
		<TD width="08%" align=left>	HS-VS </TD>
</tr>
</TABLE>

<div style="overflow:auto; height:500px; border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%">
		<cfloop query="qGetGames">
			<cfif refHold NEQ REFID>
				<cfset refHold = REFID>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!---  or counter --->
					<TD colspan=10 ><b> #LastName#, #FirstName#</b>	</TD>
				</tr>
			</cfif>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!---  or counter --->
				<td width="4%"  class="tdUnderLine"> &nbsp; 	</td>
				<TD width="14%" class="tdUnderLine" align=Left> #dateFormat(GAME_DATE,"mm/dd/yyyy")# #timeFormat(GAME_TIME,"hh:mm tt")#		</TD>
				<TD width="04%" class="tdUnderLine" align=center>#DIVISION#		</TD>
				<TD width="06%" class="tdUnderLine" align=left>#GAME_ID#			</TD>
				<TD width="23%" class="tdUnderLine" align=Left>  #HOME_TEAMNAME#	</TD>
				<TD width="23%" class="tdUnderLine" align=Left>  #VISITOR_TEAMNAME#</TD>
				<TD width="18%" class="tdUnderLine" align=Left>  #FieldAbbr#		</TD>
				<td width="08%"  class="tdUnderLine" align=Left>  #SCORE_HOME# - #SCORE_VISITOR#	</td>
			</TR>
		</cfloop>
	</TABLE>
</div>

  
</cfoutput>
</div>
<cfinclude template="_footer.cfm">

<CFIF isDefined("FORM.PRINTME")><!--- mimeType="text/html" --->
	<!--- This will pop up a window that will display the page in a pdf --->
	<script> window.open('refereeGameReportPDF.cfm','popwin'); </script> 
</CFIF>
