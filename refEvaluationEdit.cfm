<!--- 
	FileName:	refEvaluation.cfm
	Created on: 2/23/2011
	Created by: bcooper@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 <cfsetting showdebugoutput="No">
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>


<CFIF isDefined("FORM.team_id")>
	<CFSET team_id = FORM.team_id>
<cfelseif isdefined("url.team_id")>
	<cfset team_id=url.team_id>
<CFELSE>
	<CFSET team_id = "">
</CFIF>

<cfif isdefined("url.game_id")>
	<cfset game_id=url.game_id>
</cfif>

<CFIF isDefined("FORM.response_id")>
	<CFSET response_id = FORM.response_id>
<cfelseif isdefined("url.response_id")>
	<cfset response_id=url.response_id>
<CFELSE>
	<CFSET response_id = "">
</CFIF>

<!---<cfparam name="attributes.response_id" type="numeric">
<cfparam name="attributes.label_vars" type="struct" default="#structnew()#">--->

<!---<cfset label_vars=attributes.label_vars>--->

<!--- get response --->
<cfinvoke
	component="#application.sitevars.cfcpath#.userForm"
	method="getResponse"
	response_id="#response_id#"
	returnvariable="responseInfo">
<cfset user_form_id=responseInfo.user_form_id>

<cfset stResponse=structnew()>
<cfloop query="responseInfo">
	<cfset key="#question_group_form_section_id#-#question_id#-#choice_id#">
	<cfif structkeyexists(stResponse,"#key#")>
		<cfset arrayappend(stResponse["#key#"],value)>
	<cfelse>
		<cfset keyvalue=arraynew(1)>
		<cfset arrayappend(keyvalue,value)>
		<cfset stResponse["#key#"]=keyvalue>
	</cfif>
</cfloop>


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



<div id="contentText">
<H1 class="pageheading">NCSA - Detailed Referee Evaluation</H1>
<br> <!--- <h2>yyyyyy </h2> --->


	<h3>(#getGame.game_id#) #getGame.home_teamname# VS #getGame.visitor_teamname# on #dateformat(getGame.game_datetime, "m/d/yyyy")# #timeformat(getGame.game_datetime,"h:mm tt")#</h3>
	<h3>Field: #getGame.field#</h3>
	<h3>
		Score:<br>
		#getGame.home_teamname#: #getGame.score_home#<br>
		#getGame.visitor_teamname#: #getGame.score_visitor#
	</h3>
	<br>
	<h3>This form is being filled out by the <u><i>#iif("#team_id EQ getGame.home_team_id#","#de("Home")#","#de("Visitor")#")#</i></u> team.</h3>
	
	<cfset label_vars=structnew()>
	<cfset label_vars.game_id="#getGame.game_id#">
	<cfset label_vars.team_id="#getGame.team_id#">
	<cfset label_vars.ref_name="#getGame.refname#">
	<cfset label_vars.asst1ref_name="#getGame.asst1name#">
	<cfset label_vars.asst2ref_name="#getGame.asst2name#">
	
	<cfset team_id = getGame.team_id>


	
	<cfif getGame.asst1name NEQ "">
		<cfmodule template="forms/renderFormEdit.cfm"
			response_id=#response_id#
			user_form_id="1" 
			label_vars=#label_vars#
			stResponse=#stResponse#
			return_page="#Application.sitevars.homehttp#/viewRefEvaluation.cfm?response_id=#response_id#">
	<cfelse>
		<cfmodule template="forms/renderFormEdit.cfm"
			response_id=#response_id#
			user_form_id="3" 
			label_vars=#label_vars#
			stResponse=#stResponse#
			return_page="#Application.sitevars.homehttp#/viewRefEvaluation.cfm?response_id=#response_id#">
	</cfif>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">

