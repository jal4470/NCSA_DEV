<!--- 
	FileName:	clubAdminEdit.cfm
	Created on: 12/02/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

	If this template changes, check ClubEditInfo.cfm, it may require the SAME changes....

12/11/08 - AA - Added memberNCSA
01/20/09 - AA - Added Club address, city, state, zip
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - CLub Edit (Admin)</H1>
<!--- <br> <h2>yyyyyy </h2> --->

<cfset err = "">
<CFSET errMsg = "">
<CFSET successMsg = "">

<CFIF isDefined("FORM.Clubselected") AND FORM.Clubselected GT 0>
	<CFSET Clubselected = FORM.Clubselected>
<CFELSE>
	<CFSET Clubselected = 0>
</CFIF>



<CFIF isDefined("FORM.SaveChanges")>
 
	<!--- PROCESS FORM  --->
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
		
		<CFSET successMsg = "Club changes were saved.">
	</CFIF>
</CFIF>










<CFIF Clubselected GT 0>
	<!--- A CLUB was selected --->
	<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="qClubInfo">
		<cfinvokeargument name="clubID" value="#VARIABLES.Clubselected#">
	</cfinvoke>  
	<CFSET ClubName		  = qClubInfo.CLUB_NAME > 
	<CFSET ClubAbbr		  = qClubInfo.ClubAbbr > 
	<CFSET homePage		  = qClubInfo.ClubHomePage > 
	<CFSET clubEmail	  = qClubInfo.clubEmail > 
	<CFSET HomeShirtColor = qClubInfo.HomeShirtColor >
	<CFSET HomeShortColor = qClubInfo.HomeShortColor >
	<CFSET AwayShirtColor = qClubInfo.AwayShirtColor >
	<CFSET AwayShortColor = qClubInfo.AwayShortColor > 
	<CFSET MemberNCSA	  = qClubInfo.MemberNCSA >
	<CFSET clubAddress	  = qClubInfo.Address >
	<CFSET clubCity		  = qClubInfo.city >
	<CFSET clubState	  = qClubInfo.state >
	<CFSET clubZip		  = qClubInfo.zip >

	<!--- get club representatives REP, ALT, PRES --->
	<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubReps" returnvariable="qClubReps">
		<cfinvokeargument name="clubID" value="#VARIABLES.Clubselected#">
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
		<cfinvokeargument name="clubID"  value="#VARIABLES.Clubselected#">
	</cfinvoke>  
	<cfquery name="qContacts" dbtype="query">
		select * from qContacts where active_yn = 'Y'
	</cfquery>
<CFELSE>
	<CFSET ClubName = "" > 
	<CFSET ClubAbbr = "" > 
	<CFSET homePage = "" > 
	<CFSET clubEmail = "" > 
	<CFSET HomeShirtColor = "" > 
	<CFSET HomeShortColor = "" > 
	<CFSET AwayShirtColor = "" > 
	<CFSET AwayShortColor = "" > 
	<CFSET clubRepID  = "" > 
	<CFSET clubAltID  = "" > 
	<CFSET clubPresID = "" > 
	<CFSET RepContactRoleID  = "" > 
	<CFSET AltContactRoleID  = "" > 
	<CFSET PresContactRoleID = "" > 
	<CFSET qContacts = "" >
	<CFSET clubAddress	= "" >
	<CFSET clubCity		= "" >
	<CFSET clubState	= "" >
	<CFSET clubZip		= "" >
</CFIF>

<form name="frmContact" action="clubAdminEdit.cfm" method="post">
	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<CFIF listFind(SESSION.CONSTANT.CUroles,SESSION.menuRoleID) EQ 0>  
			<!--- user logged in is NOT a CLUB user, so they can select any club --->
			<!--- <cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
				<cfinvokeargument name="orderby" value="clubname">
			</cfinvoke> --->
			<CFQUERY name="qClubs" datasource="#SESSION.DSN#">
				SELECT distinct cl.club_id, cl.Club_name, cl.ClubAbbr
				  FROM tbl_club cl   
				 order by cl.club_name 
 			</CFQUERY>
			<TR><TD align="right"> &nbsp; </TD>
				<TD colspan="4"> <b>Select a Club:</b>
					<Select name="Clubselected">
						<option value="0">Select a Club</option>
						<CFLOOP query="qClubs">
							<option value="#CLUB_ID#" <CFIF CLUB_ID EQ VARIABLES.Clubselected>selected</CFIF> >#CLUB_NAME#</option>
						</CFLOOP>
					</SELECT>
					<INPUT type="Submit" name="goClub" value="Go">
				</TD>
			</TR>
		<CFELSE>
			<!--- user logged in IS a CLUB user, they can only see their own club --->
			<input type="Hidden" name="Clubselected" value="#SESSION.USER.CLUBID#">	
		</CFIF>
		<cfif len(Trim(err)) OR len(Trim(errMsg))>
			<TR><TD>		</TD>
				<TD colspan="4" align="center" class="red">
					<b>Please correct the following errors and submit again.</b>
					<br>
					#stValidFields.errorMessage#
					#err#
				</td>
			</TR>
		</cfif>
		<cfif len(Trim(successMsg))>
			<TR><TD>&nbsp;		</TD>
				<TD colspan="4" align="left" class="red">
					<b>#repeatstring("&nbsp;",10)# #successMsg#</b>
				</td>
			</TR>
		</cfif>

		</table>
 

<!--- ====================================== --->
<CFIF isDefined("qClubInfo") and qClubInfo.recordcount>
	<CFSET required = "<FONT color=red>*</FONT>">
	<input type="hidden" name="ClubID"	 		value="#Clubselected#">
	<input type="hidden" name="seasonID"		value="#SESSION.CURRENTSEASON.ID#">
	<!--- <input type="hidden" name="Orig_REP_ID"		value="#clubRepID#">
	<input type="hidden" name="Orig_ALT_ID"		value="#clubAltID#">
	<input type="hidden" name="Orig_PRES_ID"	value="#clubPresID#"> --->
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
	<TR><td align="right"> <b>Member NCSA</b>			</TD>
		<td><SELECT name="memberNCSA" size="1"> 
				<OPTION value="N" <CFIF variables.memberNCSA EQ "N">selected</CFIF> >No</OPTION>
				<OPTION value="Y" <CFIF variables.memberNCSA EQ "Y">selected</CFIF> >Yes</OPTION>
			</SELECT>
		</TD>
	</TR>
	<TR><td align="right"> #required# <b>Club Name</b>			</TD>
		<td><input maxlength="50" size="70" name="ClubName"  value="#clubName#" >	
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

	<TR><td align="right"> #required# <b>Club Abbreviation</b>			</TD>
		<td><input maxlength="50" size="70" name="ClubAbbr"  value="#ClubAbbr#" >	
			<input type="Hidden" name="ClubAbbr_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Club Abbreviation">
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
				<OPTION value="" selected>Select a Club Rep</OPTION>
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
			<br> <input type="Submit" name="SaveChanges" value="Save Changes">
		</TD>
	</tr>

	</TABLE>
</CFIF>	
	
<!--- ====================================== --->	


</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">




