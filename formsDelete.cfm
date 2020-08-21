<!--- 
	FileName:	formsDelete.cfm
	Created on: 06/05/2009
	Created by: B. Cooper
	
	Purpose: delete a form or document
	
MODS: mm/dd/yyyy - flastname - comments

 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">


<cfif isdefined("url.form_id")>
	<cfset form_id=url.form_id>
<cfelse>
	<cfthrow message="Form ID must be defined">
</cfif>


<cfinvoke component="#SESSION.sitevars.cfcPath#form" method="deleteForm" form_id="#form_id#">
</cfinvoke>


<cflocation url="formsManage.cfm" addtoken="No">