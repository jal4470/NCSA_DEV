<!---
	FileName:	login.cfm
	Created on: 08/18/2008
	Created by: aarnone@capturepoint.com

	Purpose: this page will diplay the login page. "lm" will represent which menu role is to be used.

MODS: mm/dd/yyyy - filastname - comments

 --->

<!--- onSessionStart is made to execute here because when season flags are changed and someone is already on the site
	  the session does not change until it times out. Putting the onsession Start logic here will force the session values
	  to be rechecked to see if there are any changes in the value.
--->
<cfinvoke component="Application" method="onSessionStart" />


<cfoutput>
<hgroup id="modal_title">
	<h2>NCSA - Login</h2>
	<h3>Enter user name, password and hit Enter</h3>
</hgroup>

<CFIF isDefined("URL.lm") AND len(trim(URL.lm))>
	<CFSET lm = URL.lm>
<CFELSE>
	<CFSET lm = "">
</CFIF>

<CFIF isDefined("URL.msg") and Len(trim(URL.msg))>
	<span class="error red"><b>#URL.msg#</b></span>
</CFIF>

	<form id="login_form" name="login_form" action="loginAction.cfm" method="post">
		<input type="Hidden" id="lmfield" name="lm" value="#VARIABLES.lm#">

		<div class="notification">Login invalid. Please try again.</div>
		
		<div class="form_field">
			<label for="usernamefield">User Name</label>
			<input type="Text" id="usernamefield" name="uname" value="">
		</div>

		<div class="form_field">
			<label for="">Password</label>		
			<input type="Password" id="passwordfield" name="pword" value="">
		</div>

		<div class="form_btn">
			<button id="login_close"  class="gray_btn"   type="button" name="cancel">Cancel</button>
			<button id="login_submit" class="yellow_btn" type="Submit" name="enter">Login</button>
		</div>
	</form>

	<script type="text/javascript" language="JavaScript">
		document.getElementById('usernamefield').focus();
	</script>

</cfoutput>
