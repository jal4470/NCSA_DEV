<!--- 
	FileName:	contactCreate.cfm
	Created on: 09/12/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
12/09/08 - AA - removed SESSION.WorkClubId and replaced with clubID
01/13/09 - AA - changed to use the reseason if defined, else current season
1/27/2011-B.Cooper - 10137 - commented out code to add roles.  this should never be run, but might be causing issues.
07/06/2012 - J. Rab - Modified success message from server
08/12/2012 - J. Rab - Disabled autotcomplete on form.
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfset swErrors = false>	
<cfset err = "">
<cfset p   = "">
<cfset C   = "">
<CFSET swBoardMEMBER = false>

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Create a Contact</H1>
<br>
<!--- <h2>yyyyyy </h2> --->

<CFSET Season_type = "current"> <!---  optional values are reg for Registration and tempreg for temp registration --->
<cfif IsDefined("URL.st")>
	<CFSET Season_type = URL.st>
</cfif>

<CFSET RoleWhereClause = "">
<CFIF SESSION.menuroleid EQ "list of CU ids" > <!--- If session("ProfileType") = "CU" Then --->
	<CFSET RoleWhereClause = " WHERE ROLETYPE = 'CU' ">
</CFIF>

<CFIF isDefined("URL.cid")>
	<CFSET ClubId = URL.cid>
<CFELSEIF isDefined("FORM.Clubselected")>
	<CFSET ClubId = FORM.Clubselected>
<CFELSE>
	<CFSET ClubId = 0>
</CFIF>

<!--- <CFIF ClubID GT 0>
	<!--- Session("WorkClubId") = ClubID --->
	<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
		<CFSET SESSION.WorkClubId = ClubID>
	</CFLOCK>
<CFELSE>
	<!--- Session("WorkClubId") = Session("LoginClubId") --->
	<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
		<CFSET SESSION.WorkClubId = SESSION.USER.CLUBID>
	</CFLOCK>
</CFIF> --->


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
<CFIF isDefined("Form.Login") AND len(trim(Form.Login))>
	<CFSET Login = Form.Login>
<CFELSE>
	<CFSET Login = "">
</CFIF>
<CFIF isDefined("Form.Pwd") AND len(trim(Form.Pwd))>
	<CFSET Pwd = Form.Pwd>
<CFELSE>
	<CFSET Pwd = "">
</CFIF>
<CFIF isDefined("Form.ConfPwd") AND len(trim(Form.ConfPwd))>
	<CFSET ConfPwd = Form.ConfPwd>
<CFELSE>
	<CFSET ConfPwd = "">
</CFIF>

<CFIF isDefined("FORM.ROLES")>
	<CFSET ROLES = FORM.ROLES>
<CFELSE>
	<CFSET ROLES = "">
</CFIF>


<cfif isdefined("FORM.CreateContact") OR isDefined("FORM.RequestNewContact")>
	<!---  we are either CREATEING a new contact - admin/league users OR
		   we are REQUESTING a new contact - club users
	--->
	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#FORM#">
	</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->
	
	<CFIF stValidFields.errors>
		<cfset swErrors = true>	
	</CFIF>

	<cfif isdefined("FORM.CreateContact")>
		<!--- CREATE requires these, REQUEST does not --->
		<cfset isRequest = "false"> <!--- used in CONTACT.insertContact cfc --->
	<cfelse>
		<cfset isRequest = "true"> <!--- used in CONTACT.insertContact cfc --->
	</cfif>
	
	<cfif len(trim(err))>
		<cfset swErrors = true>	
	</cfif>

	<CFIF NOT swErrors>
		<!--- passed validation --->
		<!--- <cfdump var="#FORM#"> --->
		<CFIF Form.Clubselected GT 0>
			<CFSET ClubID = Form.Clubselected>
		<!--- <CFELSE>
			<CFSET ClubID = Session.WorkClubId> --->
		</CFIF>

		<CFQUERY name="checkUser" datasource="#SESSION.DSN#">
			Select contact_id 
			  from tbl_contact
			 where FirstName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.FirstName#">
			   and LastName  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.LastName#">
		</CFQUERY> <!--- and Email 	 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Email#"> --->
		
		<CFIF checkUser.RECORDCOUNT>
			<CFSET err = "This contact already exists.">
		<CFELSE>
			<!--- does the club exist in the current season or the next one????
			<CFQUERY name="clubSeason" datasource="#SESSION.DSN#">
				Select club_id 
				  from xref_club_season
				 where club_id   = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.clubID#">
				   and season_id = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#SESSION.currentSeason.ID#">
			</CFQUERY>
			
			<CFIF clubSeason.RECORDCOUNT>
				<!--- no club found in current season, check next season --->
				<CFQUERY name="regSeason" datasource="#SESSION.DSN#">
					select season_id 
					  from tbl_season 
					 where registrationOpen_YN = 'Y'
				</CFQUERY>
				<CFSET useSeason = regSeason.season_id>
			<CFELSE>
				<CFSET useSeason = Session.currentSeason.ID>
			</CFIF> --->
			<CFIF isDefined("SESSION.REGSEASON")>
				<CFSET useSeason = Session.RegSeason.ID>
			<CFELSE>
				<CFSET useSeason = Session.currentSeason.ID>
			</CFIF>
	
			<!--- CREATE the USER --->	
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="insertContact" returnvariable="newContactID">
				<cfinvokeargument name="username" 		value="#VARIABLES.Login#">
				<cfinvokeargument name="password" 		value="#VARIABLES.Pwd#">
				<cfinvokeargument name="firstName" 		value="#VARIABLES.FirstName#">
				<cfinvokeargument name="lastName" 		value="#VARIABLES.LastName#">
				<cfinvokeargument name="address" 		value="#VARIABLES.Address#">
				<cfinvokeargument name="city" 			value="#VARIABLES.Town#">
				<cfinvokeargument name="state" 			value="#VARIABLES.State#">
				<cfinvokeargument name="zipcode" 		value="#VARIABLES.Zip#">
				<cfinvokeargument name="phoneHome" 		value="#VARIABLES.HPhone#">
				<cfinvokeargument name="phoneWork" 		value="#VARIABLES.WPhone#">
				<cfinvokeargument name="phoneCell" 		value="#VARIABLES.CPhone#">
				<cfinvokeargument name="phoneFax" 		value="#VARIABLES.Fax#">
				<cfinvokeargument name="email" 			value="#VARIABLES.Email#">
				<cfinvokeargument name="active_yn" 		value="Y">
				<cfinvokeargument name="createdBy" 		value="#SESSION.USER.CONTACTID#">
				<cfinvokeargument name="club_id" 		value="#VARIABLES.ClubID#">
				<cfinvokeargument name="editContactID"  value="0">
				<cfinvokeargument name="isRequest"		value="#VARIABLES.isRequest#"> 
			</cfinvoke>
			
			<!--- <cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="setContactRoleList">
				<cfinvokeargument name="contact_id" value="#newcontactid#">
				<cfinvokeargument name="season_id" value="#variables.useseason#">
				<cfinvokeargument name="role_list" value="#variables.roles#">
			</cfinvoke> --->

			<CFSET Contact_ID = VARIABLES.newContactID>
			
			<CFIF len(trim(CONTACT_ID))>
				<CFSET contactSelected = contact_id>
				<CFSET p = "ok">
				<!--- <cfif isdefined("FORM.CreateContact")>
					<cflocation url="contactEdit.cfm?p=ok&c=#CONTACT_ID#">
				<CFELSE><!--- REQUEST THE USER --->
					<cflocation url="contactList.cfm?p=ok&c=#CONTACT_ID#">
				</cfif> --->		
				<cflocation url="contactList.cfm?p=ok&c=#CONTACT_ID#&cid=#VARIABLES.ClubID#">
			<CFELSE>
				<CFSET err = err & "<br> There was an problem processing you're request. Please click the back button and try again.">
			</CFIF>
		
		
		</CFIF><!--- END - IF checkUser.RECORDCOUNT --->
	</CFIF>	<!--- END - IF swErrors --->
</cfif>



<CFIF listFind(SESSION.CONSTANT.CUroles,SESSION.menuRoleID) GT 0>
	<cfset swClubUser = true>
<cfelse>
	<cfset swClubUser = false>
</CFIF>  
 
<form name="frmContact" action="ContactCreate.cfm" method="post" autocomplete="off">
	<input type="Hidden" name="contactSelected" value="#VARIABLES.contactSelected#">	
	<input type="hidden" name="season_type" value="#season_type#">

	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="95%">
		<tr class="tblHeading">
			<!--- <TD> &nbsp;		</TD> --->
			<TD colspan="2" align="center"> &nbsp;Create a Contact		</TD>
		</tr>
		</TR>
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
		<CFIF len(trim(err))>
			<TR><TD colspan="2" align="left" class="red">
					#err#
				</td>
			</TR>
		</CFIF>
		<cfif p EQ "ok">
			<TR><TD colspan="2" class="ok" align="center">Contact #c# was created successfully!</td>
			</TR>
		</cfif>
			
		
		<CFIF swClubUser>  
			<!--- user logged in IS a CLUB user, they can only see their own club --->
			<input type="Hidden" name="Clubselected" value="#SESSION.USER.CLUBID#">	
		<CFELSE>
			<!--- user logged in is NOT a CLUB user, so they can select any club --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubs">
				<cfinvokeargument name="orderby" value="clubname">
			</cfinvoke>
			<TR><TD align="left" colspan="2">&nbsp; &nbsp; &nbsp; 
				#required# <b>Select a Club:</b> 
				 <Select name="Clubselected">
						<option value="0" <CFIF VARIABLES.ClubId EQ 0>selected</CFIF> >Select A Club</option>
						<CFLOOP query="qClubs">
							<!--- <option value="#CLUB_ID#" <CFIF CLUB_ID EQ Session.WorkClubId>selected</CFIF> >#CLUB_NAME#</option> --->
							<option value="#CLUB_ID#" <CFIF CLUB_ID EQ VARIABLES.ClubId>selected</CFIF> >#CLUB_NAME#</option>
						</CFLOOP>
					</SELECT>
				</TD>
			</TR>
		</CFIF>
		<input type="Hidden" name="Clubselected_ATTRIBUTES" 	value="type=NUMGTZERO~required=1~FIELDNAME=Club">	
		<CFIF swClubUser>
			<CFSET swShowRoles = FALSE>
			<CFSET swShowLoginPW = TRUE>
		<CFELSE>
			<CFSET swShowRoles = TRUE>	
			<CFSET swShowLoginPW = TRUE>	
		</CFIF>
		<cfinclude template="contactForm_inc.cfm">
		
		<cfif swShowRoles>
			<TR><TD colspan="2">&nbsp;</TD>   	</TR>
			<TR><TD colspan="2">&nbsp;</TD>   	</TR>
			<TR><TD colspan="2">&nbsp;</TD>   	</TR>
		</cfif>
		<TR><TD colspan="2" align="center">
				<CFIF swClubUser>
					<span class="red">
						New users are subjet to approval by NCSA, once approved, users can be assigned to a role. 
					</span>
				<CFELSE>
					&nbsp;
				</CFIF>
			</TD>
		</TR>
		
		<tr><td colspan="2"><hr></td>
		</tr>
		<tr><td colspan="2" align="center">
				<CFIF swClubUser>
					<input tabindex="12" type="submit" name="RequestNewContact" value="Create Contact">
				<CFELSE>
					<input tabindex="12" type="submit" name="CreateContact" value="Create Contact">
				</CFIF>
			</td>	
		</tr>
	</table>
</form>
	

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
