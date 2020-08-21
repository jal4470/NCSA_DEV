<!--- 
	FileName:	rptSingleGame.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
04/06/2009 - AARNONE - T:7491 with (nolock) added to v_games (perf issue)
 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">

<cfif isDefined("FORM.GAPminutes")>
	<cfset GAPminutes = FORM.GAPminutes>
<cfelse>
	<cfset GAPminutes = 120>
</cfif>


<cfif isDefined("FORM.sortOrder")>
	<cfset sortBy = FORM.sortOrder>
<cfelse>
	<cfset sortBy = "DATE">
</cfif>



<cfswitch expression="#UCASE(sortBy)#">
	<cfcase value="DATE">  <cfset orcerByClause = "GAME_DATE, FIELDABBR, GAME_TIME"> </cfcase>
	<cfcase value="FIELD"> <cfset orcerByClause = "FIELDABBR, GAME_DATE, GAME_TIME"> </cfcase>
	<cfdefaultcase>		   <cfset orcerByClause = "GAME_DATE, FIELDABBR, GAME_TIME"> </cfdefaultcase>
</cfswitch>

<CFQUERY name="qGetgames" datasource="#SESSION.DSN#">	
		select DISTINCT GAME_DATE, FIELD_ID
			 , max(game_id)   as game_id
			 , max(game_time) as game_time
			 , max(Division)  as Division
			 , max(fieldAbbr) as fieldAbbr
			 , max(Visitor_TeamName) as Visitor_TeamName
			 , max(Home_TeamName)    as Home_TeamName
		  from V_Games  
		 Where (FIELDABBR <> '' or FIELDABBR is not Null)
		   and left(FIELDABBR, 3) <> 'TBS'
		   and HScore is Null 
		   and VScore is Null
		 GROUP BY game_date, FIELD_ID having count(*) = 1
		 ORDER BY GAME_DATE, FIELDABBR
</CFQUERY> <!--- <cfdump var="#qGetgames#"> ---> 



<H1 class="pageheading">NCSA - Single Game</H1>
<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD width="10%">Game		</TD>
		<TD width="15%">Date/Time		</TD>
		<TD width="15%">PlayField	</TD>
		<TD width="10%">Div			</TD>
		<TD width="25%">Home Team	</TD>
		<TD width="25%">Visitor Team</TD>
	</TR>
</table>

<div style="overflow:auto;height:300px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="4" align="left" border="0" width="98%">
		<CFSET count = 0>
		<CFLOOP query="qGetgames">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,count)#">
				<TD align="center">#GAME_ID#			</TD>
				<TD>#dateFormat(GAME_DATE,"mm/dd/yyyy")# #timeFormat(GAME_TIME,"hh:mm tt")#</TD>
				<TD>#FieldAbbr#</TD>
				<TD>#DIVISION#</TD>
				<TD>#Home_Teamname#</TD>
				<TD>#Visitor_Teamname#</TD>
			</TR>
			<CFSET count = count + 1>	
		</CFLOOP>	
	</table>
</div>
<p><strong>Total Single Games = #Count#</strong></p>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">



<!--- 
<CFQUERY name="qSelectDateField" datasource="#SESSION.DSN#">	
		select DISTINCT GAME_DATE, FIELD_ID
		  from V_Games  with (nolock) 
		 Where (FIELDABBR <> '' or FIELDABBR is not Null)
		   and left(FIELDABBR, 3) <> 'TBS'
		   and FIELDABBR <> 'DROPPED'
		   and FIELDABBR <> 'MBOS'
		   and HScore is Null 
		   and VScore is Null
		 GROUP BY  GAME_DATE, FIELD_ID having count(*) = 1
</CFQUERY> <!--- <cfdump var="#qSelectDateField#"> ---> 
	
<div style="overflow:auto;height:300px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="4" align="left" border="0" width="98%">
<CFSET count = 0>
<CFLOOP query="qSelectDateField">
	
	<CFQUERY name="qGetgames" datasource="#SESSION.DSN#">	
		SELECT  game_id, game_code, game_date, game_time, 
				Division, 
				FIELD_ID, fieldName, fieldAbbr, 
				Visitor_TeamName,
		        Home_TeamName
		  FROM  V_GAMES  with (nolock) 

		 WHERE  FIELD_ID = #FIELD_ID# 
		   AND  game_date = '#DATEFORMAT(GAME_DATE,"mm/dd/yyyy")#'
		   and HScore is Null 
		   and VScore is Null
	</CFQUERY>
<!--- 
			select GAME_ID, GAME_DATE, GAME_TIME, DIVISION, 
				   FIELDNAME, FIELDABBR, 
				   HOME_TEAMNAME,  VISITOR_TEAMNAME
			  from V_Games
			 Where FIELD_ID = ##
		</CFQUERY>GAME_DATE, FIELDABBR, GAME_TIME --   and GAME_DATE = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#GAME_DATE#">--->	

		<!--- <cfinvoke component="#SESSION.SITEVARS.cfcPath#GAME" method="getGameSchedule" returnvariable="qGetgames">
				<cfinvokeargument name="fieldID"	value="#FIELD_ID#">
				<cfinvokeargument name="fromdate"	value="#DATEFORMAT(GAME_DATE,"mm/dd/yyyy")#">
				<cfinvokeargument name="todate"		value="#DATEFORMAT(GAME_DATE,"mm/dd/yyyy")#">
				<cfinvokeargument name="orderBy"	value="FIELDABBR">
		</cfinvoke> --->

		<!--- <cfloop query="qGetgames">
		<br> [#RECORDCOUNT#]--[#GAME_ID#]-[#GAME_DATE#]-[#GAME_TIME#]-[#FIELDNAME#]-[#HOME_TEAMNAME#]-[#VISITOR_TEAMNAME#]
		</cfloop> --->
		<CFLOOP query="qGetgames">
					<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,count)#">
						<TD align="center">#GAME_ID#			</TD>
						<TD>#dateFormat(GAME_DATE,"mm/dd/yyyy")# #timeFormat(GAME_TIME,"hh:mm tt")#</TD>
						<TD>#FieldAbbr#</TD>
						<TD>#DIVISION#</TD>
						<TD>#Home_Teamname#</TD>
						<TD>#Visitor_Teamname#</TD>
					</TR>
				<CFSET count = count + 1>	
		</CFLOOP>	
	</CFLOOP>
	
<!--- <cfabort> --->

</table>
</div>
 --->

 
 