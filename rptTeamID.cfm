<!--- 
	FileName:	rptTeamID.cfm
	Created on: 02/02/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: list out the team ids and team names for the teams seected
		probably used for upload game util where the team ids are needed
	
MODS: mm/dd/yyyy - filastname - comments
02/05/09 - aarnone - added sort by drop down
11/16/2016 - rgonzalez - removed comments from cfquery
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Team ID Report</H1>	<!--- <h2>yyyyyy </h2> --->

<CFIF isDefined("FORM.TeamAgeSelected")>
	<cfset TeamAgeSelected = trim(FORM.TeamAgeSelected)>
<CFELSE>
	<cfset TeamAgeSelected = "">
</CFIF>
<CFIF isDefined("FORM.BGSelected")>
	<cfset BGSelected = trim(FORM.BGSelected)>
<CFELSE>
	<cfset BGSelected = "">
</CFIF>
<CFIF isDefined("FORM.workingSeason")>
	<cfset workingSeason = trim(FORM.workingSeason)>
<CFELSE>
	<cfset workingSeason = "">
</CFIF>
<CFIF isDefined("FORM.PlayLevel")>
	<cfset PlayLevel = trim(FORM.PlayLevel)>
<CFELSE>
	<cfset PlayLevel = "">
</CFIF>
<CFIF isDefined("FORM.SORTORDER")>
	<cfset selectSort = FORM.SORTORDER>
<CFELSE>
	<cfset selectSort = "">
</CFIF>


<CFIF isDefined("FORM.getTeams")>
	<cfswitch expression="#selectSort#">
		<cfcase value="FLIT"> <cfset sortBy = "division"> </cfcase>
		<cfcase value="TEAM"> <cfset sortBy = "teamname"> </cfcase>
		<cfcase value="TID">  <cfset sortBy = "teamid">   </cfcase>
		<cfdefaultcase>		  <cfset sortBy = "">		  </cfdefaultcase>
	</cfswitch>
	<cfinvoke component="#SESSION.SITEVARS.cfcpath#TEAM" method="getTeamID" returnvariable="qTeamID">
		<cfinvokeargument name="gender"   value="#VARIABLES.BGSelected#">
		<cfinvokeargument name="age"      value="#VARIABLES.TeamAgeSelected#">
		<cfinvokeargument name="playLevel" value="#VARIABLES.PlayLevel#">
		<cfinvokeargument name="seasonID" value="#VARIABLES.workingSeason#">
		<cfinvokeargument name="sortBy"   value="#VARIABLES.sortBy#">
	</cfinvoke>
</CFIF>

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES"> 
</cfinvoke> <!--- lTeamAges --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL"> 
</cfinvoke> <!--- lPlayLevel --->

<CFQUERY name="qWorkingSeasons" datasource="#SESSION.DSN#">
	SELECT SEASON_ID, SEASON_YEAR, SEASON_SF, 
		   CURRENTSEASON_YN, REGISTRATIONOPEN_YN
	  FROM TBL_SEASON 

	ORDER BY SEASON_ID desc
</CFQUERY>

<FORM name="teamID" action="rptTeamID.cfm" method="post">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="99%">
	<TR><TD><b>Team Age:</b></td>
		<td><b>Level:</b>	</td>
		<td><b>Gender:</b>	</td>
		<td><b>Season:</b>	</td>
		<td><b>Sort By</b>	</td>
		<td>&nbsp;			</TD>
	</TR>
	<TR><TD><SELECT  name="TeamAgeSelected" >
				<OPTION value="">All</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF VARIABLES.TeamAgeSelected EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>
		</td>
		<td><SELECT  name="PlayLevel">
				<OPTION value="" selected>All</OPTION>
				<CFLOOP list="#lPlayLevel#" index="ipl">
					<OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
				</CFLOOP>
			</SELECT>
		</td>
		<td><SELECT  name="BGSelected" >
				<OPTION value="">Both </OPTION>
				<OPTION value="B" <CFIF VARIABLES.BGSelected EQ "B">selected</CFIF> >Boys</OPTION>
				<OPTION value="G" <CFIF VARIABLES.BGSelected EQ "G">selected</CFIF> >Girls</OPTION>
			</SELECT>
		</td>
		<td><SELECT name="workingSeason" >
				<CFLOOP query="qWorkingSeasons">
					<CFSET curr = "">
					<CFSET reg = "">
					<CFIF CURRENTSEASON_YN EQ 'Y'>
						<CFSET curr = "(current)">
					<CFELSEIF REGISTRATIONOPEN_YN EQ 'Y'>
						<CFSET reg = "(registration)">
					</CFIF> 
					<option value="#season_id#" <cfif VARIABLES.workingSeason EQ season_id>selected</cfif> >#SEASON_YEAR# #SEASON_SF# #curr# #reg# </option>
				</CFLOOP>
			</SELECT>
		</td>
		<td><select name="sortOrder">
				<option value="FLIT" <cfif selectSort EQ "FLIT">selected</cfif> >Flight</option>
				<option value="TEAM" <cfif selectSort EQ "TEAM">selected</cfif> >Team Name</option>
				<option value="TID"  <cfif selectSort EQ "TID"> selected</cfif> >Team ID</option>
			</select>
		</td>
		<td><INPUT type="Submit" name="getTeams" value="Get Teams">
		</TD>
	</TR>
</table>
</FORM>

<table cellspacing="0" cellpadding="3" align="left" border="0" width="98%">
<CFIF isDefined("qTeamID")>
	<tr><td colspan="3" > &nbsp;
			Number of teams: #qTeamID.RECORDCOUNT#
		</td>
	</tr>
	<tr class="tblHeading">
		<td width="20%" align="left"><b>Flight</b></td>
		<td width="20%" align="left"><B>Team ID</B></td>
		<td width="60%" align="left"><B>Team Name</B></td>
	</tr>
	<CFIF qTeamID.RECORDCOUNT GT 0 >
		<CFLOOP query="qTeamID">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> <!--- currentRow or counter --->
				<td width="20%" class="tdUnderLine" align="left">#DIVISION#</td>
				<td width="20%" class="tdUnderLine" align="left">#TEAM_ID#</td>
				<td width="60%" class="tdUnderLine" align="left">#TEAMNAMEDERIVED#&nbsp;</td>
			</tr>   
		</CFLOOP>
	<CFELSE>
		<tr><td colspan="3" align="center">
				<br> <span class="red"> <b>No teams found.</b> </span>
			</td>
		</tr>
	</CFIF>
<cfelse>
	<tr class="tblHeading"> <td colspan="3">&nbsp;</td> </tr>
</CFIF>
</table>
	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
