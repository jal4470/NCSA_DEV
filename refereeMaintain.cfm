<!--- 
	FileName:	refereeMaintain.cfm
	Created on: 10/17/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<div id="contentText">
<H1 class="pageheading">NCSA - Referee Information </H1>
<!--- <br> <h2>yyyyyy </h2> --->
<cfoutput>

<cfset err = "">
<cfset blueTitle = "">
<cfset swDoEdit = false>
<cfset swErrors = false>	

<cfif isDefined("FORM.BACK")>
	<cflocation url="refereeList.cfm">
</cfif>

<cfif isDefined("URL.RFID") and isNumeric(URL.RFID) >
	<cfset RefereeID = URL.RFID >
<cfelseif isDefined("FORM.RefereeID") > 
	<cfset RefereeID = FORM.RefereeID >
<cfelse>
	<cfset RefereeID = 0 >
</cfif>

<cfif isDefined("FORM.Certified")> 
	<cfset Certified = FORM.Certified >
<cfelse>
	<cfset Certified = "N" >
</cfif>

<cfif isDefined("FORM.Grade")> 
	<cfset Grade	 =  trim(FORM.Grade) >
<cfelse>
	<cfset Grade	 = "" >
</cfif>

<cfif isDefined("FORM.StateRegisteredIn")> 
	<cfset StateRegisteredIn =  FORM.StateRegisteredIn >
<cfelse>
	<cfset StateRegisteredIn = "" >
</cfif>

<CFIF isDefined("Form.refDob")>
	<CFSET refDob = trim(Form.refDob)>
<CFELSE>
	<CFSET refDob = "">
</CFIF> 

<CFIF isDefined("Form.refCertYear")>
	<CFSET refCertYear = trim(Form.refCertYear)>
<CFELSE>
	<CFSET refCertYear = "">
</CFIF> 

<CFIF isDefined("Form.additionalRefInfo")>
	<CFSET additionalRefInfo = trim(Form.additionalRefInfo)>
<CFELSE>
	<CFSET additionalRefInfo = "">
</CFIF>

<CFIF isDefined("Form.refNcsaLevel")>
	<CFSET refNcsaLevel = trim(Form.refNcsaLevel)>
<CFELSE>
	<CFSET refNcsaLevel = "">
</CFIF>

<CFIF isDefined("Form.Login")>
	<cfset Login	=  Form.Login>
<CFELSE>
	<cfset Login	= "">
</CFIF>
<CFIF isDefined("Form.Pwd")>
	<cfset Pwd		=  Form.Pwd>
<CFELSE>
	<cfset Pwd		= "">
</CFIF>
<CFIF isDefined("Form.ConfPwd")>
	<cfset ConfPwd	=  Form.ConfPwd>
<CFELSE>
	<cfset ConfPwd	= "">
</CFIF>
<CFIF isDefined("Form.ContactID")>
	<cfset ContactID	=  Form.ContactID>
<CFELSE>
	<cfset ContactID	= "">
</CFIF>


<!--- get useSeason --->
<cfinvoke component="#session.sitevars.cfcpath#season" method="getUseSeason" returnvariable="useSeason"></cfinvoke>


<cfif isDefined("FORM.SAVE")> <!--- from THIS page --->
	<cfset swErrors = false>	
	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#FORM#">
	</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->
	
	<CFIF stValidFields.errors>
		<cfset swErrors = true>	
	</cfif>

	<cfif Pwd NEQ ConfPwd>
		<cfset swErrors = true>	
		<cfset err = err & " Password and Confirm Passwords do not match.">
	</cfif>
	
	<CFIF NOT swErrors>	
		<cfquery name="getRefereeInfoID" datasource="#SESSION.DSN#">
			select referee_info_id, certified_yn, grade, stateRegisteredIn
			  FROM tbl_referee_info
			 WHERE contact_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#VARIABLES.RefereeID#">
		</cfquery>
		
		
		<CFIF getRefereeInfoID.RECORDCOUNT>
			<!--- we have a record, so UPDATE --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="updateRefereeInfo" >
				<cfinvokeargument name="refInfoID" value="#getRefereeInfoID.referee_info_id#">
				<cfinvokeargument name="CertYN"    value="#VARIABLES.Certified#">
				<cfinvokeargument name="grade"     value="#VARIABLES.Grade#">
				<cfinvokeargument name="StateReg"  value="#VARIABLES.StateRegisteredIn#">
				<cfinvokeargument name="RefDOB"    value="#dateformat(VARIABLES.refDob,"mm/dd/yyyy")#">
				<cfinvokeargument name="certYear"  value="#VARIABLES.refCertYear#">
				<cfinvokeargument name="ncsaLevel" value="#VARIABLES.refNcsaLevel#">
				<cfinvokeargument name="additionalRefInfo" value="#VARIABLES.additionalRefInfo#">
			</cfinvoke>
		<CFELSE>
			<!--- No record found so INSERT --->
			<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="insertRefereeInfo" returnvariable="refInfoID" >
				<cfinvokeargument name="RefereeID" value="#VARIABLES.RefereeID#">
				<cfinvokeargument name="CertYN"    value="#VARIABLES.Certified#">
				<cfinvokeargument name="grade"     value="#VARIABLES.Grade#">
				<cfinvokeargument name="StateReg"  value="#VARIABLES.StateRegisteredIn#">
				<cfinvokeargument name="RefDOB"    value="#dateformat(VARIABLES.refDob,"mm/dd/yyyy")#">
				<cfinvokeargument name="certYEAR"  value="#VARIABLES.refCertYear#">
				<cfinvokeargument name="ncsaLevel" value="#VARIABLES.refNcsaLevel#">
				<cfinvokeargument name="additionalRefInfo" value="#VARIABLES.additionalRefInfo#">
			</cfinvoke>
		</CFIF>
		
		<!--- make sure contact has referee role assigned --->
		<cfinvoke
			component="#session.sitevars.cfcpath#contact"
			method="insertcontactrole"
			contactid="#refereeid#"
			seasonid="#useSeason#"
			roleid="25"
			clubid="1"
			activeyn="Y"
			allowgameedit="0">
		
		<CFIF isDefined("FORM.activateRef")>
			<!--- This is a requested Ref that was approved and now we need to activate them		 --->
			<CFQUERY name="updateContact" datasource="#SESSION.DSN#">
				UPDATE TBL_CONTACT
				   SET ACTIVE_YN = 'Y'
				     , USERNAME  = <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.LOGIN#">
					 , PASSWORD  = <CFQUERYPARAM cfsqltype="CF_SQL_VARCHAR" value="#VARIABLES.PWD#">
				 WHERE CONTACT_ID = <CFQUERYPARAM cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.contactID#">
			</CFQUERY>
		</CFIF>
		<cflocation url="refereeList.cfm">
	</CFIF>
	
</cfif>


<cfif refereeID GT 0> 
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qRefInfo">
			<cfinvokeargument name="refereeID" value="#variables.refereeID#">
			<cfinvokeargument name="activeOnly" value="false">
	</cfinvoke>	<!--- <cfdump var="#qRefInfo#"><cfinvokeargument name="xrefContactRoleID" value="#VARIABLES.RefereeID#"> --->
<!--- <cfdump var=#qrefinfo#> --->
	
	
	<cfset RefFirstName = qRefInfo.FIRSTNAME >
	<cfset RefLastName  = qRefInfo.LASTNAME >
	<cfset Address		= qRefInfo.ADDRESS >
	<cfset CITY			= qRefInfo.CITY >
	<cfset State		= qRefInfo.STATE >
	<cfset ZIP			= qRefInfo.ZIPCODE >
	<cfset HomePhone	= qRefInfo.PHONEHOME >
	<cfset WorkPhone	= qRefInfo.PHONEWORK >
	<cfset CellPhone	= qRefInfo.PHONECELL >
	<cfset Fax			= qRefInfo.PHONEFAX >
	<cfset EMail		= qRefInfo.EMAIL >
	<cfif qRefInfo.CERTIFIED_YN EQ "Y">
		<cfset Certified	= qRefInfo.CERTIFIED_YN >
	<cfelse>
		<cfset Certified	= "N" >
	</cfif>
	<cfset Grade		= trim(qRefInfo.GRADE) >
	<cfset StateRegisteredIn = qRefInfo.STATEREGISTEREDIN >
	<CFSET refDob 	 	= trim(dateformat(qRefInfo.birth_date,"mm/dd/yyyy"))>
	<CFSET refCertYear 	= trim(qRefInfo.certified_1st_year)>
	<cfset additionalRefInfo  = trim(qRefInfo.additional_ref_info)>
	<CFSET refNcsaLevel = trim(qRefInfo.Ref_level)>

	<cfset contactID 		= qRefInfo.CONTACT_ID>
	<cfset contactActiveYN  = qRefInfo.CONTACT_ACTIVE>
	<cfset contactApproveYN = qRefInfo.APPROVE_YN>

	<cfset Login	= qRefInfo.USERNAME>
	<cfset Pwd		= qRefInfo.PASSWORD>
	<cfset ConfPwd	= qRefInfo.PASSWORD>
	
<cfelse>
	<cflocation url="refereelist.cfm">
</cfif>


<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="arrStates">
	<cfinvokeargument name="listType" value="CLUBSTATES"> 
</cfinvoke> 
				 

<FORM name="RefereeMaintain" action="RefereeMaintain.cfm"  method="post">
<input type="hidden" name="RefereeID"			value="#RefereeId#">

<span class="red">Fields marked with * are required</span>
<CFSET required = "<FONT color=red>*</FONT>">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="2"> Edit a Referee : #RefLastName#, #RefFirstName# </TD>
	</tr>
	<cfif swErrors>
		<TR><TD colspan="2" align="left" class="red">
				<b>Please correct the following errors and submit again.</b>
				<cfif isDefined("stValidFields.errorMessage") and Len(trim(stValidFields.errorMessage))>
					<br> #stValidFields.errorMessage#
				</cfif>
				<cfif isDefined("err") and Len(trim(err))>
					<br> #err#
				</cfif>
			</td>
		</TR>
	</cfif>

	<TR><TD width="20%" align="right"><b>Referee Name</B></TD>	<TD>#RefLastName#, #RefFirstName#</TD>	
	</TR>
	<TR><TD align="right" valign="top"><b> Address</b></TD>
		<TD>	#Address#	<br>#CITY# #State# #Zip#  </TD>
	</TR>
	<TR><TD align="right"><b>Home Phone</b></TD>		<TD>#homePhone#</TD>	
	</TR>
	<TR><TD align="right"><b>Work Phone</b></TD>		<TD>#WorkPhone#</TD>	
	</TR>
	<TR><TD align="right"><b>Cell Phone</b></TD>		<TD>#CellPhone#</TD>	
	</TR>
	<TR><TD align="right"><b>Fax</b></TD>				<TD>#Fax#</TD>			
	</TR>
	<TR><TD align="right"><b>EMail</b></TD>				<TD>#EMail#</TD>		
	</TR>

	<TR><TD align="right">#required#<b>Grade</b></TD>
		<TD><input maxlength="5" name="Grade" value="#Grade#" >
			<input type="Hidden" name="Grade_ATTRIBUTES" 	value="type=GENERIC~required=1~FIELDNAME=GRADE">	
		</TD>
	</TR>
	<TR><TD align="right">#required#<b>State Registered In</b></TD>
		<TD><SELECT name="StateRegisteredIn" > 
				<OPTION value="" selected>select state</OPTION>
				<cfloop from="1" to="#arrayLen(arrStates)#" index="iSt">
					<OPTION value="#arrStates[iSt][1]#" <cfif StateRegisteredIn EQ arrStates[iSt][1]>selected</cfif> >#arrStates[iSt][1]#</OPTION>
				</cfloop>
			</SELECT>
			<input type="Hidden" name="StateRegisteredIn_ATTRIBUTES" 	value="type=STATE~required=1~FIELDNAME=State Registered In">	
		</TD>
	</TR>
	<TR><TD align="right">#required#<b>Certified</b></TD>
		<TD><SELECT name="Certified" > 
				<OPTION value="Y" <cfif Certified EQ "Y">selected</cfif> > Yes</OPTION>
				<OPTION value="N" <cfif Certified EQ "N">selected</cfif> > No</OPTION>
			</SELECT>
			<input type="Hidden" name="Certified_ATTRIBUTES" value="type=GENERIC~required=1~FIELDNAME=Certified">	
		</td>
	</TR>
<!--- ------------------------------- --->
	<TR><TD align="right">#required#<b>Date Of Birth</b></TD>
		<TD><input type="Text"  maxlength="10" name="refDob" 	value="#refDob#">
			<input type="Hidden" name="refDob_ATTRIBUTES" 	value="type=DATE~required=1~FIELDNAME=Date Of Birth">	
			<span class="red">(must be valid date as "mm/dd/yyyy")</span>
		</TD>
	</TR>
	<TR><TD align="right">#required#<b>Year First Certified</b></TD>
		<TD><input type="Text"  maxlength="4" name="refCertYear" 	value="#refCertYear#">
			<input type="Hidden" name="refCertYear_ATTRIBUTES" 	value="type=GENERIC~required=1~FIELDNAME=Year First Certified">	
			<span class="red">(enter 4 digit year "yyyy")</span>
		</TD>
	</TR>
	<TR><TD align="right"><b>NCSA Level</b></TD>
		<TD><input type="Text"  maxlength="10" name="refNcsaLevel" 	value="#refNcsaLevel#">
		</TD>
	</TR>
	<TR><TD align="right"><b>Additional Info</b></TD>
		<TD><TEXTAREA name="additionalRefInfo" rows=3  cols=50>#Trim(additionalRefInfo)#</TEXTAREA>
			<input type="Hidden" name="additionalRefInfo_ATTRIBUTES" value="type=NOSPECIALCHAR~required=0~FIELDNAME=Additional Info">	
		</TD>
	</TR>
	
<!--- ----------------------- --->
	<CFIF contactActiveYN EQ "N" AND contactApproveYN EQ "Y">
		<input type="Hidden" name="activateRef" value="Yes" >
		<input type="Hidden" name="contactID"   value="#VARIABLES.contactID#" >
		<TR><TD align="right">#required#<b>Login</b></TD>
			<TD><input type="Text"  maxlength="100" name="Login"	value="#VARIABLES.Login#" >
				<input type="Hidden" name="Login_ATTRIBUTES" 	value="type=NOSPECIALCHAR~required=1~FIELDNAME=Login">
			</TD>	
		</TR>
		<TR><TD align="right">#required#<b>Password</b></TD>
			<TD><input type="password" maxlength="100" name="Pwd" 	value="#VARIABLES.Pwd#" >
				<input type="Hidden" name="Pwd_ATTRIBUTES" 	value="type=NOSPECIALCHAR~required=1~FIELDNAME=Password">	
			</TD>
		</TR>
		<TR><TD align="right">#required#<b>Confirm Password</b></TD>
			<TD><input type="password" maxlength="100" name="ConfPwd" 	value="#VARIABLES.ConfPwd#" >
				<input type="Hidden" name="ConfPwd_ATTRIBUTES" 	value="type=NOSPECIALCHAR~required=1~FIELDNAME=Confirm Password">	
			</TD>
		</TR>
	</CFIF>



	<TR align="LEFT">
		<TD colspan="2"><HR size="1" </TD>
	<TR align="center">
		<TD>&nbsp;</TD>
		<TD align="left">
			<INPUT type="submit" name="Save" value="Save">
			<!--- < if Session("ProfileType") = "SU" then	#
						<INPUT type="submit" value="Delete"  name="delete" #DeleteSts# onclick="return DeleteRec()">
			<  end if	# --->
			<INPUT type="submit" name="Back" value="Back"  >
		</TD>
	</TR>
</TABLE>
</FORM>

 
</div>
</cfoutput>
<cfinclude template="_footer.cfm">





<!--- 
<script language="javascript">
var cForm = document.RefereeMaintain.all;
var PageArray	= new Array ("RefereeInfo");
var PageCount	= 1;

function GoBack()
{	self.document.RefereeMaintain.action = "refereeList.cfm";
	self.document.RefereeMaintain.submit();	
}
function DeleteRec()
{	var DeleteYN
	DeleteYN = confirm ("Are you sure To DELETE Record")
	if (DeleteYN) 
	{	self.document.RefereeMaintain.action	 = "xxxxxxxxxxxxxxxxxxxxxx";
		self.document.RefereeMaintain.Mode.value = "DELETE";
		self.document.RefereeMaintain.submit();
	}
	return false;
}
</script> --->

	
