<!--- 
	FileName:	boardContactEdit.cfm
	Created on: 11/17/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to edit the board member's contact info
	
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
		<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/css/select2.min.css" rel="stylesheet" /> 
	</cfsavecontent>
	<cfhtmlhead text="#localStyle#">

<cfsavecontent variable="localStyle">
	<style>
		.button-group{
			margin-left:20%;
			margin-top:1%;
		}
	</style>
</cfsavecontent>
<cfhtmlhead text="#localStyle#">
<cfif isDefined("FORM.BACK")>
	<cflocation url="boardContactList.cfm?board_category_id=#FORM.board_category_id#">
</cfif>


<div id="contentText">
<H1 class="pageheading">NCSA - Boardmember Edit</H1>
<!--- <h2>yyyyyy </h2> --->



<CFIF isDefined("URL.BMID") AND isNumeric(URL.BMID)>
	<cfset bmID = URL.BMID >
<cfelseif isDefined("FORM.boardMemberID") AND isNumeric(FORM.boardMemberID)>
	<cfset bmID = FORM.boardMemberID >
<cfelse>
	<cfset bmID = 0 >
</CFIF>


<cfif isDefined("FORM.DEACTIVATE")>
	<cfquery name="qDeactivateBoardMember" datasource="#SESSION.DSN#">
		DELETE FROM TBL_BOARDMEMBER_INFO
		 WHERE BOARDMEMBER_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.BOARDMEMBERID#">
	</cfquery>
	<cflocation url="boardContactList.cfm?board_category_id=#FORM.board_category_id#">
</cfif>

<!--- <cfif isDefined("FORM.ACTIVATE")>
	<cfquery name="qActivateBoardMember" datasource="#SESSION.DSN#">
		UPDATE TBL_BOARDMEMBER_INFO
		   SET ACTIVE_YN = 'Y'
		     , SEQUENCE = 99
		 WHERE BOARDMEMBER_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#FORM.BOARDMEMBERID#">
	</cfquery>
	<cflocation url="boardContactList.cfm?board_category_id=#FORM.board_category_id#">
</cfif> --->




<CFIF isDefined("FORM.SAVE")>
	<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="updateBoardMemberInfo">
		<cfinvokeargument name="boardMemberID" value="#FORM.boardMemberID#">
		<cfinvokeargument name="sequence"	   value="#FORM.sequence#">
		<cfinvokeargument name="ncsaTitle"	   value="#FORM.ncsaTitle#">
		<cfinvokeargument name="Responsibility_Desc"	   value="#FORM.Responsibility_Desc#">
		<cfinvokeargument name="board_category_id"	   value="#FORM.board_category_id#">
		<cfinvokeargument name="contact_id"	   value="#FORM.contact_id#">
	</cfinvoke>

	<cflocation url="boardContactList.cfm?board_category_id=#FORM.board_category_id#">
	
</CFIF>


<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getRoleList" returnvariable="qRoles">
	<cfinvokeargument name="listRoleType" value="'BU'">
</cfinvoke><!---  <cfdump var="#qRoles#"> --->
<cfset lRoleIDs = valueList(qRoles.ROLE_ID)>

<cfset useSeason = SESSION.CURRENTSEASON.ID>
<cfif isDefined("SESSION.regSeason.ID")>
	<cfset useSeason = SESSION.regSeason.ID>
</cfif>

<!--- get all contacts that have specific roles --->
<CFQUERY name="getcontactRoles" datasource="#SESSION.DSN#">
	select x.contact_id, c.FirstNAme, c.LastName,max(xref_contact_role_ID)  xref_contact_role_ID, max(r.roleCode) roleCode, max(r.role_id) role_id, c.phoneHome, c.phoneCell, c.Email
	  from xref_contact_role x 
			INNER JOIN TBL_CONTACT c on c.CONTACT_ID = x.CONTACT_ID
			INNER JOIN TLKP_ROLE   r on r.role_id  = x.role_id  
	 where  x.role_id IN (#VARIABLES.lRoleIDs#) and
	    x.club_id = 1  and r.roleType = 'BU'
	   and x.season_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.useSeason#">
	   and x.active_yn = 'Y'
	GROUP BY  x.contact_id, c.FirstNAme, c.LastName, c.phoneHome, c.phoneCell, c.Email
	ORDER BY c.LastName, c.FirstNAme
</CFQUERY> <!--- <cfdump var="#getcontactRoles#"> --->


<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getBoardMemberInfo" returnvariable="boardMems">
	<cfinvokeargument name="DSN" value="#SESSION.DSN#">
	<cfinvokeargument name="boardMemberID" value="#VARIABLES.bmID#">
</cfinvoke><!--- <cfdump var="#boardMems#">   --->

<cfif boardMems.recordCount>
	<cfset boardmember_id = boardMems.boardmember_id >
	<!--- <cfset xrefContactRoleID	 = boardMems.XREF_CONTACT_ROLE_ID > --->
	<cfset sequence	 = boardMems.sequence >
	<cfset firstName = boardMems.FIRSTNAME >
	<cfset lastName	 = boardMems.LASTNAME >
	<cfset ncsaTitle = boardMems.TITLE >
	<cfset activeYN  = boardMems.ACTIVE_YN >
	<cfset Responsibility_Desc = boardMems.Responsibility_Desc>
	<cfset board_category_id = boardMems.board_category_id>
	<cfset CONTACTEMAIL = boardMems.CONTACTEMAIL>
	<cfset CONTACTPHONEHOME = boardMems.CONTACTPHONEHOME>
	<cfset CONTACTPHONECELL = boardMems.CONTACTPHONECELL>
<cfelse>
	<cfset boardmember_id = "" >
 <!---	<cfset xrefContactRoleID	 = "" > --->
	<cfset sequence	 = "" >
	<cfset firstName = "" >
	<cfset lastName	 = "" >
	<cfset ncsaTitle = "" >
	<cfset activeYN  = "" >
	<cfset Responsibility_Desc = ""> 
	<cfset board_category_id = "">
	<cfset CONTACTEMAIL = "">
	<cfset CONTACTPHONEHOME = "">
	<cfset CONTACTPHONECELL = ""> 
</cfif>

<cfquery name="getBMCategory" datasource="#application.dsn#">
	Select board_category_id,
			parent_board_category_id,
			board_category_desc 
	from 
			tlkp_board_category where status_id = 1
</cfquery>

<cfoutput>
	<span class="red">Fields marked with * are required</span>
	<CFSET required = "<FONT color=red>*</FONT>">
	<form action="boardContactEdit.cfm" method="post" id="theForm">
	<input type="Hidden" name="boardMemberID" value="#VARIABLES.bmID#">
	<input type="Hidden" name="sequence" 	  value="#VARIABLES.sequence#">
	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
		<!--- <tr class="tblHeading">
			<TD colspan="2">
				Edit Boardmember: #LastName#, #FirstName# 	
			</TD>
		</tr> --->
		<cftry>
			<TR><TD align="right" width="20%"><b>Edit Boardmember:</b></TD>
				<TD><select  name="contact_id" id='selUser' style="width: 223px;" >
						<option value="0" >Select or Search</option>
						<cfloop query="getcontactRoles">
						<option value="#contact_id#" <cfif variables.lastname EQ lastname and variables.firstname EQ firstname>selected</cfif> data-contact='{"phone-home":"#phoneHome#","phone-cell":"#phoneCell#","email":"#email#"}'   > #LastName#, #FirstNAme#</option>
						</cfloop>
					</select>			
		<!--- 			<input type='button' value='Seleted option' id='but_read'> 
					<br/>
					<div id='result'></div>--->
				</TD>
			</TR>
		<cfcatch>
			<cfdump var="#cfcatch#" abort="true">
		</cfcatch>
		</cftry>
		<!--- <TR><TD align="right" width="20%"><b>Name:</b></TD>
			<TD>#LastName#, #FirstName#
				<cfif activeYN EQ "Y">
					- <span class="green"><b>ACTIVE</b></span>
				<cfelse>
					- <span class="red"><b>NOT Active</b></span>
				</cfif>
			</TD>
			
		</TR> --->
		<TR><TD align="right">#required# <b>NCSA Title/Position</b></TD>
			<TD><input type="Text"  maxlength="50" name="ncsaTitle" 	value="#ncsaTitle#" >
				<input type="Hidden" name="ncsaTitle_ATTRIBUTES" value="type=GENERIC~required=0~FIELDNAME=NCSA Title">	
			</TD>
		</TR>
		<TR>
			<TD align="right">#required# <b>Area of Responsibility (200 Chars Max)</b></TD>
			<TD>
				<textarea name="RESPONSIBILITY_DESC" cols="30" rows="3"  maxlength="200">#Responsibility_Desc#</textarea>
				<!--- <input type="Text"  maxlength="128" name="RESPONSIBILITY_DESC"  size="40"	value="#Responsibility_Desc#" >
				<input type="Hidden" name="ncsaAoR_ATTRIBUTES" value="type=GENERIC~required=0~FIELDNAME=Area of Responsibility">	 --->
			</TD>
		</TR>
		<cftry>
		<TR>
			<TD align="right">
				#required# <b>Board Category:</b>
			</TD>
			<TD>
				<select name="board_category_id" id="board_category_id">
					<option value="">-----Select a Board Category------</option>
					<cfloop query="getBMCategory">
						<option value="#board_category_id#" #IIF(variables.board_category_id EQ board_category_id, DE('SELECTED'), DE(''))#>
						#board_category_desc#</option>
					</cfloop>
				</select>
			</TD>
		</TR>
		<cfcatch><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
	<!--- 	<TR><TD align="right"><b>NCSA Phone</b></TD> 
			<TD><input type="Text"  maxlength="20" name="ncsaPhone"  Placeholder="999-999-9999"	value="#ncsaPhone#" >
				<input type="Hidden" name="ncsaPhone_ATTRIBUTES" value="type=PHONE~required=0~FIELDNAME=NCSA Phone">	
			</TD>
		</TR>
		<TR><TD align="right"><b>NCSA Fax</b></TD>
			<TD><input type="Text"  maxlength="20" name="ncsaFax"  Placeholder="999-999-9999"	value="#ncsaFax#" >
				<input type="Hidden" name="ncsaFax_ATTRIBUTES" value="type=PHONE~required=0~FIELDNAME=NCSA Fax">	
			</TD>
		</TR>
		<TR><TD align="right"><b>NCSA Email</b></TD>
			<TD><input type="Text"  maxlength="50" name="ncsaEmail"  size="40"	value="#ncsaEmail#" >
				<input type="Hidden" name="ncsaEmail_ATTRIBUTES" value="type=EMAIL~required=0~FIELDNAME=NCSA Email">	
			</TD>
		</TR>
		<TR>--->
		<td colspan="2">
				<div class="Contact"><div class="ci-head">CONTACT INFO</div>
				<div><label> Email:#CONTACTEMAIL#</label></div>
				<div><label> Home Phone:#CONTACTPHONEHOME#</label></div>
				<div><label> Cell Phone:#CONTACTPHONECELL#</label></div></div>
			</td>
		</TR>

		<tr><td colspan="2"><hr/></td></tr>
		<tr><td colspan="2"  >
				<div class="button-group">
					<CFIF activeYN EQ "Y">
						<input type="Submit" name="DEACTIVATE"  value="Delete">
					<CFELSE>
						<input type="Submit" name="ACTIVATE"  	value="Make Active">
					</CFIF>
					&nbsp;&nbsp;
					<input type="Submit" name="Save"    value="Save Changes">
					&nbsp;&nbsp;
					<input type="Submit" name="Back"    value="Back to List">
				</div>
			</td>
		</tr>
	</table>
	</form>  	

</div>
</cfoutput>

<cfsavecontent variable="cf_footer_scripts">

	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  
	<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/js/select2.min.js"></script>
	<script>
		$(function() {
			// Initialize select2
			$("#selUser").select2();

			// Read selected option
			$('#but_read').click(function(){
				var username = $('#selUser option:selected').text();
				var userid = $('#selUser').val();

				$('#result').html("id : " + userid + ", name : " + username);

			});

			$("#selUser").change(function(){
				var _contact_obj = new Object();
				
				_contact_obj = $('#selUser option:selected').data('contact');
				$(".Contact").empty();
				var _output = "<div class='ci-head'>CONTACT INFO</div>" 
				if(typeof _contact_obj != 'undefined')
				{
					_output = _output + "<div><label> Email:" +  _contact_obj['email'] + "</label></div>" + "<div><label> Home Phone:" + _contact_obj['phone-home'] + "</label></div>"  + "<div><label> Cell Phone:" + _contact_obj['phone-cell'] + "</label></div>" ;
				} else {
					_output = _output + "<div><label> Email: Vacant </label></div>" + "<div><label> Home Phone: N/A </label></div>"  + "<div><label> Cell Phone: N/A </label></div>" ;
				}
				$(".Contact").append(_output).hide().fadeIn(600);
			});

				// Read selected option
			$('input[name=DEACTIVATE]').click(function(event){
				return confirm('Are you sure you want to delete this Board Member?');
			});

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



 
