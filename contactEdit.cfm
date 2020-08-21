<!--- 
	FileName:	contactEdit.cfm
	Created on: 09/15/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
01/13/09 - AA - changed to use the reseason if defined, else current season
07/06/12 - J. Rab - Added logic for editing contacts and permissions based on Role ID (TICKET NCSA12173)
08/12/2012 - J. Rab - Set autocomplete to off for form.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Edit a Contact</H1>
<br>
<!--- <h2>yyyyyy </h2> --->

<cfset err = "">
<cfset p = "">
<cfset swErrors = false>	
<CFSET swBoardMEMBER = false>

<CFSET Season_type = "current"> <!---  optional values are reg for Registration and tempreg for temp registration --->
<CFIF isDefined("URL.st")>
	<CFSET Season_type = URL.st>
</CFIF>

<CFIF isDefined("URL.cid") AND len(trim(URL.cid))>
	<CFSET ClubSelected = URL.cid>
<CFELSEIF isDefined("FORM.ClubSelected") AND len(trim(FORM.ClubSelected))>
	<CFSET ClubSelected = FORM.ClubSelected>
<CFELSE>
	<CFSET ClubSelected = 0>
</CFIF>

<!--- === FORM VARS ==== --->
<CFIF isDefined("FORM.contactSelected")>
	<CFSET contactSelected = FORM.contactSelected>
<CFELSE>
	<CFSET contactSelected = 0>
</CFIF>
<CFIF isDefined("Form.FirstName")>
	<CFSET FirstName = Form.FirstName>
<CFELSE>
	<CFSET FirstName = "">
</CFIF>
<CFIF isDefined("Form.LastName")>
	<CFSET LastName = Form.LastName>
<CFELSE>
	<CFSET LastName = "">
</CFIF>
<CFIF isDefined("Form.Address")>
	<CFSET Address = Form.Address>
<CFELSE>
	<CFSET Address = "">
</CFIF>
<CFIF isDefined("Form.Town")>
	<CFSET Town = Form.Town>
<CFELSE>
	<CFSET Town = "">
</CFIF>
<CFIF isDefined("Form.State")>
	<CFSET State = Form.State>
<CFELSE>
	<CFSET State = "">
</CFIF>
<CFIF isDefined("Form.Zip")>
	<CFSET Zip = Form.Zip>
<CFELSE>
	<CFSET Zip = "">
</CFIF>
<CFIF isDefined("Form.HPhone")>
	<CFSET HPhone = Form.HPhone>
<CFELSE>
	<CFSET HPhone = "">
</CFIF>
<CFIF isDefined("Form.CPhone")>
	<CFSET CPhone = Form.CPhone>
<CFELSE>
	<CFSET CPhone = "">
</CFIF>
<CFIF isDefined("Form.WPhone")>
	<CFSET WPhone = Form.WPhone>
<CFELSE>
	<CFSET WPhone = "">
</CFIF>
<CFIF isDefined("Form.Fax")>
	<CFSET Fax = Form.Fax>
<CFELSE>
	<CFSET Fax = "">
</CFIF>
<CFIF isDefined("Form.Email")>
	<CFSET Email = Form.Email>
<CFELSE>
	<CFSET Email = "">
</CFIF>
<CFIF isDefined("Form.Login")>
	<CFSET Login = Form.Login>
<CFELSE>
	<CFSET Login = "">
</CFIF>
<CFIF isDefined("Form.Pwd")>
	<CFSET Pwd = Form.Pwd>
<CFELSE>
	<CFSET Pwd = "">
</CFIF>
<CFIF isDefined("Form.ConfPwd")>
	<CFSET ConfPwd = Form.ConfPwd>
<CFELSE>
	<CFSET ConfPwd = "">
</CFIF>

<CFIF isDefined("FORM.swUpdateRequestOnly")>
	<CFSET swUpdateRequestOnly = FORM.swUpdateRequestOnly>
<CFELSE>
	<CFSET swUpdateRequestOnly = false>
</CFIF>

<cfset readOnlyInit = false>
<cfset readOnlyForm = false>

<cfquery datasource="#application.dsn#" name="getHigherRoles">
SELECT role_id
FROM tlkp_role
WHERE roleType in ('BU', 'RF', 'RA', 'SA' , 'SU')
</cfquery>

<cfset BU_RF_LIST = "2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,25">

<cfset BU_RF_LIST = ValueList(getHigherRoles.role_id)>

<CFIF isDefined("URL.c") AND len(trim(URL.c))>
	<CFSET contactSelected = URL.c>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getContactInfo" returnvariable="qContactInfo">
		<cfinvokeargument name="contactID" value="#VARIABLES.contactSelected#">
	</cfinvoke>

	<CFSET FirstName = qContactInfo.FirstName>
	<CFSET LastName  = qContactInfo.LastName>
	<CFSET Address 	 = qContactInfo.Address>
	<CFSET Town 	 = qContactInfo.City>
	<CFSET State 	 = qContactInfo.State>
	<CFSET Zip 		 = qContactInfo.ZipCode>
	<CFSET HPhone 	 = qContactInfo.PhoneHome>
	<CFSET CPhone 	 = qContactInfo.PhoneCell>
	<CFSET WPhone 	 = qContactInfo.PhoneWork>
	<CFSET Fax 		 = qContactInfo.PhoneFax>
	<CFSET Email 	 = qContactInfo.Email>
	<CFSET Login 	 = qContactInfo.Username>
	<CFSET Pwd 		 = qContactInfo.password>
	<CFSET ConfPwd 	 = qContactInfo.password>
	<CFSET ClubSelected = qContactInfo.Club_id>
<!--- Joe Lechuga 7/15/2011 - Added active_yn field to Edit form --->
	<cfset active_yn = qContactInfo.active_yn>

	<cfif qContactInfo.APPROVE_YN EQ "N"> <!--- REJECTED new user request --->
		<CFSET swUpdateRequestOnly = true>
		<CFSET rejectComment = qContactInfo.REJECT_COMMENT>
	<cfelse>
		<CFSET swUpdateRequestOnly = false>
		<CFSET rejectComment = "">
	</cfif>
	
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getContactRoles" returnvariable="qContactRoles">
		<cfinvokeargument name="contactID" value="#VARIABLES.contactSelected#">
		<cfinvokeargument name="seasonID"  value="#SESSION.CURRENTSEASON.ID#">
	</cfinvoke>	
	<CFSET ROLES = valueList(qContactRoles.role_id)>
	<CFSET ROLESEASON = SESSION.CURRENTSEASON.ID>
	
	<cfloop list="#ROLES#" index="x">
		<cfif listfind(BU_RF_LIST,x) NEQ 0>
			<cfset readOnlyInit = true>
		</cfif>
	</cfloop>
	
</CFIF>

<cfif isdefined("FORM.UpdateContact") OR isdefined("form.updateAndRole")>

	<cfset swErrors = false>	
	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#FORM#">
	</cfinvoke>  
	
	<CFIF stValidFields.errors>
		<cfset swErrors = true>	
	</CFIF>
	
	<CFIF Pwd NEQ ConfPwd>
		<CFSET err = err & "<br>Your Passwords did not match.">
	</CFIF>

	<CFIF isDefined("SESSION.REGSEASON")>
		<CFSET useSeasonID = Session.RegSeason.ID>
	<CFELSE>
		<CFSET useSeasonID = Session.currentSeason.ID>
	</CFIF>

	
	
	<cfif len(trim(err))>
		<cfset swErrors = true>	
	</cfif>
	
	<CFIF NOT swErrors>
		<!--- passed validation --->
		<!--- <cfdump var="#FORM#"> --->
		<CFIF Form.contactSelected GT 0>
			<CFSET editContactID = Form.contactSelected>
		<CFELSE>
			<CFSET editContactID = "">
		</CFIF>
		
		<cfif isdefined('form.active_yn')>
			<cfset active_yn = form.active_yn>
		</cfif>
		
		 <cftry>
			 <!--- update contact info --->
			 <!--- Joe Lechuga 7/15/2011 - Added active_yn field to Edit form --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="updateALLContactInfo">
				<cfinvokeargument name="editContactID"	value="#VARIABLES.editContactID#">
				<cfinvokeargument name="clubID"			value="#VARIABLES.ClubSelected#">
				<cfinvokeargument name="username"		value="#VARIABLES.Login#">
				<cfinvokeargument name="firstName"		value="#VARIABLES.FirstName#">
				<cfinvokeargument name="lastName"		value="#VARIABLES.LastName#">
				<cfinvokeargument name="address"		value="#VARIABLES.Address#">
				<cfinvokeargument name="city"			value="#VARIABLES.Town#">
				<cfinvokeargument name="state"			value="#VARIABLES.State#">
				<cfinvokeargument name="zipcode"		value="#VARIABLES.Zip#">
				<cfinvokeargument name="phoneHome"		value="#VARIABLES.HPhone#">
				<cfinvokeargument name="phoneWork"		value="#VARIABLES.WPhone#">
				<cfinvokeargument name="phoneCell"		value="#VARIABLES.CPhone#">
				<cfinvokeargument name="phoneFax"		value="#VARIABLES.Fax#">
				<cfinvokeargument name="email"			value="#VARIABLES.Email#">
				<cfinvokeargument name="upDatedBy"	 	value="#SESSION.USER.CONTACTID#">
				<cfinvokeargument name="active_yn"	 	value="#VARIABLES.active_yn#">
			</cfinvoke>
			<cfquery name="CheckTheContact" datasource="#session.dsn#">
				select * from tbl_contact where contact_id = #VARIABLES.editContactID#
			</cfquery>
			
			<cfif variables.pwd NEQ "">
				<!--- update password --->
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="changePW">
					<cfinvokeargument name="contactid" value="#variables.editcontactid#">
					<cfinvokeargument name="password" value="#variables.Pwd#">
				</cfinvoke>
			</cfif>
			
			<cfcatch>
				<cfif cfcatch.detail EQ "userError">
					<cfset err = err & "<br>#cfcatch.message#">
					<cfset swErrors = true>
				<cfelse>
					<cfdump var=#cfcatch#><cfabort>
				</cfif>
			</cfcatch>
		</cftry>
		
		
		<CFSET newContactID = VARIABLES.editContactID>
		<!--- make sure the active flag is set to "Y" --->
<!--- 		<cfquery name="qAppContact" datasource="#SESSION.DSN#">
			UPDATE TBL_CONTACT
			   SET ACTIVE_YN = 'Y'
			 WHERE CONTACT_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.editContactID#">
		</cfquery>
 --->
		<CFSET Contact_ID = VARIABLES.newContactID>
		
		<CFIF len(trim(CONTACT_ID))>
			<CFSET contactSelected = contact_id>
			<CFSET p = "ok">
		<CFELSE>
			<CFSET err = err & "<br> There was a problem processing your request. Please click the back button and try again.">
		</CFIF>

		
		<cfif err EQ "">
			<cfif isdefined("form.updateAndRole")>
				<cflocation url="contactEditRoles.cfm?cid=#VARIABLES.ClubSelected#&contact_id=#contact_id#">
			<cfelse>
				<CFIF listFindNoCase(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID)>
					<cflocation url="contactEdit.cfm?c=#contactSelected#&s=1" addtoken="no">
				<CFELSE>
					<cflocation url="contactEdit.cfm?c=#contactSelected#&cid=#VARIABLES.ClubSelected#&s=1" addtoken="no">
				</CFIF>
			</cfif>
		</cfif>

		
		
	</CFIF>	<!--- END - IF swErrors --->
 
 </cfif> <!--- END - if isdefined("FORM.UpdateContact") --->
 
		
<cfif listFind(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID) NEQ 0 and readOnlyInit EQ true>
	<cfset readOnlyForm = true>
</cfif>

<!--- ============================================================================================= --->
<form name="frmContact" action="ContactEdit.cfm" method="post"<cfif readOnlyForm EQ true> onsubmit="return false"</cfif> autocomplete="off">
	<input type="Hidden" name="contactSelected" value="#VARIABLES.contactSelected#">	
	<input type="hidden" name="ClubSelected"	value="#VARIABLES.ClubSelected#">
	<input type="hidden" name="season_type" value="#season_type#">
	<input type="hidden" name="swUpdateRequestOnly" value="#VARIABLES.swUpdateRequestOnly#">
	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="95%">
		<tr class="tblHeading">
			<TD colspan="2"> &nbsp;Edit a Contact		</TD>
		</tr>
		<cfif isDefined("URL.P") AND URL.P EQ "ok">
			<TR><TD colspan="2" align="left" class="red">
					<b>This Contact was created.</b>
				</td>
			</TR>
		</cfif>
		<cfif isdefined("url.s")>
			<TR><TD colspan="2" align="left">
				<p>
					<span id="sysmsg" class="success">
						<strong>Contact information updated successfully.</strong>
					</span>
				</p>
				</td>
			</TR>
		</cfif>
		<cfif swErrors> <!--- len(Trim(err)) --->
			<TR><TD colspan="2" align="left" class="red">
					<p>
						<span id="sysmsg" class="error" style="display: block;">
								<b>Please correct the following errors and submit again.</b>
								<br>
								#stValidFields.errorMessage#
								#err#
						</span>
					</p>
				</td>
			</TR>
		</cfif>

		<CFIF swUpdateRequestOnly><!--- rejected request back for editing --->
			<CFSET swShowRoles = FALSE>	
			<CFSET swShowLoginPW = FALSE>
			<TR><TD colspan="2" align="center"> 
					<span Class="red"><b>Rejected Because:</b> #rejectComment#</span>				
				</TD>
			</TR>
		<CFELSE>
			<CFSET swShowRoles = TRUE>
			<CFSET swShowLoginPW = TRUE>
		</CFIF>		
		
		<CFIF listFind(SESSION.CONSTANT.AdminRoles,SESSION.MENUROLEID) EQ 0>
			<!--- we are logged in as "CU" as a CLUB user(rep,alt,pres) Do not allow user to change first and or last names	--->
			<CFSET swNameReadOnly = true>
		<CFELSE>
			<CFSET swNameReadOnly = false>
		</CFIF>

		<cfinclude template="contactForm_inc.cfm">
		
		<tr>
		<td colspan="2">
			<cfif readOnlyForm EQ true>
				<div id="guidelines" style="display: block;">
					<!---<strong>You are not authorized to make changes to this user profile. Please contact the NCSA administrator with requested changes.</strong>--->
					<strong>You are not authorized to make changes to this user profile because the contact has a role other than a club administrative or coach role. Please contact the NCSA administrator with any questions.<!--- administrator with requested changes. ---></strong>
				</div>
			</cfif>
		</td>
		</tr>
		
		<tr><td colspan="2"><hr></td>
		</tr>
		<tr><td colspan="2" align="center">
				<cfif readOnlyForm EQ false>
				<input type="submit" name="UpdateContact" value="Update Contact">
				<input type="submit" name="updateAndRole" value="Update and Set Roles">
				<cfelse>
				<input type="button" name="Cancel" value="&laquo; Back To Contact List" onclick="history.back(-1);">
				</cfif>
				<!--- <input type="submit" name="CreateContact" value="Add Another Contact"> --->
			</td>
		</tr>
	</table>
</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
