<!--- 
	FileName:	formsDetails.cfm
	Created on: 4/20/2010
	Created by: B. Cooper
	
	Purpose: details on form
	
MODS: mm/dd/yyyy - flastname - comments

 --->

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
	<div id="contentText">
		<H1 class="pageheading">NCSA - Forms Details</H1>
		
		
		<!--- get form info --->
		<cfinvoke 
			component="#SESSION.sitevars.cfcPath#form" 
			method="getForm" 
			returnvariable="thisForm" 
			form_id="#form_id#">
		</cfinvoke>
		
		
		<div>
			<div style="float:left;">
				<a class="actionLink" href="formsManage.cfm">Back</a>
			</div>
			<div style="float:right;">
				<a class="actionLink" href="formsEdit.cfm?form_id=#form_id#">Edit</a> <a class="actionLink" href="formsDelete.cfm?form_id=#form_id#" onclick="return confirm('Are you sure you want to remove this form?');">Delete</a>
			</div>
		</div>
		<table cellspacing="0" cellpadding="0" border="0" width="98%" class="dvTable">
			<tr>
				<th>Name</th>
				<td>#thisForm.name#</td>
			</tr>
			<tr>
				<th>Type</th>
				<td><cfif thisform.formType EQ 1>File<cfelse>Link</cfif></td>
			</tr>
			<cfif thisform.formType EQ 1>
				<tr>
					<th>Location</th>
					<td>formsView.cfm?form_id=#form_id#</td>
				</tr>
				<tr>
					<th>Filename</th>
					<td><a href="formsView.cfm?form_id=#form_id#">#thisForm.filename#.#thisform.extension#</a></td>
				</tr>
			<cfelse>
				<tr>
					<th>Location</th>
					<td><a href="#thisform.linkURI#">#thisform.linkURI#</a></td>
				</tr>
			</cfif>
			<tr>
				<th>Active</th>
				<td>#yesnoformat(thisForm.active_flag)#</td>
			</tr>
			<tr>
				<th>Created</th>
				<td>#dateformat(thisForm.datecreated,"m/d/yyyy")# #timeformat(thisForm.datecreated,"h:mm tt")#<cfif thisForm.createdLname NEQ ""> by #thisForm.createdFname# #thisForm.createdLname#</cfif></td>
			</tr>
			<tr>
				<th>Updated</th>
				<td>#dateformat(thisForm.dateupdated,"m/d/yyyy")# #timeformat(thisForm.dateupdated,"h:mm tt")#<cfif thisForm.updatedLname NEQ ""> by #thisForm.updatedFname# #thisForm.updatedLname#</cfif></td>
			</tr>
		</table>
	</div>

</cfoutput>
<cfinclude template="_footer.cfm">