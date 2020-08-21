<!--- 
	FileName:	refereeMisconductProcess.cfm
	Created on: 10/29/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">

<CFIF isDefined("FORM.BACK")>
	<cflocation url="refereeMisconductList.cfm">
</CFIF>

<cfset valDisabled = "">

<CFIF isDefined("FORM.ACTION") >
	<!--- form was submitted --->
	<cfif FORM.ACTION EQ "Add">
		<cfquery name="qInsertMisCon" datasource="#SESSION.DSN#">
			INSERT into tlkp_Misconduct
				( misconduct_Descr, misconduct_Event)
			VALUES
				( <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.MisconductDesc#">
				, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.MisconductEvent#">
				)
		</cfquery>
	<cfelseif FORM.ACTION EQ "Edit">	
		<cfquery name="qInsertMisCon" datasource="#SESSION.DSN#">
			UPDATE tlkp_Misconduct
			   SET misconduct_Descr	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.MisconductDesc#">
				 , misconduct_Event	= <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.MisconductEvent#">
			 Where misconduct_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.misConID#">
		</cfquery>
	<cfelseif FORM.ACTION EQ "Delete">	
		<cfquery name="qInsertMisCon" datasource="#SESSION.DSN#">
			DELETE From tlkp_Misconduct
			 Where misconduct_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.misConID#">
		</cfquery>
	</cfif>

	<cflocation url="refereeMisconductList.cfm">

<CFELSE>
	<!--- first time in this page --->	
	<cfif isDefined("URL.editmid") AND isNumeric(URL.editmid)>
		<cfset action = "Edit">
		<cfset misConID = URL.editmid>
	<cfelseif isDefined("URL.deletemid") AND isNumeric(URL.deletemid)>
		<cfset action = "Delete">
		<cfset misConID = URL.deletemid>
		<cfset valDisabled = "disabled">
	<cfelseif isDefined("URL.addmid") AND isNumeric(URL.addmid)>
		<cfset action = "Add">
		<cfset misConID = 0>
	<cfelse>
		<cflocation url="refereeMisconductList.cfm">
	</cfif>
</CFIF>
<H1 class="pageheading">NCSA - #action# MisConduct </H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfquery name="qGetMisconduct" datasource="#SESSION.DSN#">
	SELECT A.misconduct_id, A.misconduct_descr, A.Misconduct_event, Count(b.Game) as usedInGames
	  from tlkp_Misconduct A left outer join V_RefRptDtl b on A.misconduct_id = b.MisconductID
	 where misconduct_id = #misConID#
	 Group by A.misconduct_id, A.misconduct_descr, A.Misconduct_event		
</cfquery> <!--- <cfdump var="#qGetMisconduct#"> --->

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="qGetEvents">
	<cfinvokeargument name="listType" value="REFRPTEVENT"> 
</cfinvoke> 
						 
	
						
<FORM name="Misconduct" action="refereeMisconductProcess.cfm"  method="post">
<input type="hidden" name="action"	value="#action#">
<input type="hidden" name="misConID"	value="#misConID#">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD width="30%" align=center>Event</TD>
		<TD width="70%" align=left>MisConduct Description</TD>
	</tr>
	<TR><TD align="center">
			<select name="MisconductEvent" #valDisabled# >
				<cfloop from="1" to="#arrayLen(qGetEvents)#" index="iE">
					<option value="#qGetEvents[iE][2]#" <cfif qGetMisconduct.Misconduct_event EQ qGetEvents[iE][2]>selected</cfif> >#qGetEvents[iE][2]#</option>
				</cfloop>
			</select>
		</TD>
		<TD><input name="MisconductDesc"  #valDisabled# value="#qGetMisconduct.misconduct_descr#" maxlength="100" size="100" >	</TD>
	</TR>
	<TR><TD colspan="2" align="center">
			<cfif action EQ "Delete">
				<INPUT type="submit" name="submit" value="Delete">
			<cfelseif action EQ "Edit">
				<INPUT type="submit" name="submit" value="Save">
			<cfelseif action EQ "Add">
				<INPUT type="submit" name="submit" value="Add">
			</cfif>
			<INPUT type="submit" name="Back"   value="Back" >
		</TD>
	</TR>
</TABLE>
</FORM>
</cfoutput>
</div>


<cfinclude template="_footer.cfm">
