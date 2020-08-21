<!----------------------------->
<!--- Application variables --->
<!----------------------------->
<cflock scope="application" type="readonly" timeout="10">
	<cfset reports_dsn = application.reports_dsn>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link  href="_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
		<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
		<script language="JavaScript" type="text/javascript" src="assets/jquery-validate/jquery.validate.js"></script>
		<script language="JavaScript" type="text/javascript">
		$(document).ready(function()
		{
		
			$('#folderForm').validate({
				rules:{
					txtName:{
						remote:{
							url:'async_validate_new_folder.cfm?s=<cfoutput>#jsstringformat(securestring)#</cfoutput>',
							type:'post',
							data:{
								organization_id:<cfoutput>#organization_id#</cfoutput>
							}
						},
						required:true
					}
				},
				messages:{
					txtName:{
						remote:'The folder name must be unique',
						required:'Folder name is required'
					}
				}
				
			});
			
		});
		</script>
	</head>
<body>

<CFINCLUDE TEMPLATE="header_rptBldr.cfm">
<div style="height:10px;width:auto;"> </div>

<table border="0" cellspacing="0" cellpadding="4" width="100%">
	<tr>
		<td class="mainhead" width="50%">Add Folder</td>
		<td class="mainhead" width="50%" align="right"></td>
	</tr>
</table>

<cfoutput>
	<form id="folderForm" method="post" action="rptBldr_folderAdd_action.cfm?s=#securestring#">

<table border="0" cellspacing="0" cellpadding="4" width="100%">
	<tr>
		<td class="aeformlabel" width="200" valign="top">Folder Name:</td>
		<td class="aeformfield">
			<input type="text" name="txtName">
		</td>
	</tr>
</table>
<table border="0" cellspacing="0" cellpadding="4" width="100%">
	<tr>
		<td class="mainsubhead" width="200">&nbsp;</td>
		<td class="mainsubhead">
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="75">
				<input type="submit" name="btnSave" value="Save" class="itemformbuttonleft">
				</td>
				<td width="75">
				<input type="button" name="cancel" value="Cancel" onclick="window.location='rptBldr_home.cfm?s=#securestring#';" class="itemformbuttonleft">
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

</cfoutput>
</body>
</html>

