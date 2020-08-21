<!---
	FileName:	teamCreate.cfm
	Created on: 09/18/2008
	Created by: aarnone@capturepoint.com

	Purpose: [purpose of the file]

MODS: mm/dd/yyyy - filastname - comments
02/04/09 - aa - #7168 fixed issue with field's defaulted values. If user submitted w/o changing values then all teams will
				show up on flighting page having u07 as the ussfdiv. Changed to default to "Select" on startup.
02/05/09 - aa - #7168 changed the Gender radio buttons to a dropdown list.
7/14/2010 B. Cooper
7405 - added auto-approve flag
 --->

<cfset mid = 0> <!--- optional =menu id --->
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">

<CFIF isDefined("URL.cid")>
	<CFSET clubID = URL.cid>
<CFELSEIF isDefined("FORM.CLUBID")>
	<CFSET clubID = FORM.CLUBID>
<CFELSEIF isDefined("SESSION.USER.CLUBID")>
	<CFSET clubID = SESSION.USER.CLUBID>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>


<CFIF isDefined("SESSION.REGSEASON")>
	<CFSET displaySeason = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
	<CFSET SF = SESSION.REGSEASON.SF>
	<CFSET seasonID = SESSION.REGSEASON.ID>
<CFELSE>
	<CFSET displaySeason = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
	<CFSET SF = SESSION.CURRENTSEASON.SF>
	<CFSET seasonID = SESSION.CURRENTSEASON.ID>
</CFIF>

<CFSET errMessage = "">
<CFSET swDisable = false>
<CFSET swDelete  = false>

<CFIF isDefined("URL.a") AND URL.A EQ "del">
	<CFSET swDisable = TRUE>
	<CFSET swDelete  = TRUE>
	<CFSET errMessage = "<b>Are you sure you want to delete this team? </b>">
</CFIF>


<CFIF isDefined("FORM.DELETE")>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#team" method="deleteTeam">
		<cfinvokeargument name="teamID"   value="#FORM.TEAMID#">
	</cfinvoke>
	<CFLOCATION url="regTeamList.cfm">
</CFIF>

<cfif isDefined("FORM.TeamAge")>
	<cfset TeamAge = FORM.TeamAge >
<cfelse>
	<CFSET TeamAge	= "">
</cfif>
<cfif isDefined("FORM.PlayLevel")>
	<cfset PlayLevel = FORM.PlayLevel >
<cfelse>
	<CFSET PlayLevel = "">
</cfif>
<cfif isDefined("FORM.Division")>
	<cfset Division = FORM.Division >
<cfelse>
	<CFSET Division	= "">
</cfif>
<cfif isDefined("FORM.USSFDiv")>
	<cfset USSFDiv = FORM.USSFDiv >
<cfelse>
	<CFSET USSFDiv	= "">
</cfif>
<cfif isDefined("FORM.Gender")>
	<cfset Gender = FORM.Gender >
<cfelse>
	<CFSET Gender	= "">
</cfif>
<cfif isDefined("FORM.HeadCoachId")>
	<cfset  HeadCoachId= FORM.HeadCoachId >
<cfelse>
	<CFSET HeadCoachId = "">
</cfif>
<cfif isDefined("FORM.AsstCoachId")>
	<cfset AsstCoachId = FORM.AsstCoachId >
<cfelse>
	<CFSET AsstCoachId = "">
</cfif>
<cfif isDefined("FORM.SecondTeam")>
	<cfset SecondTeam = FORM.SecondTeam >
<cfelse>
	<CFSET SecondTeam  = "">
</cfif>
<cfif isDefined("FORM.NonSundayPlay")>
	<cfset NonSundayPlay = FORM.NonSundayPlay >
<cfelse>
	<CFSET NonSundayPlay	= "N">
</cfif>
<!--- <cfif isDefined("FORM.GenderBoys")>
	<cfset GenderBoys = FORM.GenderBoys >
<cfelse>
	<CFSET GenderBoys  = "checked">
</cfif>
<cfif isDefined("FORM.GenderGirls")>
	<cfset GenderGirls = FORM.GenderGirls >
<cfelse>
	<CFSET GenderGirls = "">
</cfif> --->



<CFIF isDefined("FORM.REGISTER")>
	<cfset swRegister = true>

	<cfif len(trim(FORM.Gender))>
		<cfset Gender = FORM.Gender>
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> Gender is required." >
	</cfif>

	<cfif len(trim(FORM.TeamAge))>
		<cfset teamage = FORM.TeamAge>
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> Team Age is required." >
	</cfif>

	<cfif len(trim(FORM.PlayLevel))>
		<cfset PlayLevel = FORM.PlayLevel>
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> Play Level is required." >
	</cfif>

	<cfif len(trim(FORM.USSFDiv))>
		<cfset USSFDiv = FORM.USSFDiv>
	<cfelse>
		<cfset swRegister = false>
		<CFSET errMessage = errMessage & "<br> USSFDiv is required." >
	</cfif>

	<cfif isdefined("form.chkApproveOverride") AND form.chkApproveOverride EQ "1">
		<cfset teamApproved="Y">
	<cfelse>
		<cfset teamApproved="N">
	</cfif>

<!--- <cfdump var=#form#><cfabort> --->


	<cfif swRegister>
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
			<cfinvokeArgument name="PriorTeamID" 	value="#FORM.TeamID#">
			<cfinvokeargument name="approved" value="#teamApproved#">
		</CFINVOKE>
		<CFIF stRegTeam.swErr>
			<CFSET errMessage = errMessage & stRegTeam.MSG>
		<CFELSE>
			<CFLOCATION url="regTeamList.cfm?cid=#FORM.clubID#">
		</CFIF>
	</cfif>

</CFIF>

<H1 class="pageheading">NCSA - Add a Team</H1>
<br>
<h2>for #displaySeason# Season </h2>




<CFQUERY name="getClub" datasource="#SESSION.DSN#">
	SELECT CLUB_NAME
	  from TBL_CLUB
	 Where CLUB_ID = #VARIABLES.clubID#
</CFQUERY>
<CFSET ClubName	= getClub.CLUB_NAME>

<!--- <CFSET TeamId	= "">
<CFSET TeamAge	= "">
<CFSET PlayLevel = "">
<CFSET Division	= "">
<CFSET USSFDiv	= "">
<CFSET Gender	= "">
<CFSET HeadCoachId = "">
<CFSET AsstCoachId = "">
<CFSET SecondTeam  = "">
<CFSET NonSundayPlay	= "N">
<CFSET GenderBoys  = "checked">
<CFSET GenderGirls = "">
 --->


<CFIF isDefined("URL.tid")>
	<CFSET teamID = URL.tid>
<CFELSEIF isDefined("FORM.teamID")>
	<CFSET teamID = FORM.teamID>
<CFELSE>
	<CFSET teamID = 0>
</CFIF>


<!--- <cfdump var="#FORM#"><cfdump var="#URL#">
</cfoutput>  </div>  <cfinclude template="_footer.cfm">
<CFABORT><cfoutput> --->


<CFIF teamID GT 0>
	<CFINVOKE component="#SESSION.SITEVARS.cfcPath#team" method="getTeamInfo" returnvariable="qTeamInfo">
		<cfinvokeargument name="teamID" value="#VARIABLES.TeamID#">
	</CFINVOKE> <!--- <cfdump var="#qTeamInfo#"> --->

	<CFSET ClubName		= qTeamInfo.Club_name>
	<CFSET TeamId		= qTeamInfo.team_id>
	<CFSET TeamAge		= qTeamInfo.teamAge>
	<CFSET PlayLevel 	= qTeamInfo.playLevel>
	<CFSET Division		= qTeamInfo.DIVISION>
	<CFSET USSFDiv		= qTeamInfo.USSFDiv>
	<CFSET Gender		= qTeamInfo.gender>
	<CFSET HeadCoachId 	= qTeamInfo.ContactIDHead>
	<CFSET AsstCoachId 	= qTeamInfo.ContactIDAsst>
	<CFSET ORIG_HeadCoachId	 = qTeamInfo.ContactIDHead>
	<CFSET ORIG_AsstCoachId	 = qTeamInfo.ContactIDAsst>
	<CFSET NonSundayPlay	 = qTeamInfo.NonSundayPlay>

<!--- <cfoutput>SELECT TEAM_ID
		  FROM TBL_TEAM
		  WHERE club_id	   = #VARIABLES.clubID#
		    AND season_id  = #VARIABLES.seasonID#
		    AND upper(teamAge)    = '#ucase(VARIABLES.TeamAge)#'
		    AND upper(playLevel)  = '#ucase(VARIABLES.PlayLevel)#'
		    AND upper(gender)     = '#ucase(VARIABLES.Gender)#'
		    AND upper(USSFDiv)    = '#ucase(VARIABLES.USSFDiv)#'
		    AND ContactIDHead = '#VARIABLES.HeadCoachID#'
		    <cfif len(trim(VARIABLES.AsstCoachID))>
				AND ContactIDAsst = #VARIABLES.AsstCoachID#
			<cfelse>
				AND ( ContactIDAsst IS NULL
					OR ContactIDAsst = 0
					OR ContactIDAsst = ' '
					)
			</cfif></cfoutput><cfabort> --->
	<CFQUERY name="checkTeam" datasource="#SESSION.DSN#">
		SELECT TEAM_ID
		  FROM TBL_TEAM
		  WHERE club_id	   = #VARIABLES.clubID#
		    AND season_id  = #VARIABLES.seasonID#
		    AND upper(teamAge)    = '#ucase(VARIABLES.TeamAge)#'
		    AND upper(playLevel)  = '#ucase(VARIABLES.PlayLevel)#'
		    AND upper(gender)     = '#ucase(VARIABLES.Gender)#'
		    AND upper(USSFDiv)    = '#ucase(VARIABLES.USSFDiv)#'
		    AND ContactIDHead = '#VARIABLES.HeadCoachID#'
		    <cfif len(trim(VARIABLES.AsstCoachID))>
				AND ContactIDAsst = #VARIABLES.AsstCoachID#
			<cfelse>
				AND ( ContactIDAsst IS NULL
					OR ContactIDAsst = 0
					OR ContactIDAsst = ' '
					)
			</cfif>

	</CFQUERY> <!--- 	<cfdump var="#checkTeam#"> --->

	<CFIF checkTeam.RECORDCOUNT>
		<CFSET errMessage = errMessage & "<B>This team has already been registered.</B>">
		<CFSET swDisable = true>
	</CFIF>

	<!--- <CFIF Gender EQ "B">
		<CFSET GenderBoys  = "checked">
		<CFSET GenderGirls = "">
	<CFELSEIF Gender EQ "G">
		<CFSET GenderBoys  = "">
		<CFSET GenderGirls = "checked">
	<CFELSE>
		<CFSET GenderBoys	= "">
		<CFSET GenderGirls	= "">
	</CFIF> --->

	<!--- if coach found, get secondTeam
	<CFSET SecondTeam  	= ""> --->


</CFIF>




<cfinvoke component="#SESSION.SITEVARS.cfcpath#contact" method="getClubContactRoleX" returnvariable="qCoaches">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
	<cfinvokeargument name="roleID" value="#SESSION.CONSTANT.RoleIDcoach#">
</cfinvoke> <!--- rs2 --->

<cfif qCoaches.recordCount>
	<cfset lCoachesID = valueList(qCoaches.contact_id)>
<cfelse>
	<cfset lCoachesID = 0>
</cfif>
<!--- <cfset lCoachesID = valueList(qCoaches.contact_id)> --->

<CFQUERY name="qOtherContacts" datasource="#SESSION.DSN#">
	SELECT c.contact_id, c.FirstName, c.lastName
	  FROM TBL_CONTACT c
	 WHERE c.CLUB_ID = #VARIABLES.ClubId#
	   AND c.CONTACT_ID NOT IN (#lCoachesID#)
</CFQUERY> <!--- rs3 --->

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES">
</cfinvoke> <!--- lTeamAges --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL">
</cfinvoke> <!--- lPlayLevel --->








<FORM name="CoachesMaintain" action="teamCreate.cfm"  method="post">
	<input type="hidden" name="ClubId"			 value="#VARIABLES.ClubId#">
	<input type="hidden" name="TeamID"		value="#TeamId#">
<!--- 	<input type="hidden" name="CurrentPage" 	 value=0>
	<input type="hidden" name="Mode"		value="<%=Mode%>">
	<input type="hidden" name="ClubID"		value="#ClubId#"> --->
<!--- 	<input type="hidden" name="ClubInfoId"	value="<%=ClubInfoId%>">
	<input type="hidden" name="RegSubmit"	value="<%=RegSubmit%>">
	<input type="hidden" name="InfoUpdated" value="<%=InfoUpdated%>">
	<input type="hidden" name="CurrentPage" value=0>
 --->
<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">
<table cellspacing="0" cellpadding="5" align="left" border="0" width="90%">

	<tr class="tblHeading">
		<TD colspan="2">Team Info for #VARIABLES.clubName#:</TD>
	</tr>
		<cfif len(Trim(errMessage))>
			<TR><TD colspan="3" align="Center" class="red">
					#errMessage#
				</td>
			</TR>
		</cfif>
	<TR><TD align="right">#required# <b>Gender</b>
		</TD>
		<TD>	<!--- <b>
				<input type="Radio" maxlength="1" name="Gender" value="B" #GenderBoys#  <cfif swDisable>disabled</cfif> > Boys
				<input type="Radio" maxlength="1" name="Gender" value="G" #GenderGirls# <cfif swDisable>disabled</cfif> > Girls
				</b> --->
			<SELECT  name="Gender" <cfif swDisable>disabled</cfif> >
				<OPTION value="" > Select </OPTION>
				<OPTION value="B" <CFIF gender EQ "B">selected</CFIF> > Boys  </OPTION>
				<OPTION value="G" <CFIF gender EQ "G">selected</CFIF> > Girls </OPTION>
			</SELECT>
		</TD>

	</TR>
	<TR>
		<TD align="right"> #required# <b>Team Age Group</B></TD>
		<TD><SELECT  name="TeamAge" <cfif swDisable>disabled</cfif> >
				<OPTION value="" >Select</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF TeamAge EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
	</tr>
	<tr><TD align="right">#required# <b>Play Level</b></TD>
		<TD><SELECT  name="PlayLevel" <cfif swDisable>disabled</cfif> >
				<OPTION value="" >Select</OPTION>
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
		<TD><SELECT  name="USSFDiv" <cfif swDisable>disabled</cfif> >
				<OPTION value="" >Select</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF USSFDiv EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>
		</td>
	</TR>
	<TR><TD align="right">#required# <b>Coach</b> </TD>
		<TD><SELECT name="HeadCoachID" <cfif swDisable>disabled</cfif> >
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
		<TD><SELECT name="AsstCoachID" <cfif swDisable>disabled</cfif> >
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
		<TD><SELECT name="SecondTeam" <cfif swDisable>disabled</cfif> >
				<OPTION value="" selected>Select</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF SecondTeam EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
	</tr>
	<cfif isdefined("roleid") AND roleid EQ 1>
		<tr><td align="right"> <b>Also Automatically Approve(Check if Yes)</b>	</TD>
			<TD>
				<input type="Checkbox" name="chkApproveOverride" value="1" checked="checked">
			</TD>
		</tr>
	</cfif>
	<input type="Hidden" name="NonSundayPlay" value="">
	<!--- <CFIF SF EQ "SPRING">
		<tr><TD align="right"> Willing to play other than sunday? </TD>
			<TD><SELECT name="NonSundayPlay" <cfif swDisable>disabled</cfif> >
					<OPTION value="Y" <CFIF NonSundayPlay EQ "Y">selected</CFIF> >Yes</OPTION>
					<OPTION value="N" <CFIF NonSundayPlay EQ "N">selected</CFIF> >No </OPTION>
				</SELECT>
			</td>
		</tr>
	<CFELSE>

	</CFIF> --->

	<TR><TD colspan="2" align="center">
			<hr size="1">
			<cfif swDisable>
				&nbsp; &nbsp; &nbsp;
			<cfelse>
				&nbsp; &nbsp;
				<INPUT type="submit" name="Register" value="Register">
			</cfif>
			<CFIF swDelete>
				&nbsp; &nbsp;
				<INPUT type="submit" name="DELETE" value="Delete">
			</CFIF>
			&nbsp; &nbsp;
			<INPUT type="button" name="Back"   value="Back" onclick="history.go(-1)">
			</TD>
		</TR>
	</TABLE>
</FORM>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
