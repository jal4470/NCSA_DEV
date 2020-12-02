<!--- 
	FileName:	ncsaRef.cfm
	Created on: 11/14/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: Allows a person to submit a request to become a referee for the league.
	
MODS: mm/dd/yyyy - filastname - comments
05/20/2009 - aarnone - #7760 - added text at top of page.
7/30/2018 M Greenberg (Ticket NCSA27075) - updated style to make responsive
 --->

<cfset mid = 5> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<style>
 div{
      margin: 5px;}
.g-recaptcha{
  			margin-left: 30%;
  		}
.col2_town > input{
	width: 90%; }
.col4_state > input{
	width:45%; }
.col4_zip > input{
	width:60%; }
.col2_town{
	display: table-cell;
	width: 50%;
	margin: 3px;
	padding: 5px; }
.col4_state{
	display: table-cell;
	box-sizing: content-box;
	width: 18%;
	margin: 3px; }
.col4_zip{
	display: table-cell;
	box-sizing: content-box;
	margin: 3px; }
.col > input{
	width: 90%; }
.col2 > input{
		width: 80%; }
#first > input{
		width: 90%; }
.col2_town > input{
	width: 90%; }
.select_box{
	float: none !important; 
}
 .button{
   		text-align: center; }
  .questions{
  	text-align: center;
  	color: red;}
  .select_ref{
  	padding: 0px; }
@media screen and (max-width: 768px){
	#input{
		width: 100%; }

	#red{
		display:block;
		font-size: smaller; }
} 
.col2_town > input{
		width: 90%; }
	.col4_state > input{
		width:45%; }
	.col4_zip > input{
		width:60%; }
	.col2_town{
		display: table-cell;
		width: 50%;
		margin: 3px; }
	.col4_state{
		display: table-cell;
		box-sizing: content-box;
		width: 18%;
		margin: 3px; }
	.col4_zip{
		display: table-cell;
		box-sizing: content-box;
/*		width: 25%;*/
		margin: 3px; }

</style>
<cfhtmlhead text="<script src='https://www.google.com/recaptcha/api.js' async defer></script>">

<cfoutput>
<div id="contentText">
<h1 class="pageheading">NCSA - Request to Become an NCSA Referee</h1>

<cfset err = "">
<cfset contactSelected = 0 >
<cfset SWBOARDMEMBER = false>
<CFSET swShowSave = true>

<!--- === FORM VARS ==== --->
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

<!--- REFEREE specific information ------------------------------------------------------------------- --->
<CFIF isDefined("Form.refDob")>
	<CFSET refDob = Form.refDob>
<CFELSE>
	<CFSET refDob = "">
</CFIF> 
<CFIF isDefined("Form.refCertYear") AND isnumeric(form.refCertYear)>
	<CFSET refCertYear = Form.refCertYear>
<CFELSE>
	<CFSET refCertYear = "0">
</CFIF> 
<CFIF isDefined("Form.refNcsaLevel")>
	<CFSET refNcsaLevel = Form.refNcsaLevel>
<CFELSE>
	<CFSET refNcsaLevel = "">
</CFIF>
<CFIF isDefined("Form.grade")>
	<CFSET grade = Form.grade>
<CFELSE>
	<CFSET grade = "">
</CFIF>
<CFIF isDefined("Form.StateRegisteredIn")>
	<CFSET StateRegisteredIn = Form.StateRegisteredIn>
<CFELSE>
	<CFSET StateRegisteredIn = "">
</CFIF>
<CFIF isDefined("Form.Certified")>
	<CFSET Certified = Form.Certified>
<CFELSE>
	<CFSET Certified = "">
</CFIF>
<CFIF isDefined("Form.additionalRefInfo")>
	<CFSET additionalRefInfo = Form.additionalRefInfo>
<CFELSE>
	<CFSET additionalRefInfo = "">
</CFIF>

<cfset swErrors = false>	
<cfif isdefined("FORM.Save")>

	<cfset theForm = {}>
	<cfset theForm = structCopy(Form)>
	<cfset temp=StructDelete(theForm,"G-RECAPTCHA-RESPONSE")>
	<cfset theForm.fieldnames = replaceNoCase(theForm.fieldnames,",G-RECAPTCHA-RESPONSE","")>
	<cfset recaptcha = "#form["G-RECAPTCHA-RESPONSE"]#" > 
	<cfhttp url="https://www.google.com/recaptcha/api/siteverify" method="POST">
		<cfhttpparam type="formfield" name="secret" value="#Application.sitevars.captchaSecret#">
		<cfhttpparam type="formfield" name="response" value="#recaptcha#">
		<cfhttpparam type="formfield" name="remoteip" value="#CGI.REMOTE_ADDR#">
	</cfhttp>
	<!--- <cfdump var="#DeserializeJSON(cfhttp.filecontent)#"> --->
	<cfset captchaResponse = DeserializeJSON(cfhttp.filecontent)>

	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#theForm#">
	</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->
	
 	<CFIF stValidFields.errors>
		<cfset swErrors = true>	
	</CFIF>

	<cfif captchaResponse.success neq 'YES'>
		
		<cfset swErrors = true>

		<CFSET stValidFields.errors = stValidFields.errors + 1>
		<CFSET stValidFields.errorMessage = stValidFields.errorMessage &  "Something went Wrong! Please try again<br/>">
	</cfif>

	<!--- ------------------------------------------- --->
	<!--- if REF fields are available then check them --->
	<CFIF theForm.Certified EQ "Y">
		<CFIF isDefined("theForm.refCertYear") AND LEN(trim(theForm.refCertYear)) neq 4> 
			<cfset swErrors = true>
			<cfset err = err & " Year first certified must be a 4 digit year.">
		</CFIF>
	<CFELSE> <!--- NO was selected --->
		<CFIF isDefined("theForm.refCertYear") AND LEN(trim(theForm.refCertYear)) > 
			<cfset swErrors = true>
			<cfset err = err & " Year first certified must be blank if USSF Certified is No.">
		</CFIF>
	</CFIF>

	<CFIF NOT swErrors>
		<!--- passed validation --->
		<CFSET ClubID = 1> <!--- all refs are in clubId 1 --->

		<CFQUERY name="checkUser" datasource="#SESSION.DSN#">
			Select contact_id 
			  from tbl_contact
			 where FirstName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.FirstName#">
			   and LastName  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.LastName#">
			   and Email 	 = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.Email#">
		</CFQUERY>

		<CFIF checkUser.RECORDCOUNT AND false>
			<CFSET msg = "This contact already exists. Please contact NCSA for assistance.">
		<CFELSE>
			<cfset msg = "">
			<!--- CREATE the requested REFEREE - ROLEID = 25 --->	
			<CFIF isDefined("SESSION")>
				<CFSET useSeason = SESSION.regSeason.ID>
			<CFELSE>
				<CFSET useSeason = SESSION.currentSeason.ID>
			</CFIF>
			
			<!--- insert TBL_CONTACT --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="insertContact" returnvariable="newContactID">
				<cfinvokeargument name="username" 		value="">
				<cfinvokeargument name="password" 		value="">
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
				<cfinvokeargument name="active_yn" 		value="N">
				<cfinvokeargument name="createdBy" 		value="0">
				<cfinvokeargument name="club_id" 		value="1">
				<cfinvokeargument name="editContactID"  value="0">
				<cfinvokeargument name="isRequest"		value="true"> 
			</cfinvoke>
			
			<!--- REMOVED 7/28/2011 by J. Oriente: does the same thing as "insert xref_contact_role" call 10 lines down ... 
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="setContactRoleList">
				<cfinvokeargument name="contact_id" value="#newcontactid#">
				<cfinvokeargument name="season_id" value="#variables.useseason#">
				<cfinvokeargument name="role_list" value="25">
			</cfinvoke> --->
			
			<CFSET Contact_ID = VARIABLES.newContactID>
			<!--- [<cfdump var="#Contact_ID#">] --->

			<CFIF len(trim(CONTACT_ID))>
				<!--- INSERT XREF_CONTACT_ROLE --->
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="insertContactRole" returnvariable="xrefContactRoleID" >
					<cfinvokeargument name="contactID" value="#VARIABLES.Contact_ID#">
					<cfinvokeargument name="roleID"    value="25">
					<cfinvokeargument name="ClubId"    value="1">
					<cfinvokeargument name="seasonID"  value="#VARIABLES.useSeason#">
					<cfinvokeargument name="activeYN"  value="N">
					<cfinvokeargument name="allowGameEdit" value="0">
				</cfinvoke> <!--- [<cfdump var="#xrefContactRoleID#">] --->
				
				<CFIF len(trim(xrefContactRoleID))>
					<!--- UPDATE TBL_REFEREE_INFO - record was inserted as part of insertContactCole() --->
					<cfquery name="qGetRefinfoID" datasource="#SESSION.DSN#">
						SELECT REFEREE_INFO_ID FROM TBL_REFEREE_INFO WHERE CONTACT_ID = #VARIABLES.Contact_ID#
					</cfquery>
					
					<CFSET refInfoID = qGetRefinfoID.REFEREE_INFO_ID>
					<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="updateRefereeInfo" >
						<cfinvokeargument name="refInfoID" value="#VARIABLES.refInfoID#">
						<cfinvokeargument name="CertYN"    value="#VARIABLES.Certified#">
						<cfinvokeargument name="grade"     value="#VARIABLES.Grade#">
						<cfinvokeargument name="StateReg"  value="#VARIABLES.StateRegisteredIn#">
						<cfinvokeargument name="RefDOB"    value="#dateformat(VARIABLES.refDob,"mm/dd/yyyy")#">
						<cfinvokeargument name="certYEAR"  value="#VARIABLES.refCertYear#">
						<cfinvokeargument name="ncsaLevel" value="#VARIABLES.refNcsaLevel#">
						<cfinvokeargument name="additionalRefInfo" value="#VARIABLES.additionalRefInfo#">
					</cfinvoke>

					<!--- INSERT TBL_REFEREE_INFO  specific Data xrefContactRoleID--->
					<!--- <cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="insertRefereeInfo" returnvariable="refInfoID" >
						<cfinvokeargument name="RefereeID" value="#VARIABLES.Contact_ID#">
						<cfinvokeargument name="CertYN"    value="#VARIABLES.Certified#">
						<cfinvokeargument name="grade"     value="#VARIABLES.Grade#">
						<cfinvokeargument name="StateReg"  value="#VARIABLES.StateRegisteredIn#">
						<cfinvokeargument name="RefDOB"    value="#dateformat(VARIABLES.refDob,"mm/dd/yyyy")#">
						<cfinvokeargument name="certYEAR"  value="#VARIABLES.refCertYear#">
						<cfinvokeargument name="ncsaLevel" value="#VARIABLES.refNcsaLevel#">
						<cfinvokeargument name="additionalRefInfo" value="#VARIABLES.additionalRefInfo#">
					</cfinvoke> --->
					
					<CFIF len(trim(refInfoID))>
						<!--- <CFSET msg = "Your request has been submitted! <br> Contact the league office for Confirmation in 24hrs after Submiting the Form."> --->
						<CFSET msg = "Your request has been submitted! <br> Please allow several days for action on your application; for questions, contact NCSA Administrator. "> 
						<CFSET swShowSave = false>
					<CFELSE>
						<CFSET msg = "There was an problem processing you're request. Please contact NCSA for assistance.">
					</CFIF>
				<CFELSE>
					<CFSET msg = "There was an problem processing you're request. Please contact NCSA for assistance.">
				</CFIF>
			<CFELSE>
				<CFSET msg = "There was an problem processing you're request. Please contact NCSA for assistance.">
			</CFIF> <!--- END - IF len(trim(CONTACT_ID)) --->

		</CFIF><!--- END - IF checkUser.RECORDCOUNT --->

	</CFIF>	<!--- END - IF swErrors --->

 </cfif> <!--- END - if isdefined("FORM.UpdateContact") --->
 

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrStates">
	<cfinvokeargument name="listType" value="CLUBSTATES"> 
</cfinvoke> 

<!--- ============================================================================================= --->
<form name="frmContact" action="ncsaRef.cfm" method="post">
	<CFSET required = "<FONT color=red>*</FONT>">
		<div class="h2_new">

				Registration to become an NCSA Referee is for persons who are already USSF officials. If you wish to become a licensed USSF referee, please visit <a href="http://www.njrefs.com" target="_blank">www.njrefs.com</a> or <a href="http://www.eny-soccer-referees.org" target="_blank">www.eny-soccer-referees.org</a> for information; you must take a grade 8 entry level course to officiate travel games.
				<br>
				<br>
				NCSA welcomes interest from USSF officials in being assigned NCSA games.  Complete the information below and click "Save" at bottom of screen. Please allow a few days for us to contact you in response to your registration.
				<br>	
		</div>
		<cfif isDefined("VARIABLES.updMsg") AND len(trim(VARIABLES.updMsg))>
			<div>
				<span class="green"><b>#VARIABLES.updMsg#</b></span>
			</div>
		</cfif>
		<span class="red">Fields marked with * are required</span>

		<div class="Heading">&nbsp;</div>
		<cfif swErrors>
<!--- 			<TR><TD colspan="3" align="left" class="red"> --->
					<div class="red">
						<b>Please correct the following errors and submit again.</b>
						<br>
						#stValidFields.errorMessage#
						#err#
					</div>
			<!--- 	</td>
			</TR> --->
		</cfif>
		<cfif isDefined("VARIABLES.MSG") AND len(trim(msg)) >
			<!--- <TR><TD colspan="3" align="left" class="red"> --->
					<b>#msg#</b>
	
		</cfif>
		
		<CFSET swShowRoles = FALSE>	
		<CFSET swShowLoginPW = FALSE>	
		<CFSET swAllowRefEntry = TRUE>	
		<CFIF listFind(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID) GT 0>
	<!--- we are logged in as "CU" as a CLUB user(rep,alt,pres) Only show CLUB user ROLES	--->
	<CFSET swClubRolesOnly = TRUE>
<CFELSE>
	<CFSET swClubRolesOnly = FALSE>
</CFIF> 

<cfif NOT isDefined("swNameReadOnly")>
	<cfset swNameReadOnly = false>
</cfif>


<cfif NOT isDefined("readOnlyForm")>
	<cfset readOnlyForm = false>
</cfif>

<!---  <CFIF swShowRoles>
	<!--- use both cols --->
	<cfset col_1_width = "90%">
	<cfset col_2_width = "10%">
<cfelse>
	<!--- use one col --->
	<cfset col_1_width = "90%">
	<cfset col_2_width = "10%">
</CFIF>
 --->
<!---  <tr><td width="#col_1_width#" valign="top"> 
		<table><!--- start left side table ---> --->
	<div class="row form_field"><div class="col2"  id="first"><label>#required# First Name</label>
		<cfif swNameReadOnly>
				&nbsp; #FirstName#
				<input type="hidden" name="FirstName" value="#FirstName#">
			<cfelse>
				<cfif readOnlyForm EQ true>
					&nbsp; #FirstName#
				<cfelse>
					<input type="Text" name="FirstName"	value="#FirstName#">
				</cfif>
			</cfif>
			<input type="Hidden" name="FirstName_ATTRIBUTES" value="type=ALPHA~required=1~FIELDNAME=First Name">	
		</div>
<!--- 	</div>
	<div class="row form_field"> ---><div class="col2"><label>#required# Last Name</label>
			<cfif swNameReadOnly>
				&nbsp; #LastName#
				<input type="Hidden" name="LastName" value="#LastName#">
			<cfelse>
				<cfif readOnlyForm EQ true>
					&nbsp; #LastName#
				<cfelse>
					<input type="Text" name="LastName" value="#LastName#">
				</cfif>
			</cfif>
			<input type="Hidden" name="LastName_ATTRIBUTES" value="type=ALPHA~required=1~FIELDNAME=Last Name">		 
		</div>
	</div>
	<div class="row form_field"><div class="col"><label>#required# Address</label>
			<cfif readOnlyForm EQ true>
				&nbsp; #Address#
			<cfelse>
				<input type="Text"  maxlength="25" name="Address" value="#Address#">
			</cfif>
			<input type="Hidden" name="Address_ATTRIBUTES" 	value="type=NOSPECIALCHAR~required=1~FIELDNAME=Address">	
		</div>
	</div>
	<div class="row form_field"><div class="col2_town" id="first"><label>#required# Town</label>
			<cfif readOnlyForm EQ true>
				&nbsp; #Town#
			<cfelse>
				<input type="Text"  maxlength="25" name="Town" 	value="#Town#">
			</cfif>
			<input type="Hidden" name="Town_ATTRIBUTES" value="type=NOSPECIALCHAR~required=1~FIELDNAME=Town">	
		</div>
		<div class="col4_state"><label>#required# State</label>
			<cfif readOnlyForm EQ true>
				&nbsp; #State#
			<cfelse>
				<input type="Text"  maxlength="2" name="State" 	value="#State#" placeholder="NJ">
			</cfif>
			<input type="Hidden" name="State_ATTRIBUTES" value="type=STATE~required=1~FIELDNAME=State">	
		</Div>
		<div class="col4_zip"><label>#required# Zip</label>
			<cfif readOnlyForm EQ true>
				&nbsp; #Zip#
			<cfelse>
				<input type="Text"  maxlength="10" name="Zip" width="10" value="#Zip#">
			</cfif>
			<input type="Hidden" name="Zip_ATTRIBUTES" value="type=ZIPCODE~required=1~FIELDNAME=Zip Code">		
		</div>
	</div>
	<div class="row form_field"><div class="col2" id="first"><label>#required# Home Phone</label>
			<cfif readOnlyForm EQ true>
				&nbsp; #HPhone#
			<cfelse>
				<input type="Text"  maxlength="25" name="HPhone" value="#HPhone#" placeholder="999-999-9999">
			</cfif>
			<input type="Hidden" name="HPhone_ATTRIBUTES" value="type=PHONE~required=1~FIELDNAME=Home Phone" >
		</div>	
		<div class="col2"><label>#required# Cell Phone</label>
			<cfif readOnlyForm EQ true>
				&nbsp; #CPhone#
			<cfelse>
				<input type="Text"  maxlength="25" name="CPhone" value="#CPhone#" placeholder="999-999-9999">
			</cfif>
			<input type="Hidden" name="CPhone_ATTRIBUTES" value="type=PHONE~required=1~FIELDNAME=Cell Phone" >	
		</div>
	</div>
	<div class="row form_field"><div class="col2" id="first"> <label>Work Phone</label>
			<cfif readOnlyForm EQ true>
				&nbsp; #WPhone#
			<cfelse>
				<input type="Text"  maxlength="25" name="WPhone" value="#WPhone#" placeholder="999-999-9999">
			</cfif>
			<input type="Hidden" name="WPhone_ATTRIBUTES" value="type=PHONE~required=0~FIELDNAME=Work Phone">	
		</div>
		<div class="col2"><label>Fax</label>
			<cfif readOnlyForm EQ true>
				&nbsp; #Fax#
			<cfelse>
				<input type="Text"  maxlength="25" name="Fax" value="#Fax#" placeholder="999-999-9999">
			</cfif>
			<input type="Hidden" name="Fax_ATTRIBUTES" value="type=PHONE~required=0~FIELDNAME=Fax" >	
		</div>
	</div>
	<div class="row form_field"><div class="col"><label>#required# EMail</label>
			<cfif readOnlyForm EQ true>
				&nbsp; #EMail#
			<cfelse>
				<input type="Text" id="input" maxlength="100" name="EMail"  size="40" value="#EMail#">
			</cfif>
			<input type="Hidden" name="Email_ATTRIBUTES" 	value="type=EMAIL~required=1~FIELDNAME=Email">	
		</div>
	</div>
	<!--- Joe Lechuga 7/15/2011 - Added active_yn field to Edit form --->
	<cfif isdefined("active_yn") and readOnlyForm EQ false>
	<div class="row form_field"><div class="col"><label>Active</label>
			<select name="active_yn">
				<option value="Y" #iif(active_yn eq 'Y',de('selected=true'),de(''))#>Yes</option>
				<option value="N" #iif(active_yn eq 'N',de('selected=true'),de(''))#>No</option>
			</select>
		</div>
	</div>
	<cfelseif isdefined("active_yn")>
		<input type="hidden" name="active_yn" value="#active_yn#">
	</cfif>
	<CFIF swShowLoginPW AND readOnlyForm EQ false>
		<div class="row form_field"><div class="col"><label>Login</label>
				<input type="Text"  maxlength="100" name="Login"	value="#Login#" >
				<input type="Hidden" name="Login_ATTRIBUTES" 	value="type=NOSPECIALCHAR~FIELDNAME=Login">
			</div>	
		</div>
		<div class="row form_field"><div class="col"><label>Password</label>
				<input type="Password" maxlength="100" name="Pwd" 	value="#Pwd#" >
				<input type="Hidden" name="Pwd_ATTRIBUTES" 	value="type=GENERIC~FIELDNAME=Password">	
			</div>
		</div>
		<div class="row form_field"><div class="col"><label>Confirm Password</label>
				<input type="Password" maxlength="100" name="ConfPwd" 	value="#ConfPwd#" >
				<input type="Hidden" name="ConfPwd_ATTRIBUTES" 	value="type=GENERIC~FIELDNAME=Confirm Password">
			</div>
		</div>
	</CFIF>
	<!--- ------------------------------------------------------------------------------------------------ --->
	<!--- REFEREE specific information ------------------------------------------------------------------- --->
	<CFIF SESSION.MENUROLEID EQ 25 OR isDefined("swAllowRefEntry")>		<!--- MENUROLEID=25=Referee 1=ADMIN --->
		<!--- <CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
			<CFSET refDisableText = "">
		<CFELSE>
			<CFSET refDisableText = "disabled">
		</CFIF> --->
		<div class="Heading">Referee Specific information</div>

		<div class="row form_field"><div class="col2" id="first"><label>#required# Date Of Birth</label>
			<CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
					<input type="Text"  maxlength="10" name="refDob"  value="#refDob#" placeholder="mm/dd/yyyy">
					<input type="Hidden" name="refDob_ATTRIBUTES" 	value="type=DATE~required=1~FIELDNAME=Date Of Birth">	
				<CFELSE>
					#refDob#
				</CFIF>
			</div>
			<div class="col2"><label>#required# Grade</label>
			<CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
					<input maxlength="5" name="Grade"  value="#Grade#" >
					<input type="Hidden" name="Grade_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Grade">	
				<CFELSE>
					#Grade#
				</CFIF>
			</div>
		</div>
		<div class="row form_field">
			<div class="col2 select_ref" id="first"><label>#required# State Registered In</label>
			<CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
				<div class="select_box">
					<SELECT name="StateRegisteredIn"  > 
						<OPTION value="" selected>select state</OPTION>
						<cfloop from="1" to="#arrayLen(arrStates)#" index="iSt">
							<OPTION value="#arrStates[iSt][1]#" <cfif StateRegisteredIn EQ arrStates[iSt][1]>selected</cfif> >#arrStates[iSt][1]#</OPTION>
						</cfloop>
					</SELECT>
				</div>
					<input type="Hidden" name="StateRegisteredIn_ATTRIBUTES" 	value="type=STATE~required=1~FIELDNAME=State Registered In">	
				<CFELSE>
					#StateRegisteredIn#
				</CFIF>
			</div>
			<div class="col2 select_ref"><label>#required# USSF Certified</label>
			<CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
				<div class="select_box">
					<SELECT name="Certified" > 
						<OPTION value="Y" <cfif Certified EQ "Y">selected</cfif> > Yes</OPTION>
						<OPTION value="N" <cfif Certified EQ "N">selected</cfif> > No</OPTION>
					</SELECT>
				</div>
					<input type="Hidden" name="Certified_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=USSF Certified">	
				<CFELSE>
					#Certified#
				</CFIF>
			</div>
		</div>
		<div class="row form_field"><div class="col"><label>#required# Year First Certified</label>
			<CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
					<input type="Text"  maxlength="4" name="refCertYear"  value="#refCertYear#" placeholder="yyyy">
					<input type="Hidden" name="refCertYear_ATTRIBUTES" value="type=Numeric~required=0~FIELDNAME=Year First Certified">	
				<CFELSE>
					#refCertYear#
				</CFIF>
			</div>
		</div>
		<CFIF isDefined("SESSION.MENUROLEID") AND ( SESSION.MENUROLEID EQ 0 OR SESSION.MENUROLEID EQ 1)>
		<!--- only show if Applying for ref (no menuroleid: public page) or you are an admin --->
			<div class="row form_field">
				<div class="col">
					<label>Additional Info</label>
					<CFIF isDefined("swAllowRefEntry") AND swAllowRefEntry>
						<!--- <input type="Text"  maxlength="4" name="additionalRefInfo"  value="#additionalRefInfo#"> --->
						<TEXTAREA id="input" name="additionalRefInfo" rows=3  cols=50>#Trim(additionalRefInfo)#</TEXTAREA>
						<input type="Hidden" name="additionalRefInfo_ATTRIBUTES" value="type=NOSPECIALCHAR~required=0~FIELDNAME=Additional Info">	
					<CFELSE>
						#additionalRefInfo#
					</CFIF>
				</div>
			</div>
		</CFIF>
		<CFIF isDefined("SESSION.MENUROLEID") AND SESSION.MENUROLEID EQ 1 >
		<!--- only show to admin --->
			<div class="row form_field">
				<div class="col">
					<label>NCSA Level</label>
				<input type="Text"  maxlength="4" name="refNcsaLevel" 	value="#refNcsaLevel#">
				</div>
			</div>
		</CFIF>
	</CFIF> <!--- END Referee specific info -------------------------------------------------------------------- --->

	<!--- ----------------------------------------------------------------------------------------------------------- --->
	<!--- Board Member Specific Info.... ---------------------------------------------------------------------------- --->
	<CFIF swBoardMEMBER>
		<input type="Hidden" name="Sequence"	  value="#VARIABLES.Sequence#">
		<input type="Hidden" name="boardMemberID" value="#VARIABLES.boardMemberID#">
		<input type="Hidden" name="ncsaTitle"	  value="#VARIABLES.ncsaTitle#">
		<div class="Heading"> Board Member Specific information</div>

		<div class="row form_field">
			<div class="col">
				<label>#required# NCSA Phone</label>
			<input type="Text"  maxlength="25" name="ncsaPhone" 	value="#ncsaPhone#" >
				<input type="Hidden" name="ncsaPhone_ATTRIBUTES" value="type=PHONE~required=1~FIELDNAME=NCSA Phone">	
			</div>
		</div>
		<div class="row form_field">
			<div class="col">
				<label>#required# NCSA Fax</label>
			<input type="Text"  maxlength="25" name="ncsaFax" 	value="#ncsaFax#" >
				<input type="Hidden" name="ncsaFax_ATTRIBUTES" value="type=PHONE~required=1~FIELDNAME=NCSA Fax">	
			</div>
		</div>
		<div class="row form_field">
			<div class="col">
				<label>#required# NCSA Email</label>
			<input type="Text"  maxlength="25" name="ncsaEmail" 	value="#ncsaEmail#" >
				<input type="Hidden" name="ncsaEmail_ATTRIBUTES" value="type=EMAIL~required=1~FIELDNAME=NCSA Email">	
			</div>
		</div>
	</CFIF>
		<!--- <cfinclude template="contactForm_inc.cfm"> --->
		<CFIF swShowSave>
<!--- 			<tr><td colspan="3" align="center"> --->
					<!--- <span class="red"> Please allow several days for action on your application; for questions, contact NCSA Administrator. <br>Please also register to be a referee for NCSA at its calendar site <a href="http://www.assignbyweb.com/ncsa" target="_blank">www.assignbyweb.com/ncsa</a> 	</span>  --->
			<div class="questions">For questions, contact NCSA Administrator.</div>
			<div class="row form_field">
				<div class="col">
					<div class="g-recaptcha" data-sitekey="#Application.sitevars.captchaSiteKey#"></div>
				</div>
			</div>
			<div class="row button">
				<div class="col">
					<button type="submit" name="Save" value="Save" class="yellow_btn">Save</button>
				</div>
			</div>
		</CFIF>
</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
