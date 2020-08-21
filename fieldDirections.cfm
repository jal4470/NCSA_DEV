<!--- 
	FileName:	fieldDirections.cfm
	Created on: 08/12/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to display a list of all fields
	
MODS: mm/dd/yyyy - flastname - comments
9/25/2018 M Greenberg - updated button to new style

 --->
<cfset mid = 2>
<cfinclude template="_header.cfm">

<div id="contentText">
	<H1 class="pageheading">NCSA - Field Directions </H1>
	<br>
	<cfif isdefined("url.fid")>
		<!--- display ONLY field specified --->
		<cfset fieldID = url.fid>
		<cfinclude template="fieldDirPop.cfm">
		<cfoutput>#repeatString("<br>",30)#</cfoutput>
		<table width="90%">
			<tr><td align="center">	<button class="yellow_btn" type="button" name="goback" value="<< Back" onclick="history.go(-1)"><< Back</button></td></tr>
		</table>
	<cfelseif isdefined("url.rcid")>
		<!--- club id was passed, list driections for ALL REGISTERED fields in club --->
		<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getRegFields" returnvariable="qRegFields">
			<cfinvokeargument name="clubID"	 value="#url.rcid#">
			<cfinvokeargument name="orderBy" value="NAME">
		</cfinvoke>  
		<table width="90%">
			<tr><td align="center"><button class="yellow_btn" type="button" name="goback" value="<< Back" onclick="history.go(-1)"><< Back</button></td></tr>
		</table>
		<CFLOOP query="qRegFields">
			<cfif active_Club_filed_YN EQ "Y">
				<CFSET fieldID = qRegFields.field_id>
				
				<cfinclude template="fieldDirPop.cfm">
				<cfoutput>#repeatString("<br>",30)#</cfoutput>
			</cfif>	
		</CFLOOP>
		<table width="90%">
			<tr><td align="center"><button class="yellow_btn" type="button" name="goback" value="<< Back" onclick="history.go(-1)"><< Back</button></td></tr>
		</table>
	</cfif>
	
</div>
<cfinclude template="_footer.cfm">

