<!--- 
	FileName:	fieldsMerge.cfm
	Created on: 6/11/2009
	Created by: B. Cooper
	
	Purpose: (ADMIN USE) this will provide a way to search for and merge fields
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

					<!--- <CFIF isDefined("SESSION.REGSEASON.ID")>
						<CFSET seasonID = SESSION.REGSEASON.ID >
						<CFSET seasonTxT = SESSION.REGSEASON.SF & " " & SESSION.REGSEASON.YEAR>
						<CFSET seasonSF = SESSION.REGSEASON.SF>
					<CFELSE>
						<CFSET seasonID = SESSION.CURRENTSEASON.ID >
						<CFSET seasonTxT = SESSION.CURRENTSEASON.SF & " " & SESSION.CURRENTSEASON.YEAR>
						<CFSET seasonSF = SESSION.CURRENTSEASON.SF>
					</CFIF> --->
					
<cfif isdefined("form.btnMerge")>
	<cfdump var=#form#>
	<cfif not isdefined("form.rdKeep") OR form.rdKeep EQ "">
		<cfthrow message="You must select a field to keep">
	</cfif>
	<cfif not isdefined("form.chkdel") OR form.chkDel EQ "">
		<cfthrow message="You must select at least one field to delete">
	</cfif>
	<cfinvoke
		component="#session.sitevars.cfcpath#field"
		method="mergeFields"
		keepField="#form.rdKeep#"
		deleteFieldList="#form.chkdel#"
		returnvariable="merged">
	
	<!--- go back to merge main screen --->
	<cflocation url="fieldsMerge.cfm?success=1" addtoken="No">
</cfif>
					
					
<!--- check for search string --->					
<cfif isdefined("form.btnSearch")>
	<cfset searchString=form.txtSearch>
	<cfset showFields=true>

	<!--- get fields --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="searchFields" returnvariable="qFields">
		<cfinvokeargument name="qry" value="#searchString#">
	</cfinvoke>
	
<cfelse>
	<cfset searchString="">
	<cfset showFields=false>
</cfif>


<cfoutput>
<div id="contentText">
<cfif isdefined("url.success") AND url.success EQ "1">
	<div class="success">
		Your fields have been merged successfully
	</div>
</cfif>
<H1 class="pageheading">NCSA - Merge Fields</H1>

<script language="JavaScript"  type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$("input[name=rdKeep]").click(function(){
			//enable all checkboxes
			$("input[name=chkDel]:disabled").attr('disabled','');
			
			//disable this checkbox
			$(this).parent().next().find("input").attr('disabled','disabled');
			
			
			$("input[name=chkDel]:not(:checked)").parent().parent().css('background-color','');
			//fix checked rows
			$("input[name=chkDel]:checked").parent().parent().css('background-color','##ff5555');
			//$(this).parent().parent().siblings().css('background-color','');
			//highlight this row
			$(this).parent().parent().css('background-color','##FFFF55');
			
		});
		
		$("input[name=chkDel]").click(function(){
			//if selected, highlight, else not
			if($(this).is(":checked"))
			{
				$(this).parent().parent().css('background-color','##ff5555');
			}
			else
			{
				$(this).parent().parent().css('background-color','');
			}
		});
	});
</script>






	<form action="fieldsMerge.cfm" method="post">
		Search: <input type="text" name="txtSearch" value="#searchString#">
		<input type="Submit" name="btnSearch" value="Find Fields">
		<br>
		<br> <hr size="1">
	
	
		<CFIF showFields>
		<!--- <cfdump var=#qFields#> --->
	
			#qFields.recordcount# field<cfif qFields.recordcount NEQ 1>s</cfif> returned
			<table border="0" width="98%" cellpadding="2" cellspacing="0" class="table1">
				<tr>
					<th> Keep  </th>
					<th>Merge into field marked keep</th>
					<th> Field   </th>
					<th>Club</th>
				</tr>
				<CFIF qFields.recordCount>
					<cfloop query="qFields">
						<tr <cfif qFields.currentRow mod 2 is 0>class="altRow"</cfif>>
							<td>
								<input type="Radio" name="rdKeep" value="#field_id#">
							</td>
							<td>
								<input type="Checkbox" name="chkDel" value="#field_id#">
							</td>
							<td>
								#fieldname#
							</td>
							<td>
								#club_name#
							</td>
						</tr>
					</cfloop>
				<CFELSE>
					<tr>
						<td class="red" colspan="4"> 
							<b>Your search returned no fields.</b> 
						</td> 
					</tr>
				</CFIF>	
			</table>
			<br>
			<input type="submit" name="btnMerge" value="Merge">
		</CFIF>
	
	</form>
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
