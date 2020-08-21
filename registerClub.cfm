<!--- 
	FileName:	register/clubRegister.cfm
	Created on: 09/03/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: When registration is OPEN for a new season, an existing club can register to play in the new season. 
	
MODS: mm/dd/yyyy - filastname - comments
7/14/2010 B. Cooper
8747-fixed validation on required rep dropdowns
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">


<CFSET clubID = SESSION.USER.CLUBID>
<CFSET errMsg = "">

<CFIF isDefined("FORM.SUBMIT")>
	<!--- PROCESS FORM  --->
	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#FORM#">
	</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->

	<CFIF stValidFields.errors>
		<CFSET errMsg = "Please correct the following errors and submit again.">
	<CFELSE>

	
		<!--- new club or existing? new clubs are already in the reg season at this point, existing clubs are not yet. --->
		<cfset swExistingClub = true>
		<cfif isDefined("SESSION.REGSEASON")>
			<!--- we are in the reg season, are they in current? --->
			<CFQUERY name="qExisting" datasource="#SESSION.DSN#">
				SELECT 	club_id
				  FROM  xref_club_season
				 WHERE  CLUB_ID   = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubid#">  
				   AND  season_id = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#SESSION.CURRENTSEASON.ID#">
			</CFQUERY>
			<CFIF qExisting.recordCount EQ 0>
				<cfset swExistingClub = false>
			</CFIF>
			<!--- if not current season then it may not matter if they are new --->
		</cfif>

		<CFIF swExistingClub>
			<cfinvoke component="#SESSION.sitevars.cfcPath#REGISTRATION" method="RegisterExistingClub" returnvariable="reqMsg">
				<cfinvokeargument name="clubID" 	    value="#FORM.ClubID#">
				<cfinvokeargument name="ClubName"	    value="#FORM.ClubName#">
				<cfinvokeargument name="ClubHomePage"   value="#FORM.homePage#">
				<cfinvokeargument name="ClubEMail"      value="#FORM.clubEmail#">
				<cfinvokeargument name="HomeShirtColor" value="#FORM.HomeShirtColor#">
				<cfinvokeargument name="HomeShortColor" value="#FORM.HomeShortColor#">
				<cfinvokeargument name="AwayShirtColor" value="#FORM.AwayShirtColor#">
				<cfinvokeargument name="AwayShortColor" value="#FORM.AwayShortColor#">
				<cfinvokeargument name="registeredBy"   value="#SESSION.USER.CONTACTID#">
				<cfinvokeargument name="SeasonID"       value="#SESSION.REGSEASON.ID#">
				<cfinvokeargument name="ClubPresID"     value="#FORM.clubPresID#">
				<cfinvokeargument name="ClubREPID"      value="#FORM.ClubRepID#">
				<cfinvokeargument name="ClubALTID"      value="#FORM.ClubAltID#">
			</cfinvoke>
		<cfelse>		
			<cfinvoke component="#SESSION.sitevars.cfcPath#REGISTRATION" method="RegisterNewClub" returnvariable="reqMsg">
				<cfinvokeargument name="clubID" 	    value="#FORM.ClubID#">
				<cfinvokeargument name="ClubName"	    value="#FORM.ClubName#">
				<cfinvokeargument name="ClubHomePage"   value="#FORM.homePage#">
				<cfinvokeargument name="ClubEMail"      value="#FORM.clubEmail#">
				<cfinvokeargument name="HomeShirtColor" value="#FORM.HomeShirtColor#">
				<cfinvokeargument name="HomeShortColor" value="#FORM.HomeShortColor#">
				<cfinvokeargument name="AwayShirtColor" value="#FORM.AwayShirtColor#">
				<cfinvokeargument name="AwayShortColor" value="#FORM.AwayShortColor#">
				<cfinvokeargument name="registeredBy"   value="#SESSION.USER.CONTACTID#">
				<cfinvokeargument name="SeasonID"       value="#SESSION.REGSEASON.ID#">
				<cfinvokeargument name="ClubPresID"     value="#FORM.clubPresID#">
				<cfinvokeargument name="ClubREPID"      value="#FORM.ClubRepID#">
				<cfinvokeargument name="ClubALTID"      value="#FORM.ClubAltID#">
			</cfinvoke>
		</CFIF>
		
		<cfif len(trim(VARIABLES.reqMsg))>
			<cfset errMsg = errMsg & "<br>" & reqMsg >
		<CFELSE>
			<cfset errMsg = errMsg & "<br>" & "Club registration information has been submitted." >
		</cfif>

	</CFIF>
</CFIF>



<!--- GET CLUB INFO --->
<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubid#">
</cfinvoke>

<!--- <CFQUERY name="qClubs" datasource="#SESSION.DSN#">
		SELECT distinct cl.club_id, cl.Club_name, cl.ClubAbbr, cl.clubEmail, cl.ClubHomePage, 
				cl.HomeShirtColor, cl.HomeShortColor, cl.AwayShirtColor, cl.AwayShortColor, 
				cl.Address, cl.city, cl.state, cl.zip, cl.CLUB_STATE,
				cl.infoDate, cl.infoUpdate, 
				cl.MemberNCSA, cl.CLUB_STATE, 
				cl.homeFieldFull, cl.homeFieldSmall, 
				cl.USSFCertReferees, 
				XCS.paymentDate, XCS.Bond_YN,
				XCS.TotalU11OlderTeams,			XCS.TotalU10YoungerTeams, 
				XCS.Total11Thru14Teams,			XCS.Total15thru19Teams,
				XCS.Approved_YN, XCS.Active_YN, XCS.termsAccepted_YN,
				XCS.RegSubmit, XCS.SEASON_ID
		  FROM tbl_club cl  INNER JOIN xref_club_season XCS  ON XCS.club_id = cl.club_id 	     
		 WHERE xcs.season_id = (select season_id from tbl_season where currentSeason_YN = 'Y')
		   AND cl.CLUB_ID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubid#">
		 order by cl.club_id 
</CFQUERY>
 --->



<CFIF qClubs.recordcount EQ 0>
	<!--- club not found in current season, maybe a new club just approved --->
	<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="getRegisteredClubs" returnvariable="qClubs">
		<cfinvokeargument name="clubID" value="#VARIABLES.clubid#">
	</cfinvoke>  
	
	
	
	<CFSET ClubName = qClubs.CLUB_NAME > 
	<CFSET homePage = qClubs.ClubHomePage > 
	<CFSET clubEmail = qClubs.clubEmail > 
	<CFSET ClubState = qClubs.STATE > 
<CFELSE>
	<CFSET ClubName = qClubs.CLUB_NAME > 
	<CFSET homePage = qClubs.ClubHomePage > 
	<CFSET clubEmail = qClubs.clubEmail > 
	<CFSET ClubState = qClubs.CLUB_STATE > 
</CFIF>

<!--- <CFSET ClubState = qClubs.CLUB_STATE >  --->

<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubReps" returnvariable="qClubReps">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubid#">
	<cfinvokeargument name="seasonID" value="#SESSION.REGSEASON.ID#">
</cfinvoke>
<CFSET clubRepID = qClubReps.REP_CONTACT_ID>
<CFSET clubAltID = qClubReps.ALT_CONTACT_ID>
<CFSET clubPresID = qClubReps.PRES_CONTACT_ID>
<CFSET RepContactRoleID  = qClubReps.Rep_Contact_role_id>
<CFSET AltContactRoleID  = qClubReps.Alt_Contact_role_id>
<CFSET PresContactRoleID = qClubReps.Pres_Contact_role_id>

<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getClubContacts" returnvariable="qContacts">
	<cfinvokeargument name="clubID"  value="#VARIABLES.clubid#">
</cfinvoke>  



<CFQUERY name="qWasClubRegd" datasource="#SESSION.DSN#">
	SELECT 	club_id
	  FROM  xref_club_season
	 WHERE  CLUB_ID   = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubid#">  
	   AND  season_id = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#SESSION.REGSEASON.ID#">
</CFQUERY>
<CFIF qWasClubRegd.recordcount>
	<cfset swClubHasSubmittedREG = true>
<CFELSE>
	<cfset swClubHasSubmittedREG = false>
</CFIF>


		<!--- new club or existing? new clubs are already in the reg season at this point, existing clubs are not yet. --->
		<cfset swExistingClub = true>
		<cfif isDefined("SESSION.REGSEASON")>
			<!--- we are in the reg season, are they in current? --->
			<CFQUERY name="qExisting" datasource="#SESSION.DSN#">
				SELECT 	club_id
				  FROM  xref_club_season
				 WHERE  CLUB_ID   = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubid#">  
				   AND  season_id = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#SESSION.CURRENTSEASON.ID#">
			</CFQUERY>
			<CFIF qExisting.recordCount EQ 0>
				<cfset swClubHasSubmittedREG = false> <!--- differnt from above value --->
			</CFIF>
			<!--- if not current season then it may not matter if they are new --->
		</cfif>

<CFIF listFind(SESSION.CONSTANT.AdminRoles,SESSION.MENUROLEID) EQ 0>
	<!--- we are logged in as "CU" as a CLUB user(rep,alt,pres) Do not allow user to change first and or last names	--->
	<CFSET swNameReadOnly = true>
<CFELSE>
	<CFSET swNameReadOnly = false>
</CFIF>

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Club Registration</H1>
<br>
<h2>for the #SESSION.REGSEASON.SF# #SESSION.REGSEASON.YEAR# Season</h2>
<br>	

<CFIF LEN(TRIM(errMsg))>
	<span class="red">
		<b>#errMsg#</b>
		<BR> #stValidFields.ERRORMESSAGE#
	</span>
</CFIF>

<CFIF swClubHasSubmittedREG	>
	<span class="red"><b>Registration for this club has been submitted</b></span>
</CFIF>



<CFSET required = "<FONT color=red>*</FONT>">
<FORM name="registerClub" action="registerClub.cfm"  method="post">
	<input type="hidden" name="ClubID"	 		value="#ClubId#">
	<input type="hidden" name="seasonID"		value="#SESSION.REGSEASON.ID#">
	<input type="hidden" name="Orig_REP_ID"		value="#clubRepID#">
	<input type="hidden" name="Orig_ALT_ID"		value="#clubAltID#">
	<input type="hidden" name="Orig_PRES_ID"	value="#clubPresID#">
	<input type="hidden" name="Rep_Contact_role_id"	 value="#RepContactRoleID#">
	<input type="hidden" name="Alt_Contact_role_id"	 value="#AltContactRoleID#">
	<input type="hidden" name="Pres_Contact_role_id" value="#PresContactRoleID#">
	<input type="hidden" name="userContactID" value="#SESSION.USER.CONTACTID#">
<table cellspacing="0" cellpadding="5" border="0" >
	<!--- ====================================================================== --->
	<tr class="red">
		<td colspan="2">Fields marked with * are required</td>
	</tr>
<!--- <span class="red"></span> --->

	<tr class="tblHeading">
		<td colspan="2"> &nbsp; Club Info</td>
	</tr>
 	<TR><td width="25%" align="right"> <b>Information Date</b>	</TD>
		<td >#DateFormat(NOW(),"MM/DD/YYYY")# 	<!--- InfoDate --->			</TD>
	</TR>
	<TR><td align="right"> #required# <b>Club Name</b>			</TD>
		<td><cfif swNameReadOnly EQ true>#clubName# <input type="hidden" name="ClubName"  value="#clubName#" ><cfelse><input maxlength="50" size="70" name="ClubName"  value="#clubName#" >	</cfif>
			<input type="Hidden" name="ClubName_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Club Name">
		</TD>
	</TR>
	<TR><td align="right">   <b>Home Page</b>			</TD>
		<td><input maxlength="50" size="70" name="homePage"  value="#homePage#" >	
			<input type="Hidden" name="homePagee_ATTRIBUTES" value="type=generic~required=0~FIELDNAME=Home Page">
		</TD>
	</TR>
	<TR><td align="right">#required#  <b>Club E-Mail</b>		</TD>
		<td><input maxlength="50" size="70" name="clubEmail" value="#clubEmail#" >	
			<input type="Hidden" name="clubEmail_ATTRIBUTES" value="type=EMAIL~required=1~FIELDNAME=Club Email">	
		</TD>
	</TR>
	<!--- <TR><td align="right">#required# <b>Club State</b>	</TD>
		<td><input maxlength="2"  size="3"  name="ClubState" value="#ClubState#" >		
			<input type="Hidden" name="ClubState_ATTRIBUTES" value="type=STATE~required=1~FIELDNAME=Club State">	
		</TD>
	</TR> --->

	<tr class="tblHeading">
		<td colspan="2"> &nbsp; Rep Info</td>
	</tr>
	<TR><td align="right"> #required# <b>Club Representative</b> </TD>
		<td><SELECT name="ClubRepID" size="1"> 
				<OPTION value="" selected>Select a Club Rep</OPTION>
				<CFLOOP query="qContacts">
					
					<OPTION value="#CONTACT_ID#" <CFIF clubRepID EQ CONTACT_ID>selected</CFIF> >#LastName#, #FirstNAme#</OPTION>
				</CFLOOP>
			</SELECT>
			<input type="Hidden" name="ClubRepID_ATTRIBUTES" value="type=NUMERIC~required=1~FIELDNAME=Club Representative">	
		</td>
	</tr>
	<TR><td align="right"> <b>ALT. Club Representative</b> </TD>
		<td><SELECT name="ClubAltID" size="1"> 
				<OPTION value="0" selected>Select a Club Rep</OPTION>
				<CFLOOP query="qContacts">
					<OPTION value="#CONTACT_ID#" <CFIF clubAltID EQ CONTACT_ID>selected</CFIF> >#LastName#, #FirstNAme#</OPTION>
				</CFLOOP>
			</SELECT>
		</td>
	</tr>
	<TR><td align="right"> #required# <b>Club President</b> </TD>
		<td><SELECT name="clubPresID" size="1"> 
				<OPTION value="" selected>Select a Club Rep</OPTION>
				<CFLOOP query="qContacts">
					<OPTION value="#CONTACT_ID#" <CFIF clubPresID EQ CONTACT_ID>selected</CFIF> >#LastName#, #FirstNAme#</OPTION>
				</CFLOOP>
			</SELECT>
			<input type="Hidden" name="clubPresID_ATTRIBUTES" value="type=NUMERIC~required=1~FIELDNAME=Club President">	
		</td>
	</tr>
 
	<tr class="tblHeading">
		<td colspan="2"> &nbsp; Team Info</td>
	</tr>
	<tr><td align="right"> #required# <b>Home Shirt Color</b> </TD>
		<TD><input name="HomeShirtColor" value="#qClubs.HomeShirtColor#">
			<input type="Hidden" name="HomeShirtColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Home Shirt Color">	
		</TD>
	</tr>
	<tr><td align="right"> #required# <b>Home Short Color</b> </TD>
		<TD><input name="HomeShortColor" value="#qClubs.HomeShortColor#">
			<input type="Hidden" name="HomeShortColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Home Short Color">	
		</TD>
	</tr>
	<tr><td align="right"> #required# <b>Away Shirt Color</b> </TD>
		<TD><input name="AwayShirtColor" value="#qClubs.AwayShirtColor#">
			<input type="Hidden" name="AwayShirtColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Away Shirt Color">	
		</TD>
	</tr>
	<tr><td align="right"> #required# <b>Away Short Color</b> </TD>
		<TD><input name="AwayShortColor" value="#qClubs.AwayShortColor#">
			<input type="Hidden" name="AwayShortColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Away Short Color">	
		</TD>
	</tr>
	<tr><td colspan="2" align="center">
			<hr size="1px">
			<br> 
			<CFIF swClubHasSubmittedREG	>
				<span class="red"><b>Registration for this club has already been submitted</b></span>
			<CFELSE>
				<input type="Submit" name="Submit" value="Submit Club Registration">
			</CFIF>
		</TD>
	</tr>

</TABLE>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
