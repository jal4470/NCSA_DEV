<!--- 
	FileName:	rptGameOverlapPDF.cfm
	Created on: 05/28/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
05/28/09 - aarnone - #7311 printer friendly
07/20/17 - apinzone (27024) - Added date filtering

	NOTE! - changes to this page may also have to be included into rptGameOverlap.cfm


 --->
 
<!--- <cfinclude template="cfudfs.cfm"> ---> 
<cfinclude template="_checkLogin.cfm">

<cfif isDefined("url.mn")>
	<cfset overlapMinutes = url.mn>
<cfelseif isDefined("form.overlapMinutes") and len(trim(form.overlapMinutes))>
	<cfset overlapMinutes = form.overlapMinutes>
<cfelse>
	<cfset overlapMinutes = 60>
</cfif>

<cfif isDefined("url.so")>
	<cfset sortBy = url.so>
<cfelseif isDefined("form.sortOrder") and len(trim(form.sortOrder))>
	<cfset sortBy = form.sortOrder>
<cfelse>
	<cfset sortBy = "DATE">
</cfif>

<cfif isDefined("form.WeekendFrom") and len(trim(form.WeekendFrom))>
	<cfset WeekendFrom = dateFormat(FORM.WeekendFrom,"mm/dd/yyyy")>
<cfelse>
	<cfset WeekendFrom = dateFormat(session.currentseason.startdate,"mm/dd/yyyy")>
</cfif>

<cfif isDefined("form.WeekendTo") and len(trim(form.WeekendTo))>
	<cfset WeekendTo = dateFormat(FORM.WeekendTo,"mm/dd/yyyy")>
<cfelse>
	<cfset WeekendTo = dateFormat(session.currentseason.enddate,"mm/dd/yyyy")>
</cfif>

<cfswitch expression="#UCASE(sortBy)#">
	<cfcase value="DATE">  <cfset orderByClause = "GAME_DATE, FIELDABBR, dbo.formatDateTime(GAME_TIME,'HH:MM 24')"> </cfcase>
	<cfcase value="FIELD"> <cfset orderByClause = "FIELDABBR, GAME_DATE, dbo.formatDateTime(GAME_TIME,'HH:MM 24')"> </cfcase>
	<cfdefaultcase>		   <cfset orderByClause = "GAME_DATE, FIELDABBR, dbo.formatDateTime(GAME_TIME,'HH:MM 24')"> </cfdefaultcase>
</cfswitch>

<CFQUERY name="qGetgames" datasource="#SESSION.DSN#">	
	select GAME_ID, GAME_DATE, GAME_TIME, DIVISION, 
		   FIELDNAME, FIELDABBR, 
		   HOME_TEAMNAME,  VISITOR_TEAMNAME, Home_CLUB_ID, Visitor_CLUB_ID 
	  from V_Games
	 Where (FIELDABBR <> '' or FIELDABBR is not Null)
	 	   and field_ID NOT in  (select Field_id from TBL_FIELD where CLUB_ID = 1)
		   and HScore is Null 
		   and VScore is Null
		   and ( game_date >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendFrom#"> and
	   		 	 game_date <= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#VARIABLES.WeekendTo#"> )
		 Order by  #preserveSingleQuotes(orderByClause)#
</CFQUERY><!--- GAME_DATE, FIELDABBR, GAME_TIME --->
	
<cfif listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0>
	<cfquery name="qGetgames" dbtype="query">
		SELECT * FROM qGetgames	
		  WHERE Home_CLUB_ID    = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CLUBID#">
		     OR Visitor_CLUB_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.USER.CLUBID#">
	</cfquery> 
</cfif>

<cfset PrvFieldAbbr	= "">
<cfset PrvGameDate  = "">
<cfset PrvGameTime  = "">
<cfset PrvGame		= 0>
<cfset PrvGameDiv	= "">
<cfset PrvHomeTeam	    = "">
<cfset PrvVisitorTeam	= "">
<cfset PrvGameTimeInMin = 0>
<CFSET PRV_gameDateTime = 0>
<cfset gTimeInMin = 0>
<cfset count = 0>


<cfdocument format="pdf" 
			marginBottom=".5"
			marginLeft=".4"
			marginRight=".4"
			marginTop=".8"
			orientation="portrait" > 
	<cfhtmlhead text="<link rel='STYLESHEET' type='text/css' href='2col_leftNav.css'>">	
		<cfoutput>
	<cfdocumentitem type="header" > <!--- has heading but not spaced right --->
	
		<div id="contentText">
		<table cellspacing="0" cellpadding="1" align="center" border="0" width="100%">
			<tr><td colspan="5" align="left">
					<br>
					<H1 class="pageheading">
						NCSA - Overlapping Games - Difference of 
						<cfswitch expression="#overlapMinutes#">
							<cfcase value="60">  1 Hour </cfcase>
							<cfcase value="75">  1 Hour 15 Minutes </cfcase>
							<cfcase value="90">  1 Hour 30 Minutes </cfcase>
							<cfcase value="105"> 1 Hour 45 Minutes </cfcase>
							<cfcase value="120"> 2 Hours </cfcase>
						</cfswitch> or less.
					</H1>
				</td>
				<td colspan="1" align="right">
					<br>Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
				</td>
			</tr>
			<tr class="tblHeading">
				<TD width="10%">Game		</TD>
				<TD width="15%">Date/Time		</TD>
				<TD width="20%">PlayField	</TD>
				<TD width="05%">Div			</TD>
				<TD width="25%">Home Team	</TD>
				<TD width="25%">Visitor Team</TD>
			</TR>
		</table>
		</div>

	</cfdocumentitem>
	

	<div id="contentText">
		<table cellspacing="0" cellpadding="2" align="left" border="0" width="100%">
			<CFLOOP query="qGetgames">
				<cfif PrvFieldAbbr NEQ FIELDABBR OR PrvGameDate NEQ GAME_DATE>
		 			<cfset PrvFieldAbbr	= FIELDABBR>
					<cfset PrvGameDate  = dateFormat(GAME_DATE,"mm/dd/yyyy")>
					<cfset PrvGameTime  = timeFormat(GAME_TIME,"hh:mm tt")>
					<cfset PrvGame		= GAME_ID>
					<cfset PrvGameDiv	= DIVISION>
					<cfset PrvHomeTeam	    = HOME_TEAMNAME>
					<cfset PrvVisitorTeam	= VISITOR_TEAMNAME>
					<cfset PrvGameTimeInMin = gTimeInMin>
					<CFSET PRV_gameDateTime = PrvGameDate & " " & PrvGameTime>
				<CFELSE>
					<CFSET gameDateTime = dateFormat(GAME_DATE,"mm/dd/yyyy") & " " & timeFormat(GAME_TIME,"hh:mm tt")>
					<CFSET PrintIt = "">
					<cfset TimeDiffMinutes = ABS(dateDiff("n",gameDateTime, PRV_gameDateTime))>
		
					<CFIF TimeDiffMinutes LTE overlapMinutes>
						<cfset PrintIt = "Y">
					</CFIF>
					
					<CFIF Trim(PrintIt) EQ "Y">
						<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,count)#">
							<TD class="tdPDF"  width="10%" align="center">#PrvGame#	</TD>
							<TD class="tdPDF"  width="15%">#PrvGameDate# #PrvGameTime#</TD>
							<TD class="tdPDF"  width="20%">#PrvFieldAbbr#</TD>
							<TD class="tdPDF"  width="05%">#PrvGameDiv#</TD>
							<TD class="tdPDF"  width="25%">#PrvHomeTeam#</TD>
							<TD class="tdPDF"  width="25%">#PrvVisitorTeam#</TD>
						</TR>
						<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,count)#">
							<TD class="tdPDF"  align="center">#GAME_ID#			</TD>
							<TD class="tdPDF" >#dateFormat(GAME_DATE,"mm/dd/yyyy")# #timeFormat(GAME_TIME,"hh:mm tt")#</TD>
							<TD class="tdPDF" >#FieldAbbr#</TD>
							<TD class="tdPDF" >#DIVISION#</TD>
							<TD class="tdPDF" >#Home_Teamname#</TD>
							<TD class="tdPDF" >#Visitor_Teamname#</TD>
						</TR>
						<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,count)#">
							<TD class="tdUnderLinePDF" align="right"> <strong>Overlap by : </strong> </TD>
							<TD class="tdUnderLinePDF" align="left" colspan="5">
								<cfset numHours = TimeDiffMinutes \ 60 >	 
								<cfset numMins  = TimeDiffMinutes - ( numHours * 60 )>	
								<strong> #numHours# hours #numMins# min. </strong>   
								<!---#TimeDiffMinutes# #GapHours# hrs and #GapMinutes# ---> 
							</TD>
						</TR>
						<CFSET count = Count + 1>
					</CFIF>
					
					<cfset PrvFieldAbbr	= FIELDABBR>
					<cfset PrvGameDate  = dateFormat(GAME_DATE,"mm/dd/yyyy")>
					<cfset PrvGameTime  = timeFormat(GAME_TIME,"hh:mm tt")>
					<cfset PrvGame		= GAME_ID>
					<cfset PrvGameDiv	= DIVISION>
					<cfset PrvHomeTeam	    = HOME_TEAMNAME>
					<cfset PrvVisitorTeam	= VISITOR_TEAMNAME>
					<cfset PrvGameTimeInMin = gTimeInMin>
					<CFSET PRV_gameDateTime = PrvGameDate & " " & PrvGameTime>
				</cfif>
			</CFLOOP>	
			<tr><td colspan="6">
					<p><strong>Total Overlaps = #Count#</strong></p>
				</td>
			</tr>
		</table>
	</div>
	</cfoutput>
</cfdocument>
 