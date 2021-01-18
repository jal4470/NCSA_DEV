<!--- 
	FileName:	clubEditInfo.cfm
	Created on: 09/03/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: allows the edit of the club information for the current season. 
	
MODS: mm/dd/yyyy - filastname - comments

	If this template changes, check ClubAdminEdit.cfm, it may require the SAME changes....

12/11/08 - AA - Added memberNCSA
01/20/09 - AA - Added Club address, city, state, zip
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">


<CFSET clubID = SESSION.USER.CLUBID>
<CFSET errMsg = "">



<!--- get club values --->
<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubid#">
</cfinvoke>  
<CFSET ClubName		= qClubs.CLUB_NAME > 
<CFSET ClubAbbr		= qClubs.ClubAbbr > 
<CFSET homePage		= qClubs.ClubHomePage > 
<CFSET clubEmail	= qClubs.clubEmail > 
<CFSET memberNCSA	= qClubs.memberNCSA >
<CFSET clubAddress	= qClubs.Address >
<CFSET clubCity		= qClubs.city >
<CFSET clubState	= qClubs.state >
<CFSET clubZip		= qClubs.zip >
<CFSET HomeShirtColor	= qClubs.HomeShirtColor >
<CFSET HomeShortColor	= qClubs.HomeShortColor >
<CFSET AwayShirtColor	= qClubs.AwayShirtColor >
<CFSET AwayShortColor	= qClubs.AwayShortColor >


<!--- get club representatives REP, ALT, PRES --->
<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubReps" returnvariable="qClubReps">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubid#">
	<cfinvokeargument name="seasonID" value="#SESSION.CURRENTSEASON.ID#">
</cfinvoke>
<CFSET clubRepID  = qClubReps.REP_CONTACT_ID>
<CFSET clubAltID  = qClubReps.ALT_CONTACT_ID>
<CFSET clubPresID = qClubReps.PRES_CONTACT_ID>
<CFSET origClubRepID  = qClubReps.REP_CONTACT_ID>
<CFSET origClubAltID  = qClubReps.ALT_CONTACT_ID>
<CFSET origClubPresID = qClubReps.PRES_CONTACT_ID>
<CFSET RepContactRoleID  = qClubReps.Rep_Contact_role_id>
<CFSET AltContactRoleID  = qClubReps.Alt_Contact_role_id>
<CFSET PresContactRoleID = qClubReps.Pres_Contact_role_id>

<!--- get ALL contacts for a club --->
<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getClubContacts" returnvariable="qContacts">
	<cfinvokeargument name="clubID"  value="#VARIABLES.clubid#">
</cfinvoke>  
<cfquery name="qContacts" dbtype="query">
	select * from qContacts where active_yn = 'Y'
</cfquery>


<CFIF isDefined("FORM.SUBMIT")>
	<CFSET ClubName    = FORM.ClubName > 
	<CFSET ClubAbbr    = FORM.ClubAbbr > 
	<CFSET homePage    = FORM.homePage > 
	<CFSET clubEmail   = FORM.clubEmail > 
	<CFSET memberNCSA  = FORM.memberNCSA > 
	<CFSET clubAddress = FORM.clubAddress > 
	<CFSET clubCity    = FORM.clubCity > 
	<CFSET clubState   = FORM.clubState > 
	<CFSET clubZip     = FORM.clubZip > 

	<CFSET clubRepID		 = FORM.clubRepID > 
	<CFSET clubAltID		 = FORM.clubAltID > 
	<CFSET clubPresID		 = FORM.clubPresID > 
	<CFSET origClubRepID	 = FORM.Orig_REP_ID >
	<CFSET origClubAltID	 = FORM.Orig_ALT_ID >
	<CFSET origClubPresID	 = FORM.Orig_PRES_ID >
	<CFSET RepContactRoleID  = FORM.Rep_Contact_role_id > 
	<CFSET AltContactRoleID  = FORM.Alt_Contact_role_id > 
	<CFSET PresContactRoleID = FORM.Pres_Contact_role_id > 

	<CFSET HomeShirtColor	 = FORM.HomeShirtColor >
	<CFSET HomeShortColor	 = FORM.HomeShortColor >
	<CFSET AwayShirtColor	 = FORM.AwayShirtColor >
	<CFSET AwayShortColor	 = FORM.AwayShortColor >

	<!--- PROCESSPres_Contact_role_id FORM  --->
	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#FORM#">
	</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->

	<CFIF stValidFields.errors>
		<CFSET errMsg = "Please correct the following errors and submit again.">
	<CFELSE>
		<!--- process the form values --->
		<CFINVOKE component="#SESSION.sitevars.cfcPath#club" method="processClubEdit">
			<cfinvokeargument name="formValues" value="#FORM#">
		</CFINVOKE> 
		
		<cfset errMsg = "Club info updated.">
		
	</CFIF>
</CFIF>

<CFIF listFind(SESSION.CONSTANT.AdminRoles,SESSION.MENUROLEID) EQ 0>
	<!--- we are logged in as "CU" as a CLUB user(rep,alt,pres) Do not allow user to change first and or last names	--->
	<CFSET swNameReadOnly = true>
<CFELSE>
	<CFSET swNameReadOnly = false>
</CFIF>

 
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Edit Club Info</H1>

<CFIF LEN(TRIM(errMsg))>
	<span class="red">
		<b>#errMsg#</b>
		<BR> #stValidFields.ERRORMESSAGE#
	</span>
</CFIF>

<CFSET required = "<FONT color=red>*</FONT>">
<FORM name="registerClub" action="ClubEditInfo.cfm"  method="post">
	<input type="hidden" name="ClubID"	 		value="#ClubId#">
	<input type="hidden" name="ClubAbbr"	 	value="#ClubAbbr#">
	<input type="hidden" name="memberNCSA" 		value="#VARIABLES.memberNCSA#">
	<input type="hidden" name="seasonID"		value="#SESSION.CURRENTSEASON.ID#">
	<input type="hidden" name="Orig_REP_ID"		value="#origClubRepID#">
	<input type="hidden" name="Orig_ALT_ID"		value="#origClubAltID#">
	<input type="hidden" name="Orig_PRES_ID"	value="#origClubPresID#">
	<input type="hidden" name="Rep_Contact_role_id"	 value="#RepContactRoleID#">
	<input type="hidden" name="Alt_Contact_role_id"	 value="#AltContactRoleID#">
	<input type="hidden" name="Pres_Contact_role_id" value="#PresContactRoleID#">
	<input type="hidden" name="userContactID" value="#SESSION.USER.CONTACTID#">
<table cellspacing="0" cellpadding="5" border="0" >
	<tr class="red">
		<td colspan="2">Fields marked with * are required</td>
	</tr>

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
	<TR><td align="right"> #required# <b>Street</b>			</TD>
		<td><input maxlength="100" size="70" name="ClubAddress"  value="#ClubAddress#" >	
			<input type="Hidden" name="ClubAddress_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Address">
		</TD>
	</TR>
	<TR><td align="right"> #required# <b>City</b>			</TD>
		<td><input maxlength="50" size="70" name="clubCity"  value="#clubCity#" >	
			<input type="Hidden" name="ClubCity_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=City">
		</TD>
	</TR>
	<TR><td align="right"> #required# <b>State</b>			</TD>
		<td><input maxlength="2" size="2" name="clubState"  value="#clubState#" >	
			<input type="Hidden" name="ClubState_ATTRIBUTES" value="type=STATE~required=1~FIELDNAME=State">
		</TD>
	</TR>
	<TR><td align="right"> #required# <b>Zip</b>			</TD>
		<td><input maxlength="10" size="10" name="clubZip"  value="#clubZip#" >	
			<input type="Hidden" name="ClubZip_ATTRIBUTES" value="type=ZIPCODE~required=1~FIELDNAME=Zip">
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

	<tr class="tblHeading">
		<td colspan="2"> &nbsp; Rep Info</td>
	</tr>
	<TR><td align="right"> #required# <b>Club Representative</b> </TD>
		<td><SELECT name="ClubRepID" size="1"> 
				<OPTION value="0" selected>Select a Club Rep</OPTION>
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
				<OPTION value="0" selected>Select a Club Rep</OPTION>
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
		<TD><input name="HomeShirtColor" value="#HomeShirtColor#">
			<input type="Hidden" name="HomeShirtColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Home Shirt Color">	
		</TD>
	</tr>
	<tr><td align="right"> #required# <b>Home Short Color</b> </TD>
		<TD><input name="HomeShortColor" value="#HomeShortColor#">
			<input type="Hidden" name="HomeShortColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Home Short Color">	
		</TD>
	</tr>
	<tr><td align="right"> #required# <b>Away Shirt Color</b> </TD>
		<TD><input name="AwayShirtColor" value="#AwayShirtColor#">
			<input type="Hidden" name="AwayShirtColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Away Shirt Color">	
		</TD>
	</tr>
	<tr><td align="right"> #required# <b>Away Short Color</b> </TD>
		<TD><input name="AwayShortColor" value="#AwayShortColor#">
			<input type="Hidden" name="AwayShortColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Away Short Color">	
		</TD>
	</tr>
	<tr><td colspan="2" align="center">
			<hr size="1px">
			<br> <input type="Submit" name="Submit" value="Save Changes">
		</TD>
	</tr>

</TABLE>
</FORM>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
