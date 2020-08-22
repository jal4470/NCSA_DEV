<!--- 
	FileName:	formsAdd.cfm
	Created on: 8/22/2020
	Created by: J Lechuga
	
	Purpose: set watermark date
	


 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">


<cfset group_id=1>
<!--- set to watermark --->
<cfset rosterType=2>
<!--- Set team and game to 0 --->
<cfset team_id = 0>
<cfset game_id = 0>



<!--- form submit --->
<cfif isdefined("form") AND not structisempty(form)>

	<!--- saving --->
<!--- 	<cfif form.fcontent NEQ ""> --->
		<cfif not isValid("date",form.watermark_date)>
			<cfset error = "Please provide a valid date">
		<cfelse>
			<!--- upload file to temp folder --->
			<!--- <cfdump var="#form#" abort="true"> --->
			<!--- <cffile action="UPLOAD" accept="application/pdf" destination="#expandPath('uploads/temp')#" nameconflict="MAKEUNIQUE" filefield="form.fcontent">
			<cfpdf action="addWatermark" source="#expandPath('uploads/temp')#\#cffile.serverfile#"  image="assets/images/ncsa_logo_mobile.png"  name="Watermark" foreground="yes" overwrite="yes" position="180,675" opacity="2">
				<cfpdf action="addFooter" bottomMargin="0.5" name="Watermark" align="right" text="League Verified: #form.watermark_date#" source="Watermark" > --->
			<cfstoredproc datasource="#session.dsn#" procedure="p_insert_roster">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@rosterType" type="In" value="#rosterType#">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@filename" type="In" null="Yes">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@extension" type="In" null="Yes">
				<cfprocparam cfsqltype="CF_SQL_LONGVARBINARY" dbvarname="@content" type="In" null="Yes">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" type="In" value="#session.user.contactid#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@team_id" type="In" value="#team_id#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@game_id" type="In" value="#game_id#">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@watermark_date" type="In" value="#form.watermark_date#">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@roster_id" type="Out" variable="roster_id">
			</cfstoredproc>
			
			
			<cfset error = "Watermark date has been added">
		</cfif>
<!--- 
		<cfcontent type="application/pdf" variable="#ToBinary(Watermark)#" />
		<cfabort> --->
	<!--- </cfif> --->

	
	


	<!--- <cffile action="DELETE" file="#expandPath('uploads/temp')#\#cffile.serverfile#"> --->
	
	<!--- redirect user --->
	<!--- <cflocation url="#cgi.script_name#" addtoken="No"> --->
	

<cfelse>
	<cfquery datasource="#application.dsn#" name="getWatermarkDate">
		select watermark_date from tbl_roster where rosterType = 2 and active_flag = 1
	</cfquery>
	<cfif getWatermarkDate.recordcount > 
		<cfset watermark_date = dateformat(getWatermarkDate.watermark_date,"mm/dd/yyyy")>
	</cfif>
</cfif>

<cfoutput>
<script language="JavaScript" src="DatePicker.js"></script>

<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css"> 	
</cfsavecontent>
<cfhtmlhead text="#jqueryUI_CSS#">

<div id="contentText">
<H1 class="pageheading">NCSA - Add Watermark Date</H1>
<!--- <h2>yyyyyy </h2> --->

	<span class="red">Fields marked with * are required</span>
	<cfif isdefined("error")>
		<cfoutput>#error#</cfoutput>
	</cfif>
	<CFSET required = "<FONT color=red>*</FONT>">
<form action="#cgi.script_name#" method="post"><!---  enctype="multipart/form-data" --->
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="2">
		 	Add Form
		</TD>
	</tr>
	<TR><TD align="right"><b>Watermark Date*</b></TD>
		<TD><input type="Text"  maxlength="50" name="watermark_date" value="#iif(isdefined('watermark_date'),de('#watermark_date#'), de(''))#">
		</TD>
	</TR>
<!--- 	<TR><TD align="right" width="20%"><b>Watermark(PDF)*:</b></TD>
		<TD>
			<input type="File" name="fContent">
		</TD>
	</TR> --->
	<tr align="center"><td colspan="2"  >
			<input type="Submit" name="Save" value="Save">
		</td>
	</tr>
</table>
</form>  	

</div>
</cfoutput>

<cfsavecontent variable="cf_footer_scripts">
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <script>
  $( function() {
    $( "input[name=watermark_date]" ).datepicker();
  } );
  </script>
</cfsavecontent>

<cfinclude template="_footer.cfm">



 
