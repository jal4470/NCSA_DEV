<!--- 
	FileName:	formsAdd.cfm
	Created on: 06/04/2009
	Created by: B. Cooper
	
	Purpose: add a form or document
	
MODS: mm/dd/yyyy - flastname - comments

 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">


<cfif isdefined("url.group_id")>
	<cfset group_id=url.group_id>
<cfelse>
	<cfset group_id=1>
</cfif>



<!--- form submit --->
<cfif isdefined("form") AND not structisempty(form)>

	<cfif isdefined("form.back")>
		<cflocation url="formsManage.cfm" addtoken="No">
	</cfif>	
	
	<cfset group_id=form.group_id>
	
	<!--- saving --->
	<cfif form.fcontent NEQ "">
		<!--- upload file to temp folder --->
		<cffile action="UPLOAD" destination="#application.sitevars.tempPath#" nameconflict="MAKEUNIQUE" filefield="form.fcontent">
		
		<!--- read file back into variable --->
		<cffile action="READBINARY" file="#application.sitevars.tempPath#\#cffile.serverfile#" variable="binContent">
		<cfset formType="1">
	<cfelse>
		<cfset formType="2">
	</cfif>
	
	<cfif isdefined("form.chkActive")>
		<cfset active_flag=1>
	<cfelse>
		<cfset active_flag=0>
	</cfif>
	
	
	<cfstoredproc datasource="#session.dsn#" procedure="p_insert_form">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@name" type="In" value="#form.txtname#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@formType" type="In" value="#formType#">
		<cfif formType EQ "1">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@filename" type="In" value="#replace(cffile.clientfilename," ","_","all")#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@extension" type="In" value="#cffile.clientfileext#">
			<cfprocparam cfsqltype="CF_SQL_LONGVARBINARY" dbvarname="@content" type="In" value="#bincontent#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@linkURI" type="In" null="Yes">
		<cfelse>
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@filename" type="In" null="Yes">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@extension" type="In" null="Yes">
			<cfprocparam cfsqltype="CF_SQL_LONGVARBINARY" dbvarname="@content" type="In" null="Yes">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@linkURI" type="In" value="#form.txtLink#">
		</cfif>
		<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@active_flag" type="In" value="#active_flag#">
		<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@showInUI" type="In" value="1">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@group_id" type="In" value="#group_id#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" type="In" value="#session.user.contactid#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@form_id" type="Out" variable="form_id">
	</cfstoredproc>
	
	
	<cfif formType EQ 1>
		<!--- delete temp file --->
		<cffile action="DELETE" file="#application.sitevars.tempPath#\#cffile.serverfile#">
	</cfif>
	
	<!--- redirect user --->
	<cflocation url="formsManage.cfm" addtoken="No">
	

</cfif>




<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Add Form</H1>
<!--- <h2>yyyyyy </h2> --->






	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
<form action="formsAdd.cfm" method="post" enctype="multipart/form-data">
<input type="Hidden" name="group_id" value="#group_id#">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="2">
		 	Add Form
		</TD>
	</tr>
	<TR><TD align="right"><b>Name</b></TD>
		<TD><input type="Text"  maxlength="50" name="txtName">
		</TD>
	</TR>
	<TR><TD align="right"><b>Link</b></TD>
		<TD><input type="Text" name="txtLink">
		</TD>
	</TR>
	<TR><TD align="right"></TD>
		<TD><b>OR</b>
		</TD>
	</TR>
	<TR><TD align="right" width="20%"><b>File:</b></TD>
		<TD>
			<input type="File" name="fContent">
		</TD>
	</TR>
	<TR><TD align="right"><b>Active?</b></TD>
		<TD><input type="Checkbox" name="chkActive" value="1" checked="checked">
		</TD>
	</TR>
	<tr><td colspan="2"  >
			<input type="Submit" name="Save"    value="Save">
			&nbsp;&nbsp;
			<input type="Submit" name="Back"    value="Back to List">
		</td>
	</tr>
</table>
</form>  	

</div>
</cfoutput>
<cfinclude template="_footer.cfm">



 
