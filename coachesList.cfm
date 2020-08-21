<!--- 
	FileName:	coachesList.cfm
	Created on: 12/11/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<!--- <cfinclude template="_checkLogin.cfm"> use? --->


<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Coaches List </H1>
<!--- <br>	<h2>yyyyyy </h2> --->

<CFIF isDefined("FORM.selDivision")>
	<cfset selDivision = FORM.selDivision>
<CFELSE>
	<cfset selDivision = "">
</CFIF>

<CFINVOKE component="#SESSION.SITEVARS.cfcPath#TEAM" method="getDivisions" returnvariable="qDivisions">
</CFINVOKE>

<CFIF len(trim(VARIABLES.selDivision))>
	<cfquery name="qCoaches" datasource="#SESSION.DSN#">
		SELECT DIVISION, teamID, 
				coach, coachLastName, HomePhone, CellPhone, Email,
				asstCoach,  asstCoachLastName, asstHomePhone, asstCellPhone, asstEmail, 
				ClubAbbr, Club_name
		 FROM  V_CoachesTeams
		Where  DIVISION = <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.selDivision#">
		  AND  CLUB_ID <> 1
		 ORDER BY CLUB_NAME
	</cfquery>	<!--- <cfdump var="#qCoaches#"> --->
</CFIF>


<FORM action="coachesList.cfm" method="post">
	<SELECT name="selDivision" >
		<OPTION value="" >Select a Division</OPTION>
		<cfloop query="qDivisions">
			<OPTION value="#Division#" <cfif selDivision EQ Division>selected</cfif> >#Division#</OPTION>
		</cfloop>
	</select>
	<input type="Submit" name="submit" value="Enter"> 
</FORM>

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="4">
			Division:
			<CFIF len(trim(VARIABLES.selDivision))>
				#VARIABLES.selDivision#
			</CFIF>
		</TD>
	</tr>
	
	<CFIF isDefined("qCoaches") AND qCoaches.RECORDCOUNT >
		<cfloop query="qCoaches">
			<CFIF len(trim(asstCoachLastName))>
				<cfset tdclass = "">
			<cfelse>
				<cfset tdclass = "class='tdUnderLine'">
			</CFIF>
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
				<TD #tdclass# > #Club_name#				</TD>
				<TD #tdclass# > Head Coach: &nbsp; &nbsp; #coachLastName#, #coach# </TD>
				<TD #tdclass# > #Email#					</TD>
				<TD #tdclass# > #CellPhone#				</TD>
			</tr>
			<CFIF len(trim(asstCoachLastName))>
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<TD class="tdUnderLine" >  &nbsp;	</TD>
					<TD class="tdUnderLine" > Asst Coach: &nbsp; &nbsp; #asstCoachLastName#, #asstCoach#	</TD>
					<TD class="tdUnderLine" > #asstEmail#				</TD>
					<TD class="tdUnderLine" > #asstCellPhone#			</TD>
				</tr>
			</CFIF>
		</cfloop>
	</CFIF>
</table>	


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
