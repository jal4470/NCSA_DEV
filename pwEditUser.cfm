<!--- 
	FileName:	pwEditUser.cfm
	Created on: 09/04/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: lets a user change their password
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 
<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Change Password</H1>
<br>
<!--- <h2>yyyyyy </h2> --->

<CFSET errMsg = "">

<CFIF isDefined("FORM.CHANGE")>

	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#FORM#">
	</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->

	<cfset swPass = false>
	<CFIF stValidFields.errors>
		<CFSET errMsg = "Please correct the following errors and submit again.">
	<CFELSE>
		<CFIF FORM.pwOld NEQ SESSION.User.pword>
			<CFSET errMsg = "Old Password entered is not valid. Please try again.">	
		<CFELSEIF FORM.pwNew NEQ FORM.pwCnfrm>
			<CFSET errMsg = "New and Confirm Passwords do not match. Please try again.">	
		<CFELSEIF FORM.pwOld EQ FORM.pwNew>
			<CFSET errMsg = "New password can not be the same as the Current password. Please try again.">	
		<CFELSE>
			<cfset swPass = true>
		</CFIF> 

		<CFIF swPass>
			<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="changePW" returnvariable="returnCode">
				<cfinvokeargument name="contactID" value="#SESSION.User.CONTACTID#">
				<cfinvokeargument name="password"  value="#FORM.pwNew#">
			</cfinvoke>  <!--- <cfdump var="#returnCode#"> --->
			
			<CFIF returnCode.statusCode GT 0>
				<CFSET errMsg = "There was a problem changing your password, please try again. If problem persists, please contact the administrator. p002">	
			<cfelse>
				<CFSET errMsg = "Your password has been changed.">	
				<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
					<CFSET SESSION.User.pword = FORM.pwNew>
				</CFLOCK>
				
			</CFIF>
		
		</CFIF>
	</CFIF> 
</CFIF>

<form action="pwEditUser.cfm" method="post" >
	<CFIF len(trim(errMsg))>
		<span class="red">
			<b>#errMsg#</b>
			<br><CFIF isDefined("stValidFields.errorMessage")>
					#stValidFields.errorMessage#
				</CFIF>
		</span>
	</CFIF>
	<table cellspacing="0" cellpadding="5" border="0" width="60%">
		<tr class="tblHeading">
			<TD colspan="2"> &nbsp; </TD>
		</tr>
		<tr><TD width="25%"   align="right"> 
				<b>Current Password:</b>
			</TD>
			<TD nowrap> 
				<input type="Password" name="pwOld" >
				<input type="Hidden" name="PwOld_ATTRIBUTES" value="type=generic~required=1~FIELDNAME=PwOld">
			</TD>
		</tr>

		<tr><TD align="right"> 
				<b>New Password:</b>
			</TD>
			<TD nowrap> 
				<input type="Password" name="pwNew" >
				<input type="Hidden" name="PwNew_ATTRIBUTES" value="type=generic~required=1~FIELDNAME=PwNew">
			</TD>
		</tr>

		<tr><TD class="tdUnderLine" align="right"> 
				<b>Confirm Password:</b>
			</TD>
			<TD class="tdUnderLine" nowrap> 
				<input type="Password" name="pwCnfrm" >
				<input type="Hidden" name="PwCnfrm_ATTRIBUTES" value="type=generic~required=1~FIELDNAME=PwCnfrm">
			</TD>
		</tr>

		<tr><TD   align="right"> 
				&nbsp;
			</TD>
			<TD   nowrap> 
				<input type="Submit" name="Change" value="Change password" >
			</TD>
		</tr>

	</table>	
</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
