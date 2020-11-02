<!--- 
	FileName:	approveReviewTeam.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

	01/05/09 - AA - made Asst coach not required.
	01/16/09 - AA - added logic to edit newReqDiv.
	02/11/09 - AA - Tkt:7168 - made ussf req div a required field
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfinclude template="_checkLogin.cfm">


<cfoutput>
	
<CFIF isDefined("SESSION.REGSEASON")>
	<CFSET displaySeason = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
	<CFSET SF = SESSION.REGSEASON.SF>
<CFELSE>
	<CFSET displaySeason = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
	<CFSET SF = SESSION.CURRENTSEASON.SF>
</CFIF>

<cfset messageTxt = "">

<CFIF isDefined("URL.cid") AND isNumeric(URL.cid)>
	<CFSET clubID = URL.cid>
<CFELSEIF isDefined("FORM.CLUBID")>
	<CFSET clubID = FORM.CLUBID>
<CFELSE>
	<CFSET clubID = "">
</CFIF>

<CFIF isDefined("URL.tid") AND isNumeric(URL.tid)>
	<CFSET teamID = URL.tid>
<CFELSEIF isDefined("FORM.TEAMID")>
	<CFSET teamID = FORM.TEAMID>
<CFELSE>
	<CFSET teamID = "">
</CFIF>


<CFIF isDefined("FORM.REGISTER")> <!--- === Start processing form.register === --->
	<cfset swContinue = true>
	<CFSET ClubId			= FORM.ClubID>
	<CFSET TeamId			= FORM.TeamID>
	<CFSET HeadCoachID		= FORM.NEW_HeadCoachID>
	<CFSET AsstCoachID 		= FORM.NEW_AsstCoachID>
	<CFSET Asst2CoachID 	= FORM.NEW_Asst2CoachID>
	<CFSET Asst3CoachID 	= FORM.NEW_Asst3CoachID>
	<CFSET ORIG_TeamAge		= FORM.ORIG_TeamAge>
	<CFSET ORIG_PlayLevel	= FORM.ORIG_PlayLevel>
	<CFSET ORIG_REQDIV		= FORM.ORIG_REQDIV>
	<CFSET ORIG_USSFDiv		= FORM.ORIG_USSFDiv>
	<CFSET ORIG_Gender		= FORM.ORIG_Gender>
	<CFSET ORIG_HeadCoachId = FORM.ORIG_HeadCoachId>
	<CFSET ORIG_AsstCoachId = FORM.ORIG_AsstCoachId>
	<CFSET ORIG_Asst2CoachId = FORM.ORIG_Asst2CoachId>
	<CFSET ORIG_Asst3CoachId = FORM.ORIG_Asst3CoachId>

	<cfif len(trim(FORM.USSFDiv))>
		<CFSET USSFDiv			= FORM.USSFDiv>
	<cfelse>
		<cfset swContinue = false>
		<cfset messageTxt = messageTxt & "<br>USSF Rgstd Div is Required.">
	</cfif>	
	<cfif len(trim(FORM.TeamAge))>
		<CFSET TeamAge			= FORM.TeamAge>
	<cfelse>
		<cfset swContinue = false>
		<cfset messageTxt = messageTxt & "<br>Team Age Group is Required.">
	</cfif>	
	<cfif len(trim(FORM.PlayLevel))>
		<CFSET PlayLevel		= FORM.PlayLevel>
	<cfelse>
		<cfset swContinue = false>
		<cfset messageTxt = messageTxt & "<br>Play Level is Required.">
	</cfif>	
	<cfif len(trim(FORM.Gender))>
		<CFSET Gender			= FORM.Gender>
	<cfelse>
		<cfset swContinue = false>
		<cfset messageTxt = messageTxt & "<br>Gender is Required.">
	</cfif>	

	<!--- <CFSET Comments			= FORM.Comments> --->
	<!--- <CFSET SecondTeam		= FORM.SecondTeam> --->
	<!--- <CFSET CoachingPgm		= FORM.CoachingPgm> --->
	<CFSET NonSundayPlay	= FORM.NonSundayPlay>
	<CFSET newReqDiv = FORM.RD1 & FORM.RD2 & FORM.RD3 >
	<!--- new[#newReqDiv#] orig[#ORIG_REQDIV#] --->

	


	<cfif swContinue>
		<cfif (ORIG_TeamAge NEQ TeamAge) 
		   OR (ORIG_PlayLevel NEQ PlayLevel) 
		   OR (ORIG_REQDIV NEQ newReqDiv) 
		   OR (ORIG_USSFDiv NEQ USSFDiv) 
		   OR (ORIG_Gender NEQ Gender) 
		   OR (ORIG_HeadCoachId NEQ HeadCoachID) 
		   OR (ORIG_AsstCoachId NEQ AsstCoachID) 
		   OR (ORIG_Asst2CoachId NEQ Asst2CoachID)
		   OR (ORIG_Asst3CoachId NEQ Asst3CoachID)>
			<CFSET swValueChanged = "Y" >
		<cfelse>
			<CFSET swValueChanged = "N" >
		</cfif>
		<!--- <CFSET Comments	= Replace(Comments,"'","''","ALL")> --->
	
		
		<!--- <cfif IsDefined("SESSION.GLOBALVARS.RegOpen") AND SESSION.GLOBALVARS.RegOpen EQ "OPEN">
			<CFSET RequestedDiv = "'" & trim(Gender) & mid(trim(teamage), 2, 2) & Trim(Playlevel) & "'">
		<cfelse>
			<CFSET RequestedDiv = "RequestedDiv">
		</cfif> --->
		
		<CFSET CurTime = timeFormat(Now(),"hh:mm:sstt")>
		<!--- Set DataAccess = New FileAccess ????????????? --->
		<cfif swValueChanged EQ "Y">
			<!---  values were changed, check if team is duped, etc..... --->
			<!--- Does the coach exist for this season???? --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="ContactExist" returnvariable="coachExist">
				<cfinvokeargument name="contactid" value="#HeadCoachID#">
				<cfinvokeargument name="roleid"    value="#SESSION.CONSTANT.ROLEIDCOACH#">
				<cfinvokeargument name="clubid"    value="#ClubId#">
				<cfinvokeargument name="seasonid"  value="#SESSION.REGSEASON.ID#">
			</cfinvoke>
			<CFIF coachExist.recordCount EQ 0>
				<!--- no match, so create role for headcoach for this season... --->
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="insertContactRole">
					<cfinvokeargument name="contactID"   value="#HeadCoachID#">
					<cfinvokeargument name="roleID" 	 value=#SESSION.CONSTANT.ROLEIDCOACH#>
					<cfinvokeargument name="ClubId" 	 value="#ClubId#">
					<cfinvokeargument name="seasonID"    value="#SESSION.REGSEASON.ID#">
					<cfinvokeargument name="activeYN"	 value="Y">
					<cfinvokeargument name="allowGameEdit" value="0">
				</cfinvoke>
			</CFIF>
			
			<!--- Does the ASST coach exist for this season???? --->
			<CFIF AsstCoachID GT 0>
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="ContactExist" returnvariable="asstExist">
					<cfinvokeargument name="contactid" value="#AsstCoachID#">
					<cfinvokeargument name="roleid"    value="#SESSION.CONSTANT.ROLEIDCOACH#">
					<cfinvokeargument name="clubid"    value="#ClubId#">
					<cfinvokeargument name="seasonid"  value="#SESSION.REGSEASON.ID#">
				</cfinvoke>
				<CFIF asstExist.recordCount EQ 0>
					<!--- no match, so create role for headcoach for this season... --->
					<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="insertContactRole">
						<cfinvokeargument name="contactID"   value="#AsstCoachID#">
						<cfinvokeargument name="roleID" 	 value="#SESSION.CONSTANT.ROLEIDCOACH#">
						<cfinvokeargument name="ClubId" 	 value="#ClubId#">
						<cfinvokeargument name="seasonID"    value="#SESSION.REGSEASON.ID#">
						<cfinvokeargument name="activeYN"	 value="Y">
						<cfinvokeargument name="allowGameEdit" value="0">
					</cfinvoke>
				</CFIF>
			</CFIF>

			<CFIF Asst2CoachID GT 0>
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="ContactExist" returnvariable="asst2Exist">
					<cfinvokeargument name="contactid" value="#Asst2CoachID#">
					<cfinvokeargument name="roleid"    value="#SESSION.CONSTANT.ROLEIDCOACH#">
					<cfinvokeargument name="clubid"    value="#ClubId#">
					<cfinvokeargument name="seasonid"  value="#SESSION.REGSEASON.ID#">
				</cfinvoke>
				
				<CFIF asst2Exist.recordCount EQ 0>
					<!--- no match, so create role for headcoach for this season... --->
					<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="insertContactRole">
						<cfinvokeargument name="contactID"   value="#Asst2CoachID#">
						<cfinvokeargument name="roleID" 	 value="#SESSION.CONSTANT.ROLEIDCOACH#">
						<cfinvokeargument name="ClubId" 	 value="#ClubId#">
						<cfinvokeargument name="seasonID"    value="#SESSION.REGSEASON.ID#">
						<cfinvokeargument name="activeYN"	 value="Y">
						<cfinvokeargument name="allowGameEdit" value="0">
					</cfinvoke>
				</CFIF>
			</CFIF>

			<CFIF Asst3CoachID GT 0>
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="ContactExist" returnvariable="asst3Exist">
					<cfinvokeargument name="contactid" value="#Asst3CoachID#">
					<cfinvokeargument name="roleid"    value="#SESSION.CONSTANT.ROLEIDCOACH#">
					<cfinvokeargument name="clubid"    value="#ClubId#">
					<cfinvokeargument name="seasonid"  value="#SESSION.REGSEASON.ID#">
				</cfinvoke>
				<CFIF asst3Exist.recordCount EQ 0>
					<!--- no match, so create role for headcoach for this season... --->
					<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="insertContactRole">
						<cfinvokeargument name="contactID"   value="#Asst3CoachID#">
						<cfinvokeargument name="roleID" 	 value="#SESSION.CONSTANT.ROLEIDCOACH#">
						<cfinvokeargument name="ClubId" 	 value="#ClubId#">
						<cfinvokeargument name="seasonID"    value="#SESSION.REGSEASON.ID#">
						<cfinvokeargument name="activeYN"	 value="Y">
						<cfinvokeargument name="allowGameEdit" value="0">
					</cfinvoke>
				</CFIF>
			</CFIF>

				
			<CFQUERY name="teamCount" datasource="#SESSION.DSN#">
				SELECT COUNT(*) as numberOfTeams
				  FROM tbl_team T	
				 WHERE t.club_ID    = #VARIABLES.clubID#
				   AND T.season_id  = #SESSION.REGSEASON.ID#
				   AND T.teamAge    = '#VARIABLES.TeamAge#'
				   AND T.playLevel  = '#VARIABLES.PlayLevel#'
				   AND T.gender     = '#VARIABLES.Gender#'
				   AND T.USSFDiv    = '#VARIABLES.USSFDiv#'
				   AND T.RequestDiv = '#VARIABLES.newReqDiv#'
				   AND T.ContactIDHead = #VARIABLES.HeadCoachID#
				   AND T.ContactIDAsst = #VARIABLES.AsstCoachID#
			</CFQUERY>
			<!--- <cfdump var="#teamCount#"> --->
			<!--- <cfdump var="#teamCount.numberOfTeams#"> --->
			<CFIF teamCount.numberOfTeams EQ 0>
				<!--- this team combination does not exist so change is OK.... --->
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#team" method="updateRegTeam">
					<cfinvokeargument name="updContactID" value="#SESSION.USER.CONTACTID#">
					<cfinvokeargument name="TeamAge"      value="#VARIABLES.TeamAge#">
					<cfinvokeargument name="USSFDiv"      value="#VARIABLES.USSFDiv#">
					<cfinvokeargument name="PlayLevel"    value="#VARIABLES.PlayLevel#">
					<cfinvokeargument name="Gender"       value="#VARIABLES.Gender#">
					<cfinvokeargument name="HeadCoachID"  value="#VARIABLES.HeadCoachID#">
					<cfinvokeargument name="AsstCoachID"  value="#VARIABLES.AsstCoachID#">
					<cfinvokeargument name="Asst2CoachID"  value="#VARIABLES.Asst2CoachID#">
					<cfinvokeargument name="Asst3CoachID"  value="#VARIABLES.Asst3CoachID#">
					<cfinvokeargument name="nonSundayPlay" value="#VARIABLES.NonSundayPlay#">
					<cfinvokeargument name="TeamID"       value="#VARIABLES.TeamId#">
					<cfinvokeargument name="ReqDiv"       value="#VARIABLES.newReqDiv#">
				</cfinvoke>
	
				<!--- UPDATE TEAMNAME -- since coach can change --->
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#team" method="updateTeamName">
					<cfinvokeargument name="TeamID"       value="#VARIABLES.TeamId#">
				</cfinvoke>
			<CFELSE>
				<cflocation url="approveTeamNewSeason.cfm?cid=#clubID#">
			</CFIF>			
		<cfelse>
			<!--- nothing changed, team only needs to be approved...... --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#team" method="approveTeam">
				<cfinvokeargument name="updContactID" value="#SESSION.USER.CONTACTID#">
				<cfinvokeargument name="TeamID"       value="#VARIABLES.TeamId#">
			</cfinvoke>
		</cfif>
		
		<CFQUERY name="getTeamAge" datasource="#SESSION.DSN#">
			Select TeamAge 
			  from TBL_TEAM
			 Where Club_ID = #VARIABLES.ClubID#
			   and Registered_yn = 'Y'
			   and Season_ID  = #SESSION.REGSEASON.ID#
		</CFQUERY>	
	
		<CFSET TotalU10YoungerTeams = 0 >
		<CFSET Total11Thru14Teams	= 0 >
		<CFSET Total15thru19Teams	= 0 >
		
		<CFLOOP query="getTeamAge">
			<CFSET TAge = Trim(Right(TeamAge, 2))>
			
			<cfif TAge LE 10>
				<CFSET TotalU10YoungerTeams = TotalU10YoungerTeams + 1	>
			<cfelse>												
				<cfif TAge LE 14>
					<CFSET Total11Thru14Teams = Total11Thru14Teams + 1	>
				<cfelse>										
					<CFSET Total15thru19Teams = Total15thru19Teams + 1	>
				</cfif>
			</cfif>
		</CFLOOP>
		
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="updateClubTeamCounts">
			<cfinvokeargument name="TotalU10YoungerTeams" value="#VARIABLES.TotalU10YoungerTeams#">
			<cfinvokeargument name="Total11Thru14Teams"   value="#VARIABLES.Total11Thru14Teams#">
			<cfinvokeargument name="Total15thru19Teams"   value="#VARIABLES.Total15thru19Teams#">
			<cfinvokeargument name="updContactID" value="#SESSION.USER.CONTACTID#">
			<cfinvokeargument name="seasonID"     value="#SESSION.REGSEASON.ID#">
			<cfinvokeargument name="clubID"       value="#VARIABLES.clubId#">
		</cfinvoke>
	
		<cflocation url="approveTeamNewSeason.cfm?cid=#clubID#">
	
	</cfif>
		
</CFIF> <!--- === END processing FOMR.Register=== --->



<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="getRegisteredTeams" returnvariable="RegTeam">
	<cfinvokeargument name="ClubId" value="#VARIABLES.clubId#">
	<cfinvokeargument name="TeamId" value="#VARIABLES.teamId#">
</cfinvoke>  

<CFSET ClubName			= RegTeam.CLUB_NAME>
<CFSET TeamId			= RegTeam.Team_ID>
<CFSET TeamAge			= RegTeam.TeamAge>
<CFSET PlayLevel		= RegTeam.PlayLevel>
<CFSET Division			= RegTeam.Division>

<CFSET REQDIV			= RegTeam.RequestDiv>

<CFSET USSFDiv			= RegTeam.USSFDiv>
<CFSET Gender			= RegTeam.Gender>
<!--- <CFSET Comments			= RegTeam.Comments> --->
<CFSET ORIG_HeadCoachId = RegTeam.ContactIDHead>
<CFSET ORIG_AsstCoachId = RegTeam.ContactIDAsst>
<CFSET ORIG_Asst2CoachId = RegTeam.ContactIDAsst2>
<CFSET ORIG_Asst3CoachId = RegTeam.ContactIDAsst3>

<!--- <CFSET SecondTeam		= RegTeam.SecondTeam> --->
<CFSET NonSundayPlay	= RegTeam.NonSundayPlay>

<!--- <CFIF RegTeam.Gender EQ "B">
	<CFSET GenderBoys  = "checked">
	<CFSET GenderGirls = "">
<CFELSEIF RegTeam.Gender EQ "G">
	<CFSET GenderBoys  = "">
	<CFSET GenderGirls = "checked">
<CFELSE>
	<CFSET GenderBoys  = "">
	<CFSET GenderGirls = "">
</CFIF> --->


<cfinvoke component="#SESSION.SITEVARS.cfcpath#contact" method="getClubContactRoleX" returnvariable="qCoaches">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubID#"> 
	<cfinvokeargument name="roleID" value="#SESSION.CONSTANT.RoleIDcoach#"> 
</cfinvoke> <!--- rs2 --->

<!--- <cfset lCoachesID = valueList(qCoaches.contact_id)> --->

<CFQUERY name="qOtherContacts" datasource="#SESSION.DSN#">
	SELECT c.contact_id, c.FirstName, c.lastName
	  FROM TBL_CONTACT c INNER JOIN XREF_CONTACT_ROLE X on x.CONTACT_ID = c.CONTACT_ID
	 WHERE c.CLUB_ID = #VARIABLES.ClubId#
	   AND c.CONTACT_ID NOT IN (#valueList(qCoaches.contact_id)#)
	  group by c.contact_id, c.FirstName, c.lastName
</CFQUERY> <!--- rs3 --->

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES"> 
</cfinvoke> <!--- lTeamAges --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL"> 
</cfinvoke> <!--- lPlayLevel --->


<div id="contentText">
<H1 class="pageheading">NCSA - Review & Accept Team Registration for #displaySeason#</H1>
<br>
<h2>For #VARIABLES.ClubName# </h2>
<FORM name="CoachesMaintain" action="ApproveReviewTeam.cfm"  method="post">
	<input type="hidden" name="TeamID" 		 	 value="#VARIABLES.TeamID#">
	<input type="hidden" name="ClubId"			 value="#VARIABLES.ClubId#">
	<input type="hidden" name="CurrentPage" 	 value=0>	
	<input type="hidden" name="ORIG_TeamAge"	 value="#VARIABLES.TeamAge#">
	<input type="hidden" name="ORIG_PlayLevel"	 value="#VARIABLES.PlayLevel#">
	<input type="hidden" name="ORIG_Division"	 value="#VARIABLES.Division#">
	<input type="hidden" name="ORIG_REQDIV"	 	 value="#VARIABLES.REQDIV#">
	<input type="hidden" name="ORIG_USSFDiv"	 value="#VARIABLES.USSFDiv#">
	<input type="hidden" name="ORIG_Gender"		 value="#VARIABLES.Gender#">
	<input type="hidden" name="ORIG_HeadCoachId" value="#VARIABLES.ORIG_HeadCoachId#">
	<input type="hidden" name="ORIG_AsstCoachId" value="#VARIABLES.ORIG_AsstCoachId#">
	<input type="hidden" name="ORIG_Asst2CoachId" value="#VARIABLES.ORIG_Asst2CoachId#">
	<input type="hidden" name="ORIG_Asst3CoachId" value="#VARIABLES.ORIG_Asst3CoachId#">
<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">
<table cellspacing="0" cellpadding="5" align="left" border="0" width="90%">
	<tr class="tblHeading">
		<TD colspan="2">Team Info:</TD>
	</tr>
	<CFIF len(trim(messageTXT))>
		<TR><TD colspan="2" align="Center">
				<span class="red">#VARIABLES.messageTxt#</span>
			</TD>
		</TR>
	</CFIF>
	<TR><TD width="40%" align="right"><b>Team ID</B></TD>
		<TD width="60%">&nbsp; #VARIABLES.TeamID#</TD>
	</TR>
	<TR>
		<TD align="right"> #required# <b>Team Age Group</B></TD>
		<TD><SELECT  name="TeamAge"> 
				<OPTION value="" selected>Select</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF TeamAge EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
	</tr>
	<tr><TD align="right">#required# <b>Play Level</b></TD>
		<TD><SELECT  name="PlayLevel">
				<OPTION value="" selected>Select</OPTION>
				<CFLOOP list="#lPlayLevel#" index="ipl">
					<OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
				</CFLOOP>
			</SELECT>
		</TD>
	</TR>
	<TR><TD align="right">#required# <b>Gender</b>
		</TD>
		<TD><!--- <input  type="Radio" maxlength="1" name="Gender" value="B" #GenderBoys#> Boys
			<input  type="Radio" maxlength="1" name="Gender" value="G" #GenderGirls#> Girls --->
			<SELECT name="Gender">
				<OPTION value="B" <cfif VARIABLES.gender EQ "B">selected</cfif> > Boys </OPTION>
				<OPTION value="G" <cfif VARIABLES.gender EQ "G">selected</cfif> > Girls</OPTION>
			</SELECT>

		</TD>
	</TR>
	<TR><TD align="right"><b>Division</b></TD>
		<TD>#Division#</TD>
	</TR>
	
	
	<TR><TD align="right"><b>Requested Div</b></TD>
		<TD><cfset inRD1 = mid(REQDIV,1,1)> 
			<cfset inRD2 = mid(REQDIV,2,2)> 
			<cfset inRD3 = mid(REQDIV,4,1)> 
			<!--- #REQDIV#[#inRD1#][#inRD2#][#inRD3#] --->
			<SELECT  name="RD1"> <!--- gender --->
				<OPTION value="B" <cfif inRD1 EQ "B">selected</cfif> >B</OPTION>
				<OPTION value="G" <cfif inRD1 EQ "G">selected</cfif> >G</OPTION>
			</SELECT>
			<SELECT  name="RD2"> <!--- age --->
				<OPTION value="0" selected>Select</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita2">
					<OPTION value="#mid(ita2,2,2)#" <cfif inRD2 EQ mid(ita2,2,2)>selected</cfif> >#mid(ita2,2,2)#</OPTION>
				</CFLOOP>
			</SELECT>	
			<SELECT  name="RD3"> <!--- playlevel --->
				<OPTION value="0" selected>Select</OPTION>
				<CFLOOP list="#lPlayLevel#" index="ipl2">
					<OPTION value="#ipl2#" <cfif inRD3 EQ ipl2>selected</cfif>  >#ipl2#</OPTION>
				</CFLOOP>
			</SELECT>
		
		</TD>
	</TR>
	
	
	
	
	<TR><TD align="right">#required# <b>USSF Rgstd Div</b> </TD>
		<td><input  maxlength="4" name="USSFDiv" value="#USSFDiv#" > 	</td>
	</TR>
	<TR><TD align="right">#required# <b>Coach</b> </TD>
		<TD><SELECT name="NEW_HeadCoachID">
				<CFIF qOtherContacts.RECORDCOUNT>
					<CFLOOP query="qOtherContacts">
						<OPTION value="#contact_id#" <CFIF ORIG_HeadCoachID EQ contact_id> selected </CFIF> > #LastNAme#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			    <!--- put in Coaches --->
				<CFIF qCoaches.RECORDCOUNT>
					<CFLOOP query="qCoaches">
						<OPTION value="#contact_id#" <cfif ORIG_HeadCoachID EQ contact_id> selected </cfif> >#LastName#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			</SELECT>
		</TD>
	</TR>
	<TR><TD align="right"> <b>Asst.Coach</b> </TD><!--- #required# --->
		<TD><SELECT name="NEW_AsstCoachID" > 
				<option value="0"> Select contact  </OPTION>
				<CFIF qOtherContacts.RECORDCOUNT>
					<CFLOOP query="qOtherContacts">
						<OPTION value="#contact_id#" <CFIF ORIG_AsstCoachID EQ contact_id> selected </CFIF> > #LastNAme#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			    <!--- put in Coaches --->
				<CFIF qCoaches.RECORDCOUNT>
					<CFLOOP query="qCoaches">
						<OPTION value="#contact_id#" <cfif ORIG_AsstCoachID EQ contact_id> selected </cfif> >#LastName#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			</SELECT>
		</TD>
	</TR>

		<TR><TD align="right"> <b>2nd Asst.Coach</b> </TD><!--- #required# --->
		<TD><SELECT name="NEW_Asst2CoachID" > 
				<option value="0"> Select contact  </OPTION>
				<CFIF qOtherContacts.RECORDCOUNT>
					<CFLOOP query="qOtherContacts">
						<OPTION value="#contact_id#" <CFIF ORIG_Asst2CoachID EQ contact_id> selected </CFIF> > #LastNAme#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			    <!--- put in Coaches --->
				<CFIF qCoaches.RECORDCOUNT>
					<CFLOOP query="qCoaches">
						<OPTION value="#contact_id#" <cfif ORIG_Asst2CoachID EQ contact_id> selected </cfif> >#LastName#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			</SELECT>
		</TD>
	</TR>
	<TR><TD align="right"> <b>3rd Asst.Coach</b> </TD><!--- #required# --->
		<TD><SELECT name="NEW_Asst3CoachID" > 
				<option value="0"> Select contact  </OPTION>
				<CFIF qOtherContacts.RECORDCOUNT>
					<CFLOOP query="qOtherContacts">
						<OPTION value="#contact_id#" <CFIF ORIG_Asst3CoachID EQ contact_id> selected </CFIF> > #LastNAme#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			    <!--- put in Coaches --->
				<CFIF qCoaches.RECORDCOUNT>
					<CFLOOP query="qCoaches">
						<OPTION value="#contact_id#" <cfif ORIG_Asst3CoachID EQ contact_id> selected </cfif> >#LastName#, #FirstName#</OPTION>
					</CFLOOP>
				</CFIF>
			</SELECT>
		</TD>
	</TR>
		<!--- <CFIF SF EQ "SPRING">
			<tr><TD align="right"> Willing to play other than sunday? </TD>
				<TD><SELECT name="NonSundayPlay"> 
						<OPTION value="Y" <CFIF NonSundayPlay EQ "Y">selected</CFIF> >Yes</OPTION>
						<OPTION value="N" <CFIF NonSundayPlay EQ "N">selected</CFIF> >No </OPTION>
					</SELECT>
				</td>
			</tr>
		<CFELSE> --->
	<input type="Hidden" name="NonSundayPlay" value="">
		<!--- </CFIF> --->

	<TR><TD colspan="2" align="center">
			<hr size="1">
			<INPUT type="submit" name="Register" value="Approve">
			<INPUT type="button" name="Back"   value="Back" onclick="history.go(-1)">
			</TD>
		</TR>
	</TABLE>
</FORM>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
