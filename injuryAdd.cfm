<!--- 
	FileName:	injuryAdd.cfm
	Created on: 06/09/2009
	Created by: b. cooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">

<CFIF isDefined("FORM.BACK")>
	<cflocation url="injuryList.cfm">
</CFIF>

<cfset valDisabled = "">

<CFIF isDefined("FORM") AND not structisempty(form) >
	
	<!--- get description --->
	<cfif form.injuryDesc EQ "">
		<cfthrow message="Please enter an injury description.">
	</cfif>
	
	<cfif form.action EQ "add">
		<cfinvoke 
			component="#application.sitevars.cfcpath#.Injury" 
			method="addInjury" 
			injuryDescription="#form.injuryDesc#" 
			returnvariable="injury_id"></cfinvoke>
	<cfelse>
		<cfinvoke 
			component="#application.sitevars.cfcpath#.Injury" 
			method="EditInjury" 
			injury_id="#form.injury_id#"
			injuryDescription="#form.injuryDesc#" 
			returnvariable="injury_id"></cfinvoke>
	</cfif>
	
	<cflocation url="injuryList.cfm">
	
</CFIF>

<cfif isdefined("url.injury_id")>
	<cfset action="Edit">
	<cfquery datasource="#application.dsn#" name="getInjury">
		select injury_desc, seq
		from tlkp_injury
		where injury_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.injury_id#">
	</cfquery>
	
	<cfif getInjury.recordcount EQ 0>
		<cfthrow message="Injury does not exist.">
	</cfif>
	
	<cfset injuryDesc=getInjury.injury_desc>
	<cfset injury_id=url.injury_id>
<cfelse>
	<cfset action="Add">
	<cfset injury_id="">
	<cfset injuryDesc="">
</cfif>


<H1 class="pageheading">NCSA - #action# Injury </H1>
<br> <!--- <h2>yyyyyy </h2> --->


						 
	
						
<FORM name="injury" action="injuryAdd.cfm"  method="post">
	<input type="Hidden" name="action" value="#action#">
	<input type="Hidden" name="injury_id" value="#injury_id#">
	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<TD width="100%" align=left>MisConduct Description</TD>
		</tr>
		<TR><TD><input name="injuryDesc" value="#injuryDesc#" maxlength="100" size="100" >	</TD>
		</TR>
		<TR><TD align="center">
				
				<cfif action EQ "add">
					<INPUT type="submit" name="submit" value="Add">
				<cfelse>
					<INPUT type="submit" name="submit" value="Save">
				</cfif>
				<INPUT type="submit" name="Back"   value="Back" >
			</TD>
		</TR>
	</TABLE>
</FORM>
</cfoutput>
</div>


<cfinclude template="_footer.cfm">
