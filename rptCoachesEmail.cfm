<!--- 
	FileName:	rptCoachesEmail.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	As of 2/6/09: we have 2 reports in 1
		Coaches Email Reoprt
			accessed by:	board only 
			shows: 			Flight - Team - Coaches - Email
			produces:		a list of eamil addresses
		Coaches Contact Info Report
			accessed by:	board, clubs and refs, 
			Shows: 			Flight - Team - Coaches - Email - AND PHONE numbers
			produces:		DOES NOT produces a list of eamil addresses
	
MODS: mm/dd/yyyy - filastname - comments

--->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">

<CFIF isDefined("URL.PN")>
	<CFSET swShowPhone = true>
<cfelseif isDefined("FORM.swShowPhone")>
	<CFSET swShowPhone = FORM.swShowPhone>
<cfelse>
	<CFSET swShowPhone = false>
</CFIF>

<cfset roleID = SESSION.CONSTANT.ROLEIDCOACH>

<cfif swShowPhone>
	<cfset headingText = "Coaches Contact Info Report">
<cfelse>
	<cfset headingText = "Coaches Email Report">
</cfif>


<H1 class="pageheading">NCSA - #headingText#</H1>
<!--- <br><h2>yyyyyy </h2> 
<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">--->


<CFIF isDefined("FORM.clubSelected")>
	<CFSET clubSelected = FORM.clubSelected >
<CFELSE>
	<CFSET clubSelected = 0 >
</CFIF>
<CFIF isDefined("FORM.CoachSelected")>
	<CFSET CoachSelected = FORM.CoachSelected >
<CFELSE>
	<CFSET CoachSelected = "" >
</CFIF>
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
<CFIF isDefined("FORM.workingSeason")>
	<cfset workingSeason = trim(FORM.workingSeason)>
<CFELSE>
	<cfset workingSeason = "">
</CFIF>

<CFQUERY name="qClubs" datasource="#SESSION.DSN#">
	SELECT club_id, Club_name 
      FROM  tbl_club 
	 ORDER BY CLUB_NAME
</CFQUERY>

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

<FORM name="teamID" action="rptCoachesEmail.cfm" method="post">
<input type="Hidden" name="swShowPhone" value="#VARIABLES.swShowPhone#">
<table cellspacing="0" cellpadding="3" align="center" border="0" width="99%">
	<TR><TD valign="bottom" colspan="2">
			<cfif listFind(SESSION.CONSTANT.CUROLES, SESSION.MENUROLEID) GT 0>
				&nbsp; 
				<input type="Hidden" name="Clubselected" value="#SESSION.USER.CLUBID#"> 
			<cfelse><!--- admin/board let them choose a club --->
				<b>Club:</b>
				<Select name="Clubselected">
					<option value="0">All Clubs</option>
					<CFLOOP query="qClubs">
						<option value="#CLUB_ID#" <CFIF CLUB_ID EQ VARIABLES.clubSelected>selected</CFIF> >#CLUB_NAME#</option>
						<CFIF CLUB_ID EQ VARIABLES.clubSelected><cfset clubname = CLUB_NAME></CFIF>
					</CFLOOP>
				</SELECT>
			</cfif>

			<b>Season:</b>	
				<SELECT name="workingSeason" >
					<CFLOOP query="qWorkingSeasons">
						<CFSET curr = "">
						<CFSET reg = "">
						<CFIF CURRENTSEASON_YN EQ 'Y'>
							<CFSET curr = "(current)">
						</CFIF> 
						<CFIF REGISTRATIONOPEN_YN EQ 'Y'>
							<CFSET reg = "(registration)">
						</CFIF> 
						<option value="#season_id#" <cfif VARIABLES.workingSeason EQ season_id>selected</cfif> >#SEASON_YEAR# #SEASON_SF# #curr# #reg# </option>
					</CFLOOP>
				</SELECT>
		</td>
	</TR>
	
	<TR><TD><b>Team Age:</b>
			<SELECT  name="TeamAgeSelected" >
				<OPTION value="">All</OPTION>
				<CFLOOP list="#lTeamAges#" index="ita">
					<OPTION value="#ita#" <CFIF VARIABLES.TeamAgeSelected EQ ita>selected</CFIF>  >#ita#</OPTION>
				</CFLOOP>
			</SELECT>
		
		<b>Level:</b> 
			<SELECT  name="PlayLevel">
				<OPTION value="" selected>All</OPTION>
				<CFLOOP list="#lPlayLevel#" index="ipl">
					<OPTION value="#ipl#" <CFIF PlayLevel EQ ipl>selected</CFIF> >#ipl#</OPTION>
				</CFLOOP>
			</SELECT>
		
		<b>Gender:</b>	
			<SELECT  name="BGSelected" >
				<OPTION value="">Both </OPTION>
				<OPTION value="B" <CFIF VARIABLES.BGSelected EQ "B">selected</CFIF> >Boys</OPTION>
				<OPTION value="G" <CFIF VARIABLES.BGSelected EQ "G">selected</CFIF> >Girls</OPTION>
			</SELECT>
		
		</td>
		<TD valign="bottom" align="right">
			<b>Coaches:</b>
			<SELECT  name="CoachSelected" >
				<OPTION value="ALL">ALL Coaches</OPTION>
				<OPTION value="HEAD" <CFIF VARIABLES.CoachSelected EQ "HEAD">selected</CFIF> >Head Coaches Only</OPTION>
				<OPTION value="ASST" <CFIF VARIABLES.CoachSelected EQ "ASST">selected</CFIF> >Asst Coaches Only</OPTION>
			</SELECT>

		<b>Sort By</b>
			<select name="sortOrder">
				<option value="FLIT" <cfif selectSort EQ "FLIT">selected</cfif> >Flight</option>
				<option value="TEAM" <cfif selectSort EQ "TEAM">selected</cfif> >Team Name</option>
				<option value="TID"  <cfif selectSort EQ "TID"> selected</cfif> >Team ID</option>
			</select>
		
			<INPUT type="Submit" name="getCoaches" value="Get Coaches">
		</TD>
	</TR>
</table>
</FORM>

<CFIF isDefined("FORM.GETCOACHES")>
	<cfquery name="qGetTeams" datasource="#SESSION.DSN#">
		SELECT T.team_id, T.teamAge, T.playLevel, T.playgroup, T.gender
			 , dbo.getTeamName(T.team_id) AS TEAMNAMEderived
			 , IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION
			 , T.CLUB_ID, T.ContactIDHead, T.ContactIDAsst 
			 , HC.FirstName AS HC_FirstName, HC.LastName AS HC_LastName, HC.email AS HC_Email
			 , HC.phoneWork AS HC_Work,      HC.phoneHome AS HC_Home,    HC.phoneCell AS HC_Cell, HC.phoneFax AS HC_Fax
			 , AC.FirstName AS AC_FirstName, AC.LastName AS AC_LastName, AC.email AS AC_Email 
 			 , AC.phoneWork AS AC_Work,      AC.phoneHome AS AC_Home,    AC.phoneCell AS AC_Cell, AC.phoneFax AS AC_Fax
		  FROM tbl_team T INNER JOIN tbl_club C         ON C.CLUB_ID = T.CLUB_ID
		                  INNER JOIN XREF_CLUB_SEASON X ON X.club_id = C.club_id 
		                                                AND X.SEASON_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.workingSeason#">
		                                                AND X.ACTIVE_YN = 'Y' 
							LEFT JOIN tbl_contact HC ON HC.contact_id = T.ContactIDHead 
							LEFT JOIN tbl_contact AC ON AC.contact_id = T.ContactIDAsst 
		 WHERE T.SEASON_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.workingSeason#">
		   AND T.Approved_YN = 'Y' 
			<cfif clubSelected GT 0>
   				AND T.club_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubSelected#">
   			</cfif>
			<cfif len(trim(VARIABLES.TeamAgeSelected)) GT 0>
				AND T.TEAMAGE = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.TeamAgeSelected#">
   			</cfif>
			<cfif len(trim(VARIABLES.BGSelected)) GT 0>
				AND T.GENDER = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.BGSelected#">
   			</cfif>
			<cfif len(trim(VARIABLES.PlayLevel)) GT 0>
				AND T.PLAYLEVEL = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.PlayLevel#">
   			</cfif>
		ORDER BY <cfif selectSort EQ "FLIT">
					DIVISION, TEAMNAMEderived
				<cfelse>	TEAMNAMEderived
				</cfif>		
	</cfquery> <!---  <cfdump var="#qGetTeams#"> --->
</CFIF>

	
<cfif isDefined("qGetTeams") AND qGetTeams.RECORDCOUNT>
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="100%">
		<tr><TD colspan="4">
				<b>Number of Teams: #qGetTeams.RECORDCOUNT# </b>
			</TD>
		</tr>
		<tr class="tblHeading">
			<TD width="05%">Flight</TD>
			<TD width="20%">Team</TD>
			<TD width="20%">Coaches</TD>
			<TD width="15%">Email</TD>
			<CFIF swShowPhone>
				<TD width="10%">C Phone</TD>
				<TD width="10%">H Phone</TD>
				<TD width="10%">W Phone</TD>
				<TD width="10%">F Phone</TD>
			</CFIF>
		</tr>
	</table>
	<cfset emaillist = "">	

	<div style="overflow:auto;height:300px;border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="2" align="left" border="0" width="99%">
		<CFLOOP query="qGetTeams">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
				<TD width="05%" valign="top" class="tdUnderLine">#DIVISION#</TD>
				<TD width="20%" valign="top" class="tdUnderLine">#TEAMNAMEderived#</TD>
				<TD width="20%" valign="top" class="tdUnderLine">
					<CFIF CoachSelected NEQ "ASST"> <!--- show ALL or HEAD only --->
						H: #trim(HC_FirstName)# #trim(HC_LastName)# &nbsp;
					</CFIF>
					<CFIF CoachSelected NEQ "HEAD"> <!--- show ALL or ASST only --->
						<CFIF CoachSelected EQ "ALL">  <!--- if ALL add break --->
							<br>
						</CFIF> 
						A:&nbsp; #trim(AC_FirstName)# #trim(AC_LastName)# &nbsp;
					</CFIF>
				</TD>
				<TD width="15%" valign="top" class="tdUnderLine">
					<CFIF CoachSelected NEQ "ASST"> <!--- show ALL or HEAD only --->
						<a href="mailto:#trim(HC_Email)#">#trim(HC_Email)#</a> &nbsp;
						<CFIF len(trim(HC_Email))>
							<cfset emailList = emailList & HC_Email & "; " > 
						</CFIF>
					</CFIF>
					<CFIF CoachSelected NEQ "HEAD"> <!--- show ALL or ASST only --->
						<CFIF CoachSelected EQ "ALL">  <!--- if ALL add break --->
							<br>
						</CFIF> 
						<a href="mailto:#trim(AC_Email)#">#trim(AC_Email)#</a> &nbsp;
						<CFIF len(trim(AC_Email))>
							<cfset emailList = emailList & AC_Email & "; " > 
						</CFIF>
					</CFIF>
				</TD>
				<CFIF swShowPhone>		  
					<TD width="10%" valign="top" class="tdUnderLine">
						<CFIF CoachSelected NEQ "ASST"> <!--- show ALL or HEAD only --->
							#HC_Cell#
						</CFIF>
						<CFIF CoachSelected NEQ "HEAD"> <!--- show ALL or ASST only --->
							<CFIF CoachSelected EQ "ALL">  <!--- if ALL add break --->
								<br>
							</CFIF> 
							#AC_Cell#
						</CFIF>
					</TD>
					<TD width="10%" valign="top" class="tdUnderLine">
						<CFIF CoachSelected NEQ "ASST"> <!--- show ALL or HEAD only --->
							#HC_Home#
						</CFIF>
						<CFIF CoachSelected NEQ "HEAD"> <!--- show ALL or ASST only --->
							<CFIF CoachSelected EQ "ALL">  <!--- if ALL add break --->
								<br>
							</CFIF> 
							#AC_Home#
						</CFIF>
					</TD>
					<TD width="10%" valign="top" class="tdUnderLine">
						<CFIF CoachSelected NEQ "ASST"> <!--- show ALL or HEAD only --->
							 #HC_Work#
						</CFIF>
						<CFIF CoachSelected NEQ "HEAD"> <!--- show ALL or ASST only --->
							<CFIF CoachSelected EQ "ALL">  <!--- if ALL add break --->
								<br>
							</CFIF> 
							 #AC_Work#
						</CFIF>
					</TD>
					<TD width="10%" valign="top" class="tdUnderLine">
						<CFIF CoachSelected NEQ "ASST"> <!--- show ALL or HEAD only --->
							#HC_Fax#
						</CFIF>
						<CFIF CoachSelected NEQ "HEAD"> <!--- show ALL or ASST only --->
							<CFIF CoachSelected EQ "ALL">  <!--- if ALL add break --->
								<br>
							</CFIF> 
							#AC_Fax#
						</CFIF>
					</TD>
				</CFIF>
			</tr>
		</CFLOOP>
	</table>
	</div>

	<CFIF NOT swShowPhone>
		<br> All emails: start[
		<br>
		<br> #emailList# 
		<br>
		<br> ]end	
	</CFIF>	
	
	
	
	
	
	
	
	
	
	
	
	










</cfif>






<!--- 

<CFQUERY name="qGetClubPres" datasource="#SESSION.DSN#">
	select cl.Club_name, x.contact_id, co.FirstNAme, co.LastName,
		   co.email, co.phoneHome, co.phoneWork, co.phoneCell, co.phoneFax
	  from xref_contact_role x 
				INNER JOIN TBL_CONTACT co on co.CONTACT_ID = x.CONTACT_ID
				INNER JOIN TBL_CLUB    cl on cl.club_id    = co.club_id
	 where x.role_id 
	 		<cfif listLen(roleID) GT 1>
				in (#VARIABLES.roleID#)
			<cfelse>
				= #VARIABLES.roleID#
			</cfif>
	   and x.season_id = 3
	   and x.active_yn = 'Y'
	 ORDER by CL.CLUB_NAME
</CFQUERY>


 --->
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
