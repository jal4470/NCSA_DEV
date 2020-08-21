<!--- 
	FileName:	_checkLogin.cfm
	Created on: 09/04/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: checks to see if a user is logged in. This include is used in pages that are "private" (pages that need to be logged in
			in order to access.) If the session times out, they need to log in again.
	
MODS: mm/dd/yyyy - filastname - comments
06/08/2017 - A.Pinzone - Updated to return user to homepage, login page is used as an includes now.
 --->
<CFIF isDefined("SESSION.USER")>
	<!--- they are logged in,  --->
	<CFSET swLogin = true>
<CFELSE>
	<CFSET swLogin = false>
	<!--- <cflocation url="index.cfm?x=exp"> --->
	<cflocation url="#application.sitevars.homehttp#/index.cfm?x=exp">
</CFIF>
