 <cfcontent type="application/vnd.ms-excel"> 
<cfif isdefined("url.message_id")>
	<cfset message_id = url.message_id>
</cfif>

<cfquery name="getBounces" datasource="#application.dsn#">
select m.message_desc as Message, convert(varchar,isnull(m.sent_date,m.datecreated),100) as [Sent_Date],mr.email,c.contact_id ,c.username,c.firstname + ' ' + c.lastname as [User_Name], cl.club_name as [Club_Name]
from 
	tbl_message m 
		inner join tbl_message_recipient mr on m.message_id = mr.message_id 
		inner join tbl_contact c on c.contact_id = mr.contact_id 
		inner join tbl_club cl on cl.club_id = c.club_id
where m.message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#message_id#">
and mr.bounced = 1
</cfquery>

<cfset col_out = ArrayToList(getBounces.getColumnList())>
<cfoutput>
<table border="1">
<tr><th align="center" colspan="#listLen(col_out)#">Bounced Email Report for Message ID #Message_id#</th></tr>
<tr>
<cfloop list="#col_out#" index="i">
	<th>#i#</th>
</cfloop>
</tr>

<cfloop query="getBounces">
	<cfset ct = 1>
	<cfset row_out = "">
	<tr>
	<cfloop list="#col_out#" index="i">
			<td>#evaluate(i)#</td>
	</cfloop>
	</tr>
</cfloop>
</table></cfoutput>