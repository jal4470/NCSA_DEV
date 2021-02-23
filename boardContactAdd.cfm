<!--- 
	FileName:	boardContactAdd.cfm
	Created on: 11/18/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to add board member 
	
MODS: mm/dd/yyyy - flastname - comments

 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
	<cfsavecontent variable="localStyle">
		<style>
			.Contact{
				margin-left: 12%;
    			margin-top: 2%;
			}
			.Contact > div > label {
				padding:5%;
				line-height: 24px;
			}
			.hr{border-bottom:1px solid ##ccc;}
			.ci-head{
				margin-bottom: 4px;
				border-bottom: 1px solid #ccc;
				font-weight: bold;
				width: 50%;
			}
		</style>
	</cfsavecontent>
	<cfhtmlhead text="#localStyle#">


<cfsavecontent variable="localStyle">
	<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/css/select2.min.css" rel="stylesheet" /> 
</cfsavecontent>
<cfhtmlhead text="#localStyle#">

<cfif isDefined("FORM.BACK")>
	<cflocation url="boardContactList.cfm">
</cfif>


<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Boardmember Add</H1>

<cfset swErrors = false>	
<cfset errMsg = "">

<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getRoleList" returnvariable="qRoles">
	<cfinvokeargument name="listRoleType" value="'BU'">
</cfinvoke><!---  <cfdump var="#qRoles#"> --->
<cfset lRoleIDs = valueList(qRoles.ROLE_ID)>

<cfset useSeason = SESSION.CURRENTSEASON.ID>
<cfif isDefined("SESSION.regSeason.ID")>
	<cfset useSeason = SESSION.regSeason.ID>
</cfif>
<cftry>
<!--- get all contacts that have specific roles --->
<CFQUERY name="getcontactRoles" datasource="#SESSION.DSN#">
	select x.contact_id, c.FirstNAme, c.LastName,max(xref_contact_role_ID)  xref_contact_role_ID, max(r.roleCode) roleCode, max(r.role_id) role_id, c.phoneHome, c.phoneCell, c.Email
	  from xref_contact_role x 
			INNER JOIN TBL_CONTACT c on c.CONTACT_ID = x.CONTACT_ID
			INNER JOIN TLKP_ROLE   r on r.role_id  = x.role_id  
	 where  x.role_id IN (#VARIABLES.lRoleIDs#) and
	    x.club_id = 1 
	   and x.season_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.useSeason#">
	   and x.active_yn = 'Y'
	GROUP BY  x.contact_id, c.FirstNAme, c.LastName, c.phoneHome, c.phoneCell, c.Email
	ORDER BY c.LastName, c.FirstNAme
</CFQUERY> <!--- <cfdump var="#getcontactRoles#"> --->

<cfif isDefined("FORM.xrefContactRoleID")> 
	<cfset xrefContactRoleID = FORM.xrefContactRoleID>
<cfelse>
	<cfset xrefContactRoleID = "0">
</cfif>

<cfif isDefined("FORM.ncsaTitle")> 
	<cfset ncsaTitle = trim(FORM.ncsaTitle)>
<cfelse>
	<cfset ncsaTitle = "">
</cfif>

<cfif isDefined("FORM.Responsibility_Desc")> 
	<cfset Responsibility_Desc = trim(FORM.Responsibility_Desc)>
<cfelse>
	<cfset Responsibility_Desc = "">
</cfif>

<cfif isDefined("FORM.board_category_id")> 
	<cfset board_category_id = trim(FORM.board_category_id)>
<cfelse>
	<cfset board_category_id = "">
</cfif>

<cfif isDefined("FORM.ncsaPhone")> 
	<cfset ncsaPhone = trim(FORM.ncsaPhone)>
<cfelse>
	<cfset ncsaPhone = "">
</cfif>

<cfif isDefined("FORM.ncsaFax")> 
	<cfset ncsaFax = trim(FORM.ncsaFax)>
<cfelse>
	<cfset ncsaFax = "">
</cfif>

<cfif isDefined("FORM.ncsaEmail")> 
	<cfset ncsaEmail = trim(FORM.ncsaEmail)>
<cfelse>
	<cfset ncsaEmail = "">
</cfif>

<cfif isDefined("FORM.SAVE")>
	<cfinvoke component="#SESSION.sitevars.cfcPath#formValidate" method="validateFields" returnvariable="stValidFields">
		<cfinvokeargument name="formFields" value="#FORM#">
	</cfinvoke>  <!--- <cfdump var="#stValidFields#"> --->
	
	<CFIF stValidFields.errors>
		<cfset swErrors = true>	
	</CFIF>
	
	<CFIF NOT swErrors>
		<CFIF FORM.xrefContactRoleID eq 0>
			<cfset contact_id = 0>
		<CFELSE>
			<CFQUERY name="getSpecificContactRole" dbtype="query">
				select contact_id, role_id
				from getcontactRoles
				where xref_contact_role_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.xrefContactRoleID#">
			</CFQUERY> 
			<cfset contact_id = getSpecificContactRole.contact_id>
		</CFIF>
	
		<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="insertBoardMemberInfo" returnvariable="boardMemberID">
			<cfinvokeargument name="sequence"		   value="99">
			<cfinvokeargument name="ContactID" 	value="#variables.contact_id#">
			<cfinvokeargument name="Responsibility_Desc"	   value="#FORM.Responsibility_Desc#">
			<cfinvokeargument name="board_category_id"	   value="#FORM.board_category_id#">
			<cfinvokeargument name="ncsaTitle" value="#FORM.ncsaTitle#">
		</cfinvoke>

		<cfif len(trim(boardMemberID)) AND boardMemberID GT 0>
			<cflocation url="boardContactList.cfm?board_category_id=#board_category_id#">
		<cfelse>
			<cfset swErrors = true>	
			<cfset errMsg = "Boardmember was not added, please try again.">
		</cfif>
	</CFIF>
</cfif>
<cfquery name="getBMCategory" datasource="#application.dsn#">
	Select board_category_id,
			parent_board_category_id,
			board_category_desc 
	from 
			tlkp_board_category where status_id = 1
</cfquery>

	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">

<form action="boardContactAdd.cfm" method="post">

<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD colspan="2">
		 	Add a Boardmember:
		</TD>
	</tr>
		<cfif swErrors>
			<TR><TD colspan="2" align="center" class="red">
					<b>Please correct the following errors and submit again.</b>
					<br>
					#stValidFields.errorMessage#
					#errMsg#
				</td>
			</TR>
		</cfif>
	<TR><TD align="right" width="20%"><b>Board Contact:</b></TD>
		<TD><select  name="xrefContactRoleID" id='selUser' style="width: 223px;" >
				<option value="0" >Select or Search</option>
				<cfloop query="getcontactRoles">
				<option value="#xref_contact_role_ID#" <cfif xrefContactRoleID EQ xref_contact_role_ID>selected</cfif> data-contact='{"phone-home":"#phoneHome#","phone-cell":"#phoneCell#","email":"#email#"}'   > #LastName#, #FirstNAme#</option>
				</cfloop>
			</select>			
<!--- 			<input type='button' value='Seleted option' id='but_read'> 
			<br/>
			<div id='result'></div>--->
		</TD>
	</TR>

	<TR><TD align="right">#required# <b>NCSA Title</b></TD>
		<TD><input type="Text"  maxlength="50" name="ncsaTitle" value="#ncsaTitle#" >
			<input type="Hidden" name="ncsaTitle_ATTRIBUTES" 	value="type=GENERIC~required=1~FIELDNAME=NCSA Title">	
		</TD>
	</TR>
	<TR>
		<TD align="right">#required# <b>Area of Responsibility (200 Chars Max)</b></TD>
		<TD>
			<textarea name="RESPONSIBILITY_DESC" cols="30" rows="3" maxlength="200">#Responsibility_Desc#</textarea>
			
			<!--- <input type="Text"  maxlength="128" name="RESPONSIBILITY_DESC"  size="200"	value="#Responsibility_Desc#" >
			<input type="Hidden" name="ncsaAoR_ATTRIBUTES" value="type=GENERIC~required=0~FIELDNAME=Area of Responsibility">	 --->
		</TD>
	</TR>
	<TR>
		<TD align="right">
			#required# <b>Board Category:</b>
		</TD>
		<TD>
			<select name="board_category_id" id="board_category_id">
				<option value="">-----Select a Board Category------</option>
				<cfloop query="getBMCategory">
					<option value="#board_category_id#" #IIF(board_category_id EQ variables.board_category_id, DE('SELECTED'), DE(''))#>
					#board_category_desc#</option>
				</cfloop>
			</select>
		</TD>
	</TR>


<!--- 	<TR><TD align="right">#required# <b>NCSA Phone</b></TD>
		<TD><input type="Text"  maxlength="20" name="ncsaPhone" placeholder="999-999-9999" value="#ncsaPhone#" >
			<input type="Hidden" name="ncsaPhone_ATTRIBUTES" 	value="type=PHONE~required=1~FIELDNAME=NCSA Phone">	
		</TD>
	</TR>
	<TR><TD align="right"><b>NCSA Fax</b></TD>
		<TD><input type="Text"  maxlength="20" name="ncsaFax" placeholder="999-999-9999" value="#ncsaFax#" >
			<input type="Hidden" name="ncsaFax_ATTRIBUTES" 		value="type=PHONE~required=0~FIELDNAME=NCSA Fax">	
		</TD>
	</TR>
	<TR><TD align="right">#required# <b>NCSA Email</b></TD>
		<TD><input type="Text"  maxlength="50" name="ncsaEmail" value="#ncsaEmail#" >
			<input type="Hidden" name="ncsaEmail_ATTRIBUTES" 	value="type=EMAIL~required=1~FIELDNAME=NCSA Email">	
		</TD>
	</TR> --->
	<TR>
		<TD colspan="2">
			<DIV class="Contact">
			</DIV>
		</TD>
	</TR>
	<tr><td colspan="2"><hr/></td></tr>
	<tr><td>&nbsp;		</td>
		<td><input type="Submit" name="Save"  value="Save">
			<input type="Submit" name="Back"  value="Back">
		</td>
	</tr>
</table>
</form>  	

</div>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>
</cfoutput>

<cfsavecontent variable="cf_footer_scripts">

	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  
	<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/js/select2.min.js"></script>
	<script>
		$(function() {
			displayContact();
				// Initialize select2
			$("#selUser").select2();

				// Read selected option
			$('#but_read').click(function(){
				var username = $('#selUser option:selected').text();
				var userid = $('#selUser').val();

				$('#result').html("id : " + userid + ", name : " + username);

			});

			$("#selUser").change(function(){
				displayContact();
			});

			function displayContact(){
				var _contact_obj = new Object();

				_contact_obj = $('#selUser option:selected').data('contact')

				$(".Contact").empty();
				var _output = "<div class='ci-head'>CONTACT INFO</div>" 
				if(typeof _contact_obj != 'undefined')
				{
					_output = _output + "<div><label> Email:" +  _contact_obj['email'] + "</label></div>" + "<div><label> Home Phone:" + _contact_obj['phone-home'] + "</label></div>"  + "<div><label> Cell Phone:" + _contact_obj['phone-cell'] + "</label></div>" ;
				} else {
					_output = _output + "<div><label> Email: Vacant </label></div>" + "<div><label> Home Phone: N/A </label></div>"  + "<div><label> Cell Phone: N/A </label></div>" ;
				}
				$(".Contact").append(_output).hide().fadeIn(600);
			}


			$('input[name=Save]').click(function(event){

				var _title = $("input[name=ncsaTitle]").val(),
				 _res_desc = $("textarea[name=RESPONSIBILITY_DESC]").val(),
				 _bci_selected = $('#board_category_id option:selected').val();
				
				if(_title.length == 0)
				{
					alert("Please provide a Title");
					return false;
				}	

				
				
				if(_res_desc.length == 0)
				{
					alert("Please provide an Area of Responsibility");
					return false;
				}	

				
				
				if (_bci_selected == 0)
				{
					alert("Please select a Board Category");
					return false;
				}

					

			});

		});
	</script>
</cfsavecontent>
<cfinclude template="_footer.cfm">






