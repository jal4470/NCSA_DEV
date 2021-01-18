<!--- 
	FileName:	approveReviewClub.cfm
	Created on: 09/09/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: allows the approval of a club's registration for the upcomming season and the edit of the club information.
	
MODS: mm/dd/yyyy - filastname - comments

12/11/08 - AA - Added memberNCSA
01/20/09 - AA - Added Club address, city, state, zip
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Review & Accept Club Registration </H1>

<CFIF isDefined("URL.cid") and isNumeric(URL.cid)>
	<CFSET clubID = URL.cid>
<CFELSEIF isDefined("FORM.CLUBID") and isNumeric(FORM.CLUBID)>
	<CFSET clubID = FORM.CLUBID>
<CFELSE>
	<CFSET clubID = "">
</CFIF>

<CFSET useSeason = SESSION.REGSEASON.ID>

<CFSET errMsg = "">



 
<!--- get club values --->
<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="getRegisteredClubs" returnvariable="RegClub">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubid#">
</cfinvoke>  
<CFSET ClubName		  = RegClub.CLUB_NAME > 
<CFSET ClubAbbr		  = RegClub.CLUBABBR > 
<CFSET homePage		  = RegClub.ClubHomePage > 
<CFSET clubEmail	  = RegClub.clubEmail > 
<CFSET HomeShirtColor = RegClub.HomeShirtColor >
<CFSET HomeShortColor = RegClub.HomeShortColor >
<CFSET AwayShirtColor = RegClub.AwayShirtColor >
<CFSET AwayShortColor = RegClub.AwayShortColor >
<CFSET infoDate		  = RegClub.createDate >
<CFSET memberNCSA	  = RegClub.memberNCSA >
<CFSET clubAddress	  = RegClub.Address >
<CFSET clubCity		  = RegClub.city >
<CFSET clubState	  = RegClub.state >
<CFSET clubZip		  = RegClub.zip >

<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubReps" returnvariable="qClubReps">
	<cfinvokeargument name="clubID" value="#VARIABLES.clubid#">
	<cfinvokeargument name="seasonID" value="#VARIABLES.useSeason#">
</cfinvoke>
<CFSET clubRepID		 = qClubReps.REP_CONTACT_ID>
<CFSET clubAltID		 = qClubReps.ALT_CONTACT_ID>
<CFSET clubPresID		 = qClubReps.PRES_CONTACT_ID>
<CFSET origClubRepID 	 = qClubReps.REP_CONTACT_ID>
<CFSET origClubAltID 	 = qClubReps.ALT_CONTACT_ID>
<CFSET origClubPresID	 = qClubReps.PRES_CONTACT_ID>

<CFSET RepContactRoleID  = qClubReps.Rep_Contact_role_id>
<CFSET AltContactRoleID  = qClubReps.Alt_Contact_role_id>
<CFSET PresContactRoleID = qClubReps.Pres_Contact_role_id>

<CFSET REP_FirstName 	 = qClubReps.REP_FIRSTNAME> 	
<CFSET REP_LastName 	 = qClubReps.REP_LASTNAME>
<CFSET ALT_FirstName 	 = qClubReps.ALT_firstName> 	
<CFSET ALT_LastName 	 = qClubReps.ALT_lastName> 
<CFSET PRES_FirstName 	 = qClubReps.PRES_Firstname> 	
<CFSET PRES_LastName  	 = qClubReps.PRES_lastName>

<!--- get ALL contacts for a club --->
<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getClubContacts" returnvariable="qContacts">
	<cfinvokeargument name="clubID"  value="#VARIABLES.clubid#">
</cfinvoke>  
<cfquery name="qContacts" dbtype="query">
	select * from qContacts where active_yn = 'Y'
</cfquery>


<CFIF isDefined("FORM.APPROVE")>
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
	
		<cflocation url="approveClubNewSeason.cfm">
	</CFIF>
</CFIF>



<br><H2> #VARIABLES.clubName# </H2>

<CFIF LEN(TRIM(errMsg))>
	<span class="red">
		<b>#errMsg#</b>
		<BR> #stValidFields.ERRORMESSAGE#
	</span>
</CFIF>


<CFIF isDefined("URL.DTL") AND URL.DTL EQ 1>
	<cfset swViewOnly = 1>
<CFELSE>
	<cfset swViewOnly = 0>
</CFIF>

<CFSET required = "<FONT color=red>*</FONT>">
<FORM name="registerClub" action="approveReviewClub.cfm"  method="post">
	<input type="hidden" name="ClubID"	 		value="#VARIABLES.ClubId#">
	<input type="hidden" name="memberNCSA" 		value="#VARIABLES.memberNCSA#">
	<input type="hidden" name="seasonID"		value="#VARIABLES.useSeason#">
	<input type="hidden" name="ApproveREG"		value="Y">
	<!--- <input type="hidden" name="Orig_REP_ID"		value="#VARIABLES.clubRepID#">
	<input type="hidden" name="Orig_ALT_ID"		value="#VARIABLES.clubAltID#">
	<input type="hidden" name="Orig_PRES_ID" 	value="#VARIABLES.clubPresID#"> --->
	<input type="hidden" name="Orig_REP_ID"		value="#origClubRepID#">
	<input type="hidden" name="Orig_ALT_ID"		value="#origClubAltID#">
	<input type="hidden" name="Orig_PRES_ID"	value="#origClubPresID#">
	<input type="hidden" name="Rep_Contact_role_id"	 value="#VARIABLES.RepContactRoleID#">
	<input type="hidden" name="Alt_Contact_role_id"	 value="#VARIABLES.AltContactRoleID#">
	<input type="hidden" name="Pres_Contact_role_id" value="#VARIABLES.PresContactRoleID#">
	<input type="hidden" name="userContactID" 		 value="#SESSION.USER.CONTACTID#">
<table cellspacing="0" cellpadding="5" border="0" >
	<tr class="red">
		<td colspan="2">Fields marked with * are required</td>
	</tr>
	<tr class="tblHeading">
		<td colspan="2"> &nbsp; Club Info</td>
	</tr>
 	<TR><td width="25%" align="right"> <b>Information Date</b>	</TD>
		<td >#DateFormat(VARIABLES.infoDate,"MM/DD/YYYY")# 	<!--- InfoDate --->			</TD>
	</TR>
	<TR><td align="right"> #required# <b>Club Name</b>			</TD>
		<td><cfif swViewOnly> 
				#VARIABLES.clubName#
			<CFELSE>
				<input maxlength="50" size="70" name="ClubName"  value="#VARIABLES.clubName#" >	
				<input type="Hidden" name="ClubName_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Club Name">
			 </cfif>
		</TD>
	</TR>
	<TR><td align="right"> #required# <b>Club Abbreviation</b>			</TD>
		<td><cfif swViewOnly> 
				#VARIABLES.clubAbbr#
			<CFELSE>
				<input maxlength="50" size="70" name="clubAbbr"  value="#VARIABLES.clubAbbr#" >	
				<input type="Hidden" name="clubAbbr_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Club Abbreviation">
			 </cfif>
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
		<td><cfif swViewOnly> 
				#VARIABLES.homePage#
			<CFELSE>
				<input maxlength="50" size="70" name="homePage"  value="#VARIABLES.homePage#" >	
				<input type="Hidden" name="homePagee_ATTRIBUTES" value="type=generic~required=0~FIELDNAME=Home Page">
			 </cfif>
		</TD>
	</TR>
	<TR><td align="right">#required#  <b>Club E-Mail</b>		</TD>
		<td><cfif swViewOnly> 
				#VARIABLES.clubEmail#
			<CFELSE>
				<input maxlength="50" size="70" name="clubEmail" value="#VARIABLES.clubEmail#" >	
				<input type="Hidden" name="clubEmail_ATTRIBUTES" value="type=EMAIL~required=1~FIELDNAME=Club Email">	
			 </cfif>
		</TD>
	</TR>
	<tr class="tblHeading">
		<td colspan="2"> &nbsp; Rep Info</td>
	</tr>
	<TR><td align="right"> #required# <b>Club Representative</b> </TD>
		<td><cfif swViewOnly> 
				#REP_FirstName# #REP_LastName#
			<CFELSE>
				<SELECT name="ClubRepID" size="1"> 
					<OPTION value="0" selected>Select a Club Rep</OPTION>
					<CFLOOP query="qContacts">
						<OPTION value="#CONTACT_ID#" <CFIF clubRepID EQ CONTACT_ID>selected</CFIF> >#LastName#, #FirstNAme#</OPTION>
					</CFLOOP>
				</SELECT>
				<input type="Hidden" name="ClubRepID_ATTRIBUTES" value="type=NUMERIC~required=1~FIELDNAME=Club Representative">	
			 </cfif>
		</td>
	</tr>
	<TR><td align="right"> <b>ALT. Club Representative</b> </TD>
		<td><cfif swViewOnly> 
				#ALT_FirstName# #ALT_LastName#
			<CFELSE>  
				<SELECT name="ClubAltID" size="1"> 
					<OPTION value="0" selected>Select a Club Rep</OPTION>
					<CFLOOP query="qContacts">
						<OPTION value="#CONTACT_ID#" <CFIF clubAltID EQ CONTACT_ID>selected</CFIF> >#LastName#, #FirstNAme#</OPTION>
					</CFLOOP>
				</SELECT>
			 </cfif>
		</td>
	</tr>
	<TR><td align="right"> #required# <b>Club President</b> </TD>
		<td><cfif swViewOnly> 
				#PRES_FirstName# #PRES_LastName#
			<CFELSE>
				<SELECT name="clubPresID" size="1"> 
					<OPTION value="0" selected>Select a Club Rep</OPTION>
					<CFLOOP query="qContacts">
						<OPTION value="#CONTACT_ID#" <CFIF clubPresID EQ CONTACT_ID>selected</CFIF> >#LastName#, #FirstNAme#</OPTION>
					</CFLOOP>
				</SELECT>
				<input type="Hidden" name="clubPresID_ATTRIBUTES" value="type=NUMERIC~required=1~FIELDNAME=Club President">	
			 </cfif>
		</td>
	</tr>
 
	<tr class="tblHeading">
		<td colspan="2"> &nbsp; Team Info</td>
	</tr>
	<tr><td align="right"> #required# <b>Home Shirt Color</b> </TD>
		<TD><cfif swViewOnly> 
				#VARIABLES.HomeShirtColor#
			<CFELSE>
				<input name="HomeShirtColor" value="#VARIABLES.HomeShirtColor#">
				<input type="Hidden" name="HomeShirtColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Home Shirt Color">	
			 </cfif>
		</TD>
	</tr>
	<tr><td align="right"> #required# <b>Home Short Color</b> </TD>
		<TD><cfif swViewOnly>
				#VARIABLES.HomeShortColor#
			<CFELSE>
				<input name="HomeShortColor" value="#VARIABLES.HomeShortColor#">
				<input type="Hidden" name="HomeShortColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Home Short Color">	
			 </cfif>
		</TD>
	</tr>
	<tr><td align="right"> #required# <b>Away Shirt Color</b> </TD>
		<TD><cfif swViewOnly>
				#VARIABLES.AwayShirtColor#
			<CFELSE>
				<input name="AwayShirtColor" value="#VARIABLES.AwayShirtColor#">
				<input type="Hidden" name="AwayShirtColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Away Shirt Color">	
			 </cfif>
		</TD>
	</tr>
	<tr><td align="right"> #required# <b>Away Short Color</b> </TD>
		<TD><cfif swViewOnly>
				#VARIABLES.AwayShortColor#
			<CFELSE>
				<input name="AwayShortColor" value="#VARIABLES.AwayShortColor#">
				<input type="Hidden" name="AwayShortColor_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Away Short Color">	
			 </cfif>
		</TD>
	</tr>
	<tr><td colspan="2" align="center">
			<hr size="1px">
			<br> 
			<cfif swViewOnly EQ 0>
				<input type="Submit" name="Approve" value="Approve">
			</cfif>
			<INPUT type="Button" name="goback" value="<< Back" onclick="history.go(-1)">

		</TD>
	</tr>

</TABLE>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
