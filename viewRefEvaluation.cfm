<!--- 
	FileName:	viewRefEvaluation.cfm
	Created on: 3/16/2011
	Created by: bcooper@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 <cfsetting showdebugoutput="No">
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>

<cfif isdefined("url.response_id")>
	<cfset response_id=url.response_id>
</cfif>

<!--- get game ID --->
<cfquery datasource="#application.dsn#" name="getGame">
	select 	r.team_id, 
			g.*,
			refc.firstname + ' ' + refc.lastname as refname,
			asst1c.firstname + ' ' + asst1c.lastname as asst1name,
			asst2c.firstname + ' ' + asst2c.lastname as asst2name
	from 
	(
	select r.response_id, r.value as game_id, r2.value as team_id
	from dbo.f_get_choice_responses(69,81) r
	inner join dbo.f_get_choice_responses(70,81) r2
	on r.response_id=r2.response_id
	UNION
	select r.response_id, r.value as game_id, r2.value as team_id
	from dbo.f_get_choice_responses(69,82) r
	inner join dbo.f_get_choice_responses(70,82) r2
	on r.response_id=r2.response_id
	) r
	inner join v_games_all g
	on r.game_id=g.game_id
	left join tbl_contact refc
	on g.refid=refc.contact_id
	left join tbl_contact asst1c
	on g.asstrefid1=asst1c.contact_id
	left join tbl_contact asst2c
	on g.asstrefid2=asst2c.contact_id
	where r.response_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#response_id#">
</cfquery>






<cfsavecontent variable="cfhtmlhead_response">
<script>
window.onload = function () {
		document.getElementById("btnEdit").onclick = function () {
			window.location = "refEvaluationEdit.cfm?response_id=#response_id#";
		};
		document.getElementById("btnDelete").onclick = function () {
			if (confirm("Are you sure you want to delete this submission?"))
				window.location = "refEvaluationDelete.cfm?response_id=#response_id#&team_id=#getGame.team_id#&btnDelete=true";
		};
	};
</script>
<style>
##response_options
{
	text-align: right;
}
</style>
</cfsavecontent>
<cfhtmlhead text="#cfhtmlhead_response#">


<div id="contentText">
<H1 class="pageheading">NCSA - View Detailed Referee Evaluation</H1>
<br> <!--- <h2>yyyyyy </h2> --->

		<cfif isdefined("url.formSave")>
			<cfswitch expression="#url.formSave#">
				<cfcase value="1">
					<div class="success">
						Evaluation updated successfully.
					</div>
				</cfcase>
				<cfcase value="2">
					<div class="error">
						Evaluation update cancelled.
					</div>
				</cfcase>
			<cfdefaultcase>
			
			</cfdefaultcase>
			</cfswitch>
		</cfif>

	<h3>(#getGame.game_code#) #getGame.home_teamname# VS #getGame.visitor_teamname# on #dateformat(getGame.game_datetime, "m/d/yyyy")# #timeformat(getGame.game_datetime,"h:mm tt")#</h3>
	<h3>Field: #getGame.field#</h3>
	<h3>
		Score:<br>
		#getGame.home_teamname#: #getGame.score_home#<br>
		#getGame.visitor_teamname#: #getGame.score_visitor#
	</h3>
	<br>
	<h3>This form has been filled out by the <u><i>#iif("#getGame.team_id EQ getGame.home_team_id#","#de("Home")#","#de("Visitor")#")#</i></u> team.</h3>
	



	<cfset label_vars=structnew()>
	<cfset label_vars.game_id="#getGame.game_id#">
	<cfset label_vars.team_id="#getGame.team_id#">
	<cfset label_vars.ref_name="#getGame.refname#">
	<cfset label_vars.asst1ref_name="#getGame.asst1name#">
	<cfset label_vars.asst2ref_name="#getGame.asst2name#">
	<div id="response_options">
	<cfif Session.MenuRoleID EQ 1>
		<input type="button" name="btnEdit" id="btnEdit" value="Edit" />
		<input type="button" name="btnDelete" id="btnDelete" value="Delete" />
	</cfif>
	</div>
	<cfmodule template="forms/viewFormResponse.cfm"
		response_id="#response_id#" 
		label_vars="#label_vars#">

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

