<cfoutput>	

<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
	<cfquery datasource="#application.dsn#" name="getTicker">
		select TickerMsg_ID, msgDate,msgTime,message,msgLink
		from tbl_tickerMsg
		order by msgDate desc, msgTime asc
	</cfquery>

	<h2 align="center">Ticker Message List</h2><br>
	<table border="0" cellpadding="2" width="100%" cellspacing="0" bordercolor="##fbfbfb">
		<tr><td colspan="4"><a href="ticker_edit.cfm">Add New</a></td></tr>
		<cfif getTicker.recordcount>
		<tr class="tblHeading"><th>&nbsp;</th><th>Message Date</th><th>Message Time</th><th>Message</th></tr>
		<cfloop query="getTicker">
			<tr #iif(getTicker.currentrow mod 2 eq 0, de('bgcolor=####FBFBFB'), de('bgcolor=FFFFFF'))#><td><a href="ticker_edit.cfm?tmid=#TickerMsg_ID#">Edit</a>|<a href="javascript:if(confirm ('are you sure?')){ window.location = 'ticker_message_action.cfm?tmid=#TickerMsg_id#&del=1' }" >Delete</a></td><td>#dateformat(msgDate,"mm-dd-yyyy")#</td><td>#timeformat(msgTime,'h:mmtt')#</td><td>#message#</td></tr>
		</cfloop>
		<cfelse>
			<tr><td colspan="4">No messages currently defined</td></tr>
		</cfif>
	</table>	

<cfinclude template="_footer.cfm">
</cfoutput>