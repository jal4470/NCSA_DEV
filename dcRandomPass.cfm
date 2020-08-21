<!------------------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------------
 
 	Application:	Any
	Project:		Any
	Filename:		dcRandomPass.cfm
	Programmers:	Peter Coppinger <peter@digital-crew.com>
					
	Purpose:		Creates a random password.

	Usage:			<cf_dcRandomPass [size="[MAXIMUM_CHARS/default:10]"] [minNumbers="[NUMBER/default:0]"] [charSet="[STRING]"] [outputVariable="VARIABLE NAME"]>
	
	Description:	I couldn't find a handy rountine to do this already on the web so I knocked
					it up and if your going to do it you might as well do it right!
					The Examples should explain everyThing.
					Your comments appreciated.
					
	Examples:		<cf_dcRandomPass>
					Creates random 10 char long password in variable "randomPass".
						e.g. <cfoutput>#randomPass#</cfoutput>
						
					<cf_dcRandomPass outputVariable="newPassword">
					As above buts places password in newPassword.
					
					<cf_dcRandomPass size=20>
					Creates a 20 char long random password.
					
					<cf_dcRandomPass size=4 chars="ZXCVBNM">
					Creates a 4 char long password based on chars e.g. randomPass might be
					"BXMN" or "XZCV".
						
					<cf_dcRandomPass size=8 chars="ZXCVBNM" minNumbers=4>
					Creates a 8 char long password based on chars e.g. randomPass might be
					"2BX60MN3" or "X99ZC3V7".
	
	CHANGE LOG:
	29 Jan 2002		Document created.

 ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------>
<cfparam name="Attributes.size" default="10">
<cfparam name="Attributes.minNumbers" default="0">
<cfparam name="Attributes.charSet" default="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ*%-">

<!--- Check Parameters --->
<cfif Attributes.size GT 100><cfthrow type="user" message="&lt;cf_dcRandomPass&gt;: <i>Attribute size too big - maximum size is 100!</i>"></cfif>
<cfif Len(Attributes.charSet) LT 5><cfthrow type="user" message="&lt;cf_dcRandomPass&gt;: <i>Attribute charSet length too short - must be at least 5 charactors long!</i>"></cfif>
<cfif Attributes.minNumbers GT Attributes.size><cfset Attributes.minNumbers = Attributes.size></cfif>

<!--- Create the New Password --->
<cfset newPass = "">

<!--- Randomize --->
<!---<cfset seed = Randomize( GetTickCount() mod 1000000)>--->

<!--- First insert all the required numbers --->
<cfloop index="i" from="1" to="#Attributes.minNumbers#">
	<cfset newPass = newPass & Evaluate( Chr( Asc('0')+(Int(rand()*10)) ) )>
</cfloop>

<!--- Randomize --->
<!---<cfset seed = Randomize( GetTickCount() mod 100000 )>--->

<!--- Fill the rest of the string at random places with random chars --->
<cfloop index="i" from="#Evaluate(Attributes.minNumbers+1)#" to="#Attributes.size#">
	<cfset newChar = Mid( Attributes.charSet, Int(rand()*Len(Attributes.charSet))+1, 1) >
	<cfif Len(newPass) LT 1>
		<cfset newPass = newPass & newChar>
	<cfelse>
		<cfset newPass = Insert( newChar, newPass, Int(rand()*(Len(newPass)+1)) )>
	</cfif>
</cfloop>

<!--- Return Generated Password --->
<cfif isdefined("Attributes.outputVariable")>
	<cfscript>Evaluate( "Caller." & Attributes.outputVariable & "= newPass" );</cfscript>
<cfelse>
	<!--- Default to "randomPassword" --->
	<cfscript>Caller.randomPass = newPass;</cfscript>
</cfif>
