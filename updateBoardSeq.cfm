<cfsetting showdebugoutput="false">
<cfinclude template="_checkLogin.cfm">
<cftry>

	<cfloop from="1" to="#FORM.MemberCount#" index="iPos">
		<cfset boardmember_id = listGetAt(form['boardmember_id_array'],iPos)>
		<cfquery name="qUpdateSeq" datasource="#SESSION.DSN#">
			UPDATE TBL_BOARDMEMBER_INFO
				SET SEQUENCE = #iPos#
				WHERE BOARDMEMBER_ID = #VARIABLES.boardmember_id#
		</cfquery>
	</cfloop>

{"status":"succes"}
<cfcatch>{"status":"succes"}</cfcatch>
</cftry>