<!--- 
	FileName:	uploadRoster.cfm
	Created on: 8/22/2020
	Created by: J Lechuga
	
	Purpose: Add/Upload roster
	


 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<!--- set to watermark --->
<cfset rosterType=1>
<!--- Set team and game to 0 --->
<cfif isdefined("url.visitor_team_id")>
	<cfset roster_team_id = url.visitor_team_id>
<cfelseif isdefined("url.home_team_id")>
	<cfset roster_team_id = url.home_team_id>
</cfif>

<cfif isdefined("url.team_id")>
	<!--- Used to return the user back to where they came from --->
	<cfset team_id = url.team_id>
</cfif>
<cfif isdefined("url.game_id")>
	<cfset game_id = url.game_id>
</cfif>

<cfquery datasource="#application.dsn#" name="getTeamName">
	select teamName from tbl_team where team_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#roster_team_id#">
</cfquery>
<cfset msg = "Upload Roster for #getTeamName.teamName# for game #game_id#">

<!--- form submit --->
<cfif isdefined("form") AND not structisempty(form)>

	<!--- saving --->
<!--- 	<cfif form.fcontent NEQ ""> --->
		<cfif form.fcontent EQ "" > 
			<cfset error = "Please provide a roster in PDF format.">
		<cfelse>
			<!--- upload file to temp folder --->
			<cfquery datasource="#application.dsn#" name="getWatermarkDate">
				select watermark_date from tbl_roster where rosterType = 2 and active_flag = 1
			</cfquery>
			<cfif getWatermarkDate.recordcount > 
				<cfset watermark_date = dateformat(getWatermarkDate.watermark_date,"mm/dd/yyyy")>
			</cfif>
			<!--- <cfdump var="#form#" abort="true"> --->
			<cffile action="UPLOAD" accept="application/pdf" destination="#expandPath('uploads/temp')#" nameconflict="MAKEUNIQUE" filefield="form.fcontent">
			<cfpdf action="addWatermark" source="#expandPath('uploads/temp')#\#cffile.serverfile#"  image="assets/images/ncsa_logo_mobile.png"  name="Watermark" foreground="yes" overwrite="yes" position="180,660" opacity="2">
				<cfpdf action="addFooter" bottomMargin="0.5" name="Watermark" align="right" text="#session.currentseason.sf# #session.currentseason.Year# - League Verified: #watermark_date#" source="Watermark" > 
				<cfpdf action="addHeader" topMargin="0.5" name="Watermark" align="right" text="NORTHERN COUNTIES SOCCER ASSOCIATION OF NJ (NCSA) #session.currentseason.sf# #session.currentseason.Year#" source="Watermark" > 
			<!--- <cfcontent type="application/pdf" variable="#ToBinary(Watermark)#" />
			<cfabort> --->
			<cfstoredproc datasource="#session.dsn#" procedure="p_insert_roster">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@rosterType" type="In" value="#rosterType#">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@filename" type="In" null="Yes">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@extension" type="In" null="Yes">
				<cfprocparam cfsqltype="CF_SQL_VARBINARY" dbvarname="@content" value="#ToBinary(Watermark)#" type="In">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" type="In" value="#session.user.contactid#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@team_id" type="In" value="#roster_team_id#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@game_id" type="In" value="#game_id#">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@watermark_date" type="In" null="Yes">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@roster_id" type="Out" variable="roster_id">
			</cfstoredproc>
<!--- 			
			<cfcontent type="application/pdf" variable="#ToBinary(Watermark)#" />
			<cfabort> --->
			<cffile action="DELETE" file="#expandPath('uploads/temp')#\#cffile.serverfile#"> 
			<cflocation url="addTeamRoster.cfm?team_id=#team_id#" addtoken="No">
		</cfif>

		 <!--- --->
	<!--- </cfif> --->

	
	


	<!--- <cffile action="DELETE" file="#expandPath('uploads/temp')#\#cffile.serverfile#"> --->
	
	<!--- redirect user --->
	<!--- <cflocation url="#cgi.script_name#" addtoken="No"> --->

</cfif>

<cfoutput>
<!--- <script language="JavaScript" src="DatePicker.js"></script> --->

<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css"> 	
</cfsavecontent>
<cfhtmlhead text="#jqueryUI_CSS#">

<div id="contentText">
<H1 class="pageheading">NCSA - Upload Roster</H1>
<!--- <h2>yyyyyy </h2> --->

	<span class="red">Fields marked with * are required</span>
	<cfif isdefined("error")>
		<div class="red"><cfoutput>#error#</cfoutput></div>
	</cfif>
	<CFSET required = "<FONT color=red>*</FONT>">
<form action="#cgi.script_name#?#cgi.query_string#" method="post"  enctype="multipart/form-data" ><!------>
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="2">
		 	#msg#
		</TD>
	</tr>
    <TR><TD align="right" width="20%"><b>Roster File(PDF)*:</b></TD>
		<TD>
			<input type="File" name="fContent">
		</TD>
	</TR> 
	<tr align="center"><td colspan="2"  >
			<input type="Submit" name="Save" value="Upload">
		</td>
	</tr>
</table>
</form>  	

</div>
</cfoutput>

<!--- <cfsavecontent variable="cf_footer_scripts">
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <script>
  $( function() {
    $( "input[name=watermark_date]" ).datepicker();
  } );
  </script>
</cfsavecontent> --->

<cfinclude template="_footer.cfm">



 