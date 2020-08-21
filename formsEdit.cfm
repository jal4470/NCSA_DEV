<!--- 
	FileName:	formsEdit.cfm
	Created on: 06/05/2009
	Created by: B. Cooper
	
	Purpose: edit a form or document
	
MODS: mm/dd/yyyy - flastname - comments

 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">



<!--- form submit --->
<cfif isdefined("form") AND not structisempty(form)>

	<cfif isdefined("form.back")>
		<cflocation url="formsManage.cfm" addtoken="No">
	</cfif>	
	
	<!--- saving --->
	
	
	<!--- upload new file if exists --->
	<cfif form.fContent NEQ "">
		
		<cfset formType=1>
		<cfset newfile=true>
		<!--- upload file to temp folder --->
		<cffile action="UPLOAD" destination="#application.sitevars.tempPath#" nameconflict="MAKEUNIQUE" filefield="form.fcontent">
		
		<cfset filename=replace(cffile.clientfilename," ","_","all")>
		<cfset extension=cffile.clientfileext>
		
		<!--- read file back into variable --->
		<cffile action="READBINARY" file="#application.sitevars.tempPath#\#cffile.serverfile#" variable="binContent">
		
		<!--- delete temp file --->
		<cffile action="DELETE" file="#application.sitevars.tempPath#\#cffile.serverfile#">
		
		<cfstoredproc datasource="#session.dsn#" procedure="p_update_form_file">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@form_id" type="In" value="#form.form_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@filename" type="In" value="#filename#" null="#newfile EQ false#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@extension" type="In" value="#extension#" null="#newfile EQ false#">
			<cfprocparam cfsqltype="CF_SQL_LONGVARBINARY" dbvarname="@content" type="In" value="#bincontent#" null="#newfile EQ false#">
		</cfstoredproc>
	<cfelse>
		<cfif form.txtLink NEQ "">
			<cfset formType=2>
		<cfelse>
			<cfset formType=1>
		</cfif>
	</cfif>
	
	<cfif isdefined("form.chkActive")>
		<cfset active_flag=1>
	<cfelse>
		<cfset active_flag=0>
	</cfif>
	
	<cfstoredproc datasource="#session.dsn#" procedure="p_update_form">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@form_id" type="In" value="#form.form_id#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@name" type="In" value="#form.txtname#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@linkURI" type="In" value="#form.txtLink#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@formType" type="In" value="#formType#">
		<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@active_flag" type="In" value="#active_flag#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@contact_id" type="In" value="#session.user.contactid#">
	</cfstoredproc>
		
		
	<!--- redirect user --->
	<cflocation url="formsManage.cfm" addtoken="No">
	

</cfif>


<cfif isdefined("url.form_id")>
	<cfset form_id=url.form_id>
<cfelse>
	<!--- error --->
	<cfthrow message="Form ID is not defined">
</cfif>


<!--- get form info --->
<cfinvoke 
	component="#SESSION.sitevars.cfcPath#form" 
	method="getForm" 
	returnvariable="thisForm" 
	form_id="#form_id#">
</cfinvoke>

<cfif thisForm.recordcount EQ 0>
	<cfthrow message="Form does not exist anymore">
</cfif>



<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Edit Form</H1>
<!--- <h2>yyyyyy </h2> --->






	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
<form action="formsEdit.cfm" method="post" enctype="multipart/form-data">
<input type="Hidden" name="form_id" value="#form_id#">
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="2">
		 	Edit Form
		</TD>
	</tr>
	<TR><TD align="right"><b>Name</b></TD>
		<TD><input type="Text"  maxlength="50" name="txtName" value="#thisform.name#">
		</TD>
	</TR>
	<TR><TD align="right"><b>Link</b></TD>
		<TD><input type="Text" name="txtLink" value="#thisform.linkURI#">
		</TD>
	</TR>
	<TR><TD align="right"></TD>
		<TD><b>OR</b>
		</TD>
	</TR>
	<TR><TD align="right" width="20%"><b>New File:</b><cfif thisForm.formType EQ 1><br><a href="formsView.cfm?form_id=#form_id#">View Current</a></cfif></TD>
		<TD>
			<input type="File" name="fContent">
		</TD>
	</TR>
	<TR><TD align="right"><b>Active?</b></TD>
		<TD><input type="Checkbox" name="chkActive" value="1" <cfif thisform.active_flag>checked="checked"</cfif>>
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



 
