<!--- 
	FileName:	teamClubAdminReg.cfm
	Created on: 01/13/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: this file will display a list of clubs for the admin to choose from
	
MODS: mm/dd/yyyy - filastname - comments
	
 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Register a team for a Club</H1>

<CFIF isDefined("SESSION.REGSEASON")>
	<CFSET displaySeason = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
	<CFSET SF = SESSION.REGSEASON.SF>
	<CFSET seasonID = SESSION.REGSEASON.ID>
<CFELSE>
	<CFSET displaySeason = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
	<CFSET SF = SESSION.CURRENTSEASON.SF>
	<CFSET seasonID = SESSION.CURRENTSEASON.ID>
</CFIF>

<h2>for #displaySeason# Season </h2>

<CFSET errMessage = "">


<CFIF isDefined("FORM.clubID") AND FORM.clubID GT 0>
	<CFSET clubID = FORM.clubID>
	
	<cflocation url="regTeamList.cfm?cid=#VARIABLES.clubID#">
<CFELSE>
	<CFSET clubID = 0>
</CFIF>
<cfinvoke component="#SESSION.sitevars.cfcPath#REGISTRATION" method="getRegisteredClubs" returnvariable="clubInfo">
</cfinvoke>  <!--- <cfdump var="#clubInfo#"> --->
		
<!--- 
<CFIF isDefined("FORM.REGISTER")>
	<CFINVOKE component="#SESSION.SITEVARS.cfcPath#registration" method="registerNewTeam" returnvariable="stRegTeam">
		<cfinvokeArgument name="clubID" 		value="#FORM.clubID#">
		<cfinvokeArgument name="HeadCoachID" 	value="#FORM.HeadCoachID#">
		<cfinvokeArgument name="AsstCoachID" 	value="#FORM.AsstCoachID#">
		<cfinvokeArgument name="TeamAge" 		value="#FORM.TeamAge#">
		<cfinvokeArgument name="PlayLevel" 		value="#FORM.PlayLevel#">
		<cfinvokeArgument name="Gender" 		value="#FORM.Gender#">
		<cfinvokeArgument name="USSFDiv" 		value="#FORM.USSFDiv#">
		<cfinvokeArgument name="SecondTeam" 	value="#FORM.SecondTeam#">
		<cfinvokeArgument name="NonSundayPlay" 	value="#FORM.NonSundayPlay#">
		<cfinvokeArgument name="seasonID" 		value="#VARIABLES.seasonID#">
		<cfinvokeArgument name="contactID" 		value="#SESSION.USER.CONTACTID#">
		<cfinvokeArgument name="PriorTeamID" 	value="0"><!--- #FORM.TeamID# --->
	</CFINVOKE>
	
	<CFIF stRegTeam.swErr>
		<CFSET errMessage = errMessage & stRegTeam.MSG>
	<CFELSE>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#team" method="approveTeam">
			<cfinvokeargument name="updContactID" value="#SESSION.USER.CONTACTID#">
			<cfinvokeargument name="TeamID"       value="#stRegTeam.TEAMID#">
		</cfinvoke>

		<CFSET errMessage = "Team was registered and approved.">
	</CFIF>
</CFIF>
 --->

		
		
		
<FORM action="teamClubAdminReg.cfm" method="post">
	<select name="clubid">
		<option value="0">Select a Club...</option>
		<CFLOOP query="clubInfo">
			<option value="#CLUB_ID#" <cfif variables.clubid EQ CLUB_ID>selected</cfif> >#CLUB_NAME#</option>
		</CFLOOP>
	</select> 
	<input type="Submit" name="getTeams" value="Enter">
 

<!--- <CFIF VARIABLES.clubid GT 0>

	<cfquery name="qoqClubInfo" dbtype="query">
		SELECT CLUB_NAME
		  FROM clubInfo
		 WHERE CLUB_ID = #VARIABLES.clubID#
	</cfquery>
	<CFIF qoqClubInfo.RECORDCOUNT>
		<cfset clubName = qoqClubInfo.CLUB_NAME>
	<CFELSE>
		<cfset clubName = "Club name not found.">
	</CFIF> 


	<cfinvoke component="#SESSION.SITEVARS.cfcpath#contact" method="getClubContactRoleX" returnvariable="qCoaches">
		<cfinvokeargument name="clubID" value="#VARIABLES.clubID#"> 
		<cfinvokeargument name="roleID" value="#SESSION.CONSTANT.RoleIDcoach#"> 
	</cfinvoke> <!--- rs2 --->	<!--- <cfdump var="#qCoaches#"> --->
	<cfif qCoaches.recordCount>
		<cfset lCoachesID = valueList(qCoaches.contact_id)>
	<cfelse>
		<cfset lCoachesID = 0>
	</cfif>
	<!--- <cfset lCoachesID = valueList(qCoaches.contact_id)> --->
	
	<CFQUERY name="qOtherContacts" datasource="#SESSION.DSN#">
		SELECT c.contact_id, c.FirstName, c.lastName
		  FROM TBL_CONTACT c INNER JOIN XREF_CONTACT_ROLE X on x.CONTACT_ID = c.CONTACT_ID
		 WHERE c.CLUB_ID = #VARIABLES.ClubId#
		   AND c.CONTACT_ID NOT IN (#lCoachesID#)
	</CFQUERY> <!--- rs3 --->	<!--- <cfdump var="#qOtherContacts#"> --->
	
	<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
		<cfinvokeargument name="listType" value="TEAMAGES"> 
	</cfinvoke> <!--- <cfdump var="#lTeamAges#"> --->
	<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
		<cfinvokeargument name="listType" value="PLAYLEVEL"> 
	</cfinvoke> <!--- <cfdump var="#lPlayLevel#"> --->
	
	<!--- <CFIF isDefined("FORM.ClubName")> 
		<cfset ClubName = FORM.ClubName> 
	<CFELSE> 
		<cfset ClubName = ""> 
	</CFIF> --->
	<CFIF isDefined("FORM.TeamAge")> 
		<cfset TeamAge = FORM.TeamAge> 
	<CFELSE> 
		<cfset TeamAge = ""> 
	</CFIF>
	<CFIF isDefined("FORM.PlayLevel")> 
		<cfset PlayLevel = FORM.PlayLevel> 
	<CFELSE> 
		<cfset PlayLevel = ""> 
	</CFIF>
	<CFIF isDefined("FORM.Division")> 
		<cfset Division = FORM.Division> 
	<CFELSE> 
		<cfset Division = ""> 
	</CFIF>
	<CFIF isDefined("FORM.USSFDiv")> 
		<cfset USSFDiv = FORM.USSFDiv> 
	<CFELSE> 
		<cfset USSFDiv = ""> 
	</CFIF>
	<CFIF isDefined("FORM.Gender")> 
		<cfset Gender = FORM.Gender> 
	<CFELSE> 
		<cfset Gender = ""> 
	</CFIF>
	<CFIF isDefined("FORM.HeadCoachId")> 
		<cfset HeadCoachId = FORM.HeadCoachId> 
	<CFELSE> 
		<cfset HeadCoachId = ""> 
	</CFIF>
	<CFIF isDefined("FORM.AsstCoachId")> 
		<cfset AsstCoachId = FORM.AsstCoachId> 
	<CFELSE> 
		<cfset AsstCoachId = ""> 
	</CFIF>
	<CFIF isDefined("FORM.SecondTeam")> 
		<cfset SecondTeam = FORM.SecondTeam> 
	<CFELSE> 
		<cfset SecondTeam = ""> 
	</CFIF>
	<CFIF isDefined("FORM.Gender")> 
		<cfset Gender = FORM.Gender> 
	<CFELSE> 
		<cfset Gender = "B"> 
	</CFIF>
	
	<CFSET NonSundayPlay	= "N">
	

	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="90%">
		<tr class="tblHeading">	
			<TD colspan="2">Team Info for #VARIABLES.clubName#:</TD>
		</tr>
		<cfif len(Trim(errMessage))>
			<TR><TD colspan="3" align="Center" class="red">  <b>#errMessage#</b>  </td>
			</TR>
		</cfif>
		<TR><TD align="right">#required# <b>Gender</b></TD>
			<TD><b>
				<input type="Radio" maxlength="1" name="Gender" value="B" <cfif Gender EQ "B">checked</cfif> > Boys
				<input type="Radio" maxlength="1" name="Gender" value="G" <cfif Gender EQ "G">checked</cfif> > Girls
				</b>
			</TD>
		</TR>
		<TR><TD align="right"> #required# <b>Team Age Group</B></TD>
			<TD><SELECT  name="TeamAge"  > 
					<CFLOOP list="#lTeamAges#" index="ita">
						<OPTION value="#ita#" <CFIF TeamAge EQ ita>selected</CFIF>  >#ita#</OPTION>
					</CFLOOP>
				</SELECT>
			</TD>
		</tr>
		<tr><TD align="right">#required# <b>Play Level</b></TD>
			<TD><SELECT  name="PlayLevel"  >
				<CFLOOP list="#lPlayLevel#" index="ipl">
					<OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
				</CFLOOP>
				</SELECT>
				<span class="red"><u>(Flight 'X' is reserved for CUP divisional Play only)</u></span>
			</TD>
		</TR>
		<TR><TD align="right"><b>Division</b></TD>
			<TD>#Division#</TD>
		</TR>
		<TR><TD align="right">#required# <b>USSF Rgstd Div</b> </TD>
			<TD><SELECT  name="USSFDiv"  >
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF USSFDiv EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
				</SELECT>
			</td>
		</TR>
		<TR><TD align="right">#required# <b>Coach</b> </TD>
			<TD><SELECT name="HeadCoachID"  >
				<CFIF qOtherContacts.RECORDCOUNT>
					<CFLOOP query="qOtherContacts">
						<OPTION value="#contact_id#" <CFIF HeadCoachID EQ contact_id> selected </CFIF> > #LastNAme#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			    <!--- put in Coaches --->
				<CFIF qCoaches.RECORDCOUNT>
					<CFLOOP query="qCoaches" >
						<OPTION value="#contact_id#" <cfif HeadCoachID EQ contact_id> selected </cfif> >#LastName#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
				</SELECT>
			</TD>
		</TR>
		<TR><TD align="right"> <b>Asst.Coach</b> </TD>
			<TD><SELECT name="AsstCoachID"  > 
					<option value="0"> Select contact  </OPTION>
					<CFIF qOtherContacts.RECORDCOUNT>
						<CFLOOP query="qOtherContacts">
							<OPTION value="#contact_id#" <CFIF AsstCoachID EQ contact_id> selected </CFIF> > #LastNAme#, #FirstName#</OPTION>
						</CFLOOP>
					</CFIF>
				    <!--- put in Coaches --->
					<CFIF qCoaches.RECORDCOUNT>
						<CFLOOP query="qCoaches">
							<OPTION value="#contact_id#" <cfif AsstCoachID EQ contact_id> selected </cfif> >#LastName#, #FirstName#</OPTION>
						</CFLOOP>
					</CFIF>
				</SELECT>
			</TD>
		</TR>
		<tr><td align="right"> <b>Head Coach Second Team</b>	</TD>
			<TD><SELECT name="SecondTeam"  > 
					<OPTION value="" selected>Select</OPTION>
					<CFLOOP list="#lTeamAges#" index="ita">
						<OPTION value="#ita#" <CFIF SecondTeam EQ ita>selected</CFIF>  >#ita#</OPTION>
					</CFLOOP>
				</SELECT>
			</TD>
		</tr>
		<input type="Hidden" name="NonSundayPlay" value="">
		<!--- <CFIF SF EQ "SPRING">
			<tr><TD align="right"> Willing to play other than sunday? </TD>
				<TD><SELECT name="NonSundayPlay"  > 
						<OPTION value="Y" <CFIF NonSundayPlay EQ "Y">selected</CFIF> >Yes</OPTION>
						<OPTION value="N" <CFIF NonSundayPlay EQ "N">selected</CFIF> >No </OPTION>
					</SELECT>
				</td>
			</tr>
		<CFELSE>
			
		</CFIF> --->

		<TR><TD colspan="2" align="center">
			<hr size="1">
			 	<INPUT type="submit" name="Register" value="Register"> 
			</TD>
		</TR>
	</TABLE>
</CFIF>
 --->
</FORM>

</cfoutput>
</div>


<cfinclude template="_footer.cfm">



