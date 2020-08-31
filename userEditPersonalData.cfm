<!--- 
	FileName:	userEditPersonalData.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfset err = "">

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Edit Personal Information</H1>

<!--- <br> <h2>yyyyyy </h2> --->

<CFIF isDefined("SESSION.USER.CONTACTID")>
	<CFSET contactSelected = SESSION.USER.CONTACTID >
<CFELSEIF isDefined("FORM.contactSelected") AND FORM.contactSelected GT 0 >
	<CFSET contactSelected = FORM.contactSelected >
<CFELSE>
	<CFSET contactSelected = 0 >
</CFIF>

<CFSET swBoardMEMBER = false>
<CFIF contactSelected GT 0>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getContactInfo" returnvariable="qContactInfo">
		<cfinvokeargument name="contactID" value="#VARIABLES.contactSelected#">
	</cfinvoke>

	<!--- check if logged in as BOARD MEMBER --->
	<CFIF isDefined("SESSION.MENUROLEID") AND listFind("1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24",SESSION.MENUROLEID) GT 0>
		<cfif isDefined("SESSION.USER.CONTACTROLEID") AND len(trim(SESSION.USER.CONTACTROLEID))>
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getBoardMemberInfo" returnvariable="qBoardMemberInfo">
				<cfinvokeargument name="dsn" value="#SESSION.DSN#">
				<cfinvokeargument name="RoleID" value="#SESSION.USER.CONTACTROLEID#">
				<cfinvokeargument name="ContactID" value="#VARIABLES.contactSelected#">
			</cfinvoke> <!--- <cfinvokeargument name="xrefContactRoleID" value="#SESSION.USER.CONTACTROLEID#"> --->

	
			<CFIF qBoardMemberInfo.RECORDCOUNT>
				<CFSET swBoardMEMBER = true>
			</CFIF>	
		</cfif>
	</CFIF>


</CFIF>

<!--- === FORM VARS ==== --->
<CFIF isDefined("Form.FirstName")>
	<CFSET FirstName = Form.FirstName>
<CFELSEIF isDefined("qContactInfo.FirstName")>
	<CFSET FirstName = qContactInfo.FirstName>
<CFELSE>
	<CFSET FirstName = "">
</CFIF>

<CFIF isDefined("Form.LastName")>
	<CFSET LastName = Form.LastName>
<CFELSEIF isDefined("qContactInfo.LastName")>
	<CFSET LastName  = qContactInfo.LastName>
<CFELSE>
	<CFSET LastName = "">
</CFIF>
<CFIF isDefined("Form.Address")>
	<CFSET Address = Form.Address>
<CFELSEIF isDefined("qContactInfo.Address")>
	<CFSET Address 	 = qContactInfo.Address>
<CFELSE>
	<CFSET Address = "">
</CFIF>
<CFIF isDefined("Form.Town")>
	<CFSET Town = Form.Town>
<CFELSEIF isDefined("qContactInfo.City")>
	<CFSET Town 	 = qContactInfo.City>
<CFELSE>
	<CFSET Town = "">
</CFIF>
<CFIF isDefined("Form.State")>
	<CFSET State = Form.State>
<CFELSEIF isDefined("qContactInfo.State")>
	<CFSET State 	 = qContactInfo.State>
<CFELSE>
	<CFSET State = "">
</CFIF>
<CFIF isDefined("Form.Zip")>
	<CFSET Zip = Form.Zip>
<CFELSEIF isDefined("qContactInfo.ZipCode")>
	<CFSET Zip 		 = qContactInfo.ZipCode>
<CFELSE>
	<CFSET Zip = "">
</CFIF>
<CFIF isDefined("Form.HPhone")>
	<CFSET HPhone = Form.HPhone>
<CFELSEIF isDefined("qContactInfo.PhoneHome")>
	<CFSET HPhone 	 = qContactInfo.PhoneHome>
<CFELSE>
	<CFSET HPhone = "">
</CFIF>
<CFIF isDefined("Form.CPhone")>
	<CFSET CPhone = Form.CPhone>
<CFELSEIF isDefined("qContactInfo.PhoneCell")>
	<CFSET CPhone 	 = qContactInfo.PhoneCell>
<CFELSE>
	<CFSET CPhone = "">
</CFIF>
<CFIF isDefined("Form.WPhone")>
	<CFSET WPhone = Form.WPhone>
<CFELSEIF isDefined("qContactInfo.PhoneWork")>
	<CFSET WPhone 	 = qContactInfo.PhoneWork>
<CFELSE>
	<CFSET WPhone = "">
</CFIF>
<CFIF isDefined("Form.Fax")>
	<CFSET Fax = Form.Fax>
<CFELSEIF isDefined("qContactInfo.PhoneFax")>
	<CFSET Fax 		 = qContactInfo.PhoneFax>
<CFELSE>
	<CFSET Fax = "">
</CFIF>
<CFIF isDefined("Form.Email")>
	<CFSET Email = Form.Email>
<CFELSEIF isDefined("qContactInfo.Email")>
	<CFSET Email 	 = qContactInfo.Email>
<CFELSE>
	<CFSET Email = "">
</CFIF>
<!--- ------------------------------------------------------------------------------------------------ --->
<!--- REFEREE specific information ------------------------------------------------------------------- --->
<CFIF SESSION.MENUROLEID EQ 25 > <!--- .MENUROLEID=25=REFEREE  --->
	<cfif isDefined("SESSION.REGSEASON.ID")> <!--- extra info may be in next season --->
		<cfset refSeasonID = SESSION.REGSEASON.ID>
	<CFELSE>	
		<cfset refSeasonID = SESSION.CURRENTSEASON.ID>
	</cfif>
	
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo">
		<cfinvokeargument name="refereeID" value="#VARIABLES.contactSelected#">
		<cfinvokeargument name="seasonID" value="#VARIABLES.refSeasonID#">
	</cfinvoke>
	
	<CFIF isDefined("Form.refInfoID")>
		<CFSET refInfoID = Form.refInfoID>
	<CFELSEIF isDefined("qRefInfo.referee_info_id")>
		<CFSET refInfoID 	 = qRefInfo.referee_info_id>
	<CFELSE>
		<CFSET refInfoID = "">
	</CFIF> 
	<CFIF isDefined("Form.refDob")>
		<CFSET refDob = Form.refDob>
	<CFELSEIF isDefined("qRefInfo.birth_date")>
		<CFSET refDob 	 = dateformat(qRefInfo.birth_date,"mm/dd/yyyy")>
	<CFELSE>
		<CFSET refDob = "">
	</CFIF> 
	<CFIF isDefined("Form.refCertYear")>
		<CFSET refCertYear = Form.refCertYear>
	<CFELSEIF isDefined("qRefInfo.certified_1st_year")>
		<CFSET refCertYear 	 = qRefInfo.certified_1st_year>
	<CFELSE>
		<CFSET refCertYear = "">
	</CFIF> 
	<CFIF isDefined("Form.refNcsaLevel")>
		<CFSET refNcsaLevel = Form.refNcsaLevel>
	<CFELSEIF isDefined("qRefInfo.Ref_level")>
		<CFSET refNcsaLevel 	 = qRefInfo.Ref_level>
	<CFELSE>
		<CFSET refNcsaLevel = "">
	</CFIF>

	<CFIF isDefined("Form.grade")>
		<CFSET grade = Form.grade>
	<CFELSEIF isDefined("qRefInfo.grade")>
		<CFSET grade = qRefInfo.grade>
	<CFELSE>
		<CFSET grade = "">
	</CFIF>

	<CFIF isDefined("Form.StateRegisteredIn")>
		<CFSET StateRegisteredIn = Form.StateRegisteredIn>
	<CFELSEIF isDefined("qRefInfo.StateRegisteredIn")>
		<CFSET StateRegisteredIn 	 = qRefInfo.StateRegisteredIn>
	<CFELSE>
		<CFSET StateRegisteredIn = "">
	</CFIF>

	<CFIF isDefined("Form.Certified")>
		<CFSET Certified = Form.Certified>
	<CFELSEIF isDefined("qRefInfo.certified_yn")>
		<CFSET Certified 	 = qRefInfo.certified_yn>
	<CFELSE>
		<CFSET Certified = "">
	</CFIF>
	
	<CFIF isDefined("Form.additionalRefInfo")>
		<CFSET additionalRefInfo = Form.additionalRefInfo>
	<CFELSEIF isDefined("qRefInfo.additional_ref_info")>
		<CFSET additionalRefInfo = qRefInfo.additional_ref_info>
	<CFELSE>
		<CFSET additionalRefInfo = "">
	</CFIF>
	
	
</CFIF><!--- END - REFEREE specific information ------------------------------------------------------------------------ --->
<!--- Coach --->
<CFIF SESSION.MENUROLEID EQ 29 > 
	<CFIF isDefined("Form.pass_number")>
		<CFSET pass_number = Form.pass_number>
	<CFELSEIF isDefined("qContactInfo.pass_number")>
		<CFSET pass_number = qContactInfo.pass_number>
	<CFELSE>
		<CFSET pass_number = "">
	</CFIF>
<CFELSE>
	<CFSET pass_number = "">
</CFIF>
<!--- ----------------------------------------------------------------------------------------------------------- --->
<!--- Board Member Specific Info.... ---------------------------------------------------------------------------- --->
<CFIF swBoardMEMBER>
	<cfif isDefined("FORM.boardMemberID")>
		<cfset boardMemberID = FORM.boardMemberID>
	<cfelseif isDefined("qBoardMemberInfo.boardmember_id")>
		<cfset boardMemberID = qBoardMemberInfo.boardmember_id>
	<cfelse>
		<cfset boardMemberID = "">		
	</cfif>
	<cfif isDefined("FORM.Sequence")>
		<cfset Sequence = FORM.Sequence>
	<cfelseif isDefined("qBoardMemberInfo.Sequence")>
		<cfset Sequence = qBoardMemberInfo.Sequence>
	<cfelse>
		<cfset Sequence = "">		
	</cfif>
	<cfif isDefined("FORM.ncsaTitle")>
		<cfset ncsaTitle = FORM.ncsaTitle>
	<cfelseif isDefined("qBoardMemberInfo.ncsa_Title")>
		<cfset ncsaTitle = qBoardMemberInfo.ncsa_Title>
	<cfelse>
		<cfset ncsaTitle = "">		
	</cfif>
	<cfif isDefined("FORM.ncsaPhone")>
		<cfset ncsaPhone = FORM.ncsaPhone>
	<cfelseif isDefined("qBoardMemberInfo.NCSAPhone")>
		<cfset ncsaPhone = qBoardMemberInfo.NCSAPhone>
	<cfelse>
		<cfset ncsaPhone = "">		
	</cfif>
	<cfif isDefined("FORM.ncsaFax")>
		<cfset ncsaFax = FORM.ncsaFax>
	<cfelseif isDefined("qBoardMemberInfo.NCSAFax")>
		<cfset ncsaFax = qBoardMemberInfo.NCSAFax>
	<cfelse>
		<cfset ncsaFax = "">		
	</cfif>
	<cfif isDefined("FORM.ncsaEmail")>
		<cfset ncsaEmail = FORM.ncsaEmail>
	<cfelseif isDefined("qBoardMemberInfo.NCSAEmail")>
		<cfset ncsaEmail = qBoardMemberInfo.NCSAEmail>
	<cfelse>
		<cfset ncsaEmail = "">		
	</cfif>
</CFIF> <!--- END board member INFO --->


<cfset swErrors = false>	
<cfif isdefined("FORM.Save")>
	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#FORM#">
	</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->
	
	<CFIF stValidFields.errors>
		<cfset swErrors = true>	
	</CFIF>
	
	<!--- ------------------------------------------- --->
	<!--- if REF fields are available then check them --->
	<CFIF isDefined("Form.refCertYear") AND NOT LEN(trim(Form.refCertYear)) eq 4> 
		<cfset swErrors = true>
		<cfset err = err & " Year first certified must be a 4 digit year.">
	</CFIF>

	
	<CFIF NOT swErrors>
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="updateContactInfo" returnvariable="spStatus">
			<cfinvokeargument name="contactID" 		value="#VARIABLES.contactSelected#">
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
			<cfinvokeargument name="pass_number" 	value="#VARIABLES.Pass_Number#">
			<cfinvokeargument name="createdBy" 		value="#SESSION.USER.CONTACTID#">
		</cfinvoke>

		<CFIF spStatus.statusCode EQ 0>
			<CFSET p = "ok">
			<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
				<CFSET SESSION.USER.Fname = VARIABLES.FirstName>
				<CFSET SESSION.USER.Lname = VARIABLES.LastName>
			</CFLOCK>
			
			<!--- UPDATE Referee INFO ------------------------------------------------------------------ --->
			<CFIF SESSION.MENUROLEID EQ 25 > <!--- MENUROLEID=25=REFEREE  --->
				<!--- UPDATE REFEREE INFO  --->
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="updateRefereeInfo" >
					<cfinvokeargument name="refInfoID" value="#VARIABLES.refInfoID#">
					<cfinvokeargument name="CertYN"    value="#VARIABLES.Certified#">
					<cfinvokeargument name="grade"     value="#VARIABLES.Grade#">
					<cfinvokeargument name="StateReg"  value="#VARIABLES.StateRegisteredIn#">
					<cfinvokeargument name="RefDOB"    value="#dateformat(VARIABLES.refDob,"mm/dd/yyyy")#">
					<cfinvokeargument name="certYear"  value="#VARIABLES.refCertYear#">
					<cfinvokeargument name="ncsaLevel" value="#VARIABLES.refNcsaLevel#">
				</cfinvoke>
			</CFIF>	<!--- END update referee ------------------------------------------------------------- --->


			<cfif swBoardMEMBER>
				<!--- UPDATE BOARDMEMBER INFO --->
				<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="updateBoardMemberInfo" >
					<cfinvokeargument name="boardMemberID" value="#VARIABLES.boardMemberID#">
					<cfinvokeargument name="sequence"	   value="#VARIABLES.Sequence#">
					<cfinvokeargument name="ncsaPhone"	   value="#VARIABLES.ncsaPhone#">
					<cfinvokeargument name="ncsaFax"	   value="#VARIABLES.ncsaFax#">
					<cfinvokeargument name="ncsaEmail"	   value="#VARIABLES.ncsaEmail#">
					<cfinvokeargument name="ncsaTitle"	   value="#VARIABLES.ncsaTitle#">
				</cfinvoke>
			</cfif>
			
			<CFSET updMsg = " Personal Data has been updated. ">
		<CFELSE>
			<CFSET err = err & "<br> There was an problem processing you're request. Please click the back button and try again. ">
		</CFIF>

	</CFIF>	<!--- END - IF swErrors --->
 
 </cfif> <!--- END - if isdefined("FORM.UpdateContact") --->
 

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrStates">
	<cfinvokeargument name="listType" value="CLUBSTATES"> 
</cfinvoke> 

<!--- ============================================================================================= --->
<form name="frmContact" action="userEditPersonalData.cfm" method="post">
	<CFIF isDefined("VARIABLES.refInfoID")>
		<input type="Hidden" name="refInfoID" value="#VARIABLES.refInfoID#">
	</CFIF>
	<cfif isDefined("VARIABLES.updMsg") AND len(trim(VARIABLES.updMsg))>
		<span class="green"><b>#VARIABLES.updMsg#</b></span>
		<br>
	</cfif>
	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="95%">
		<tr class="tblHeading">
			<!--- <TD> &nbsp;		</TD> --->
			<TD colspan="3"> &nbsp;Update Your Information</TD>
		</tr>
		</TR>
		<cfif swErrors>
			<TR><TD> &nbsp;		</TD>
				<TD colspan="2" align="left" class="red">
					<b>Please correct the following errors and submit again.</b>
					<br>
					#stValidFields.errorMessage#
					#err#
				</td>
			</TR>
		</cfif>
		
		<CFIF listFind(SESSION.CONSTANT.AdminRoles,SESSION.MENUROLEID) EQ 0>
			<!--- we are logged in as "CU" as a CLUB user(rep,alt,pres) Do not allow user to change first and or last names	--->
			<CFSET swNameReadOnly = true>
		<CFELSE>
			<CFSET swNameReadOnly = false>
		</CFIF>
		<CFSET swShowRoles = FALSE>	
		<CFSET swShowLoginPW = FALSE>	
		<cfinclude template="contactForm_inc.cfm">
		
		<TR><TD colspan="3">&nbsp;</TD>
		</TR>
		<tr><td colspan="3"><hr></td>
		</tr>
		<tr><td colspan="3" align="center">
				<input type="submit" name="Save" value="Save">
			</td>
		</tr>
	</table>
</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
