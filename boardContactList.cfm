<!--- 
	FileName:	boardContactList.cfm
	Created on: 11/17/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to edit the board member's contact info
	
MODS: mm/dd/yyyy - flastname - comments

 --->

<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">



<cfif isDefined("FORM.AddMember")>
	<cflocation url="boardContactAdd.cfm">
</cfif>


<cfoutput>
	<div id="contentText">
	<H1 class="pageheading">NCSA - Board of Directors and Commissioners</H1>
	<!--- <h2>yyyyyy </h2> --->
	<cfsavecontent variable="localStyle">
		<style>
			.button-group{
				    height: 25px;
			}
			.label-group {
					display: block;
				padding-left: 12%;
				text-indent: 1%;
				padding-top: 1%;
			}
			.label-group > input {
					width: 13px;
				height: 13px;
				padding: 0;
				margin: 0;
				vertical-align: middle;
				position: relative;
				top: -1px;
			}
			ul.list-unstyled{
			margin-bottom:2%;
			padding-bottom:2%;
			width: 79%;
		}
			##page_list li
			{
				padding:16px;
				background-color:##f9f9f9;
				border:1px dotted ##ccc;
				cursor:grab;
				margin-top:12px;
				width: 100%;
				min-width: 840px;
			}
			##page_list li.ui-state-highlight
			{
				padding:24px;
				background-color:##b7d7e8;
				border:1px dotted ##ccc;
				cursor:grab;
				margin-top:12px;
			}


			##page_list_nosort li
			{
				padding:16px;
				background-color:##f9f9f9;
				border:1px dotted ##ccc;
				margin-top:12px;
				width: 100%;
			}
			##page_list_nosort li.ui-state-highlight
			{
				padding:24px;
				background-color:##b7d7e8;
				border:1px dotted ##ccc;
				margin-top:12px;
			}

			.bm-style{
				margin: 0 2% 0 2%;
				padding-top: 1%;
				overflow-wrap: break-word;
				width: 33%;
			}
			.status{
				float:right;
				margin-right: 23%;
			}
			.add-board-member{
				float: right;
				color: white;
				background-color: ##4e5063;
				border-radius: 4px;
				padding: 1%;
				margin-right: 6%;
				margin-top: -1%;
				text-rendering: auto;
			}
			.add-board-member:hover{
				background-color:##85858a;
			}
			a.link-button{
				color:white;
				text-decoration: none;
			}
			a.link-button:hover{
				text-decoration: none;
			}
			.instructions{
				padding: 1% 1%;
				width: 92%;
				background: ##eee;
				margin: 2%;
				border-radius: 5px;
				border: 1px solid ##aaa;
			}
		</style>
	</cfsavecontent>
	<cfhtmlhead text="#localStyle#">
	<cfquery name="getBMCategory" datasource="#application.dsn#">
		Select board_category_id,
				parent_board_category_id,
				board_category_desc 
		from 
				tlkp_board_category where status_id = 1
	</cfquery>

	<cfif isdefined("form.inactive_yn")>
		<cfset active_yn = ''>
	<cfelse>
		<cfset active_yn = 'Y'>
	</cfif>
	<cfif isdefined("url.board_category_id")>
		<cfset variables.board_category_id = url.board_category_id>
	<cfelseif isdefined("form.board_category_id")>
		<cfset variables.board_category_id = form.board_category_id>
	<cfelse>
		<cfset variables.board_category_id = "">
	</cfif>

	<div>
	<form action="boardContactList.cfm" method="post">
		<div class="add-board-member"><a href="boardContactAdd.cfm" class="link-button">Add Board Member</a></div>
		<div class="button-group">
			<label>
				Board Category:
				<select name="board_category_id" id="board_category_id">
				<option value="">-----Select a Board Category------</option>
				<option value="0"  #IIF(variables.board_category_id EQ 0, DE('SELECTED'), DE(''))#>All</option>
				<cfloop query="getBMCategory">
					<option value="#board_category_id#" #IIF(variables.board_category_id EQ board_category_id, DE('SELECTED'), DE(''))#>
					#board_category_desc#</option>
				</cfloop>
			</select>
			</label>
			
		</div>
<!--- 		<div class="checkbox-group">
			<label class="label-group"><input type="checkbox" name="inactive_yn" id="inactive" #iif(active_yn eq '',de('checked'),de(''))#> Show Inactive </label>
		</div> --->
		<cfif variables.board_category_id gt 0>
			<div class="instructions">To reorder sequence, hover over the member you wish to move until you see the hand, click and hold the block, drag it where you want to move it and release the click.</div>
			<cfset sortableTarget = 'id="page_list"'>
		<cfelse>
			<cfset sortableTarget = 'id="page_list_nosort"'>
		</cfif>
		<cfif isdefined("variables.board_category_id") and len(trim(variables.board_category_id))>
			<cfinvoke component="#SESSION.sitevars.cfcPath#contact" method="getBoardMemberInfo" returnvariable="boardMembers">
				<cfinvokeargument name="DSN" value="#SESSION.DSN#">
				<cfinvokeargument name="board_category_id" value="#variables.board_category_id#">
				<cfinvokeargument name="active_yn" value="#active_yn#">
			</cfinvoke>  <!--- <cfdump var="#boardMembers#"> --->



			<input type="Hidden" name="MemberCount" value="#boardMembers.RECORDCOUNT#">
			<table cellspacing="0" cellpadding="0"   align="left" border="0" width="75%" >
				<tr >
					<td valign="top" > 
						<ul class="list-unstyled" #sortableTarget#>
							<CFLOOP query="boardMembers">					
								<li id="#BOARDMEMBER_ID#">
									<span class="bm-style">Name:<a href="boardContactEdit.cfm?bmid=#BOARDMEMBER_ID#" title="Click To Edit #FIRSTNAME# #LASTNAME#"> 
								#FIRSTNAME# #LASTNAME# </a></span> 
									<!--- <span class="bm-style status">Status:
										<cfif ACTIVE_YN EQ "Y">
											<b class="green">ACTIVE</b>
										<cfelse>
											<b class="red">INACTIVE</b>
										</cfif>
									</span> --->
									<div class="bm-style">Board Category: <b>#board_category_desc#</b></div>
									<div class="bm-style">Title: <b>#TITLE#</b></div>
									<div class="bm-style">Area of Responsibility: <b>#Responsibility_Desc#</b></div>
								</li>

							</CFLOOP>		
						</ul>
					</td>
					</tr>
<!--- 					<tr> 
						<td colspan="2" align="left">
							<input type="Submit" name="AddMember"  value="ADD a Board Member">
						</td>
					</tr>--->
			</table>
		</cfif>
	</form>  	

</div>
</cfoutput>

<cfsavecontent variable="cf_footer_scripts">

   <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <script>
  	$(function() {
	    $('#board_category_id, #inactive').change(function() {
	        this.form.submit();
	    });
		var boardmember_id_array = new Array();
				$('#page_list li').each(function(){
					boardmember_id_array.push($(this).attr("id"));
				});
		$( "#page_list" ).sortable({
			
			placeholder : "ui-state-highlight",
			axys : "y",
			update  : function(event, ui)
			{   
				var _memberCount = $("input[name=MemberCount]").val();
				var sequence_array = new Array();
				var boardmember_id_array = $(this).sortable('toArray').toString();
				$.ajax({
					url:"updateBoardSeq.cfm",
					method:"POST",
					data:{boardmember_id_array:boardmember_id_array,MemberCount:_memberCount},
					success:function(data)
					{
						boardmember_id_array = new Array();
						$('#page_list li').each(function(){
							boardmember_id_array.push($(this).attr("id"));
						});
					}
				});
			}
		});


	});
  </script>
</cfsavecontent>
<cfinclude template="_footer.cfm">