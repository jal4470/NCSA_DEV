<cfsilent>
<cfset tickerMsg_id = "">
<cfset msgDate = dateformat(now(),'mm/dd/yyyy')>
<cfset msgTime = timeformat(now(),'hh:mm:sstt')>
<cfset message = "">
<cfset msgLink = "">	
<cfset mode = "add">
	<cfif isdefined('url.tmid')>
	<cfquery datasource="#application.dsn#" name="getTicker">
		select TickerMsg_ID, msgDate,msgTime,message,msgLink
		from tbl_tickerMsg
		where tickerMsg_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#tmid#">
	</cfquery>
	<cfset tickerMsg_id = getTicker.tickerMsg_id>
	<cfset msgDate = getTicker.msgDate>
	<cfset msgTime = getTicker.msgTime>
	<cfset message = getTicker.message>
	<cfset msgLink = getTicker.msgLink>	
	<cfset mode="update">
	</cfif>
</cfsilent>
<cfoutput>
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<script language="javascript" type="text/javascript">
function validateform(aForm)
{
	
	if ( ! aForm.Description.value.length )
	{
		alert("Message required")
		return false
	}


	return true
}
</script>
<br>
<h2 align="center">
		    #ucase(mode)# Ticker Message
</h2>

<FORM action="Ticker_message_action.cfm" name="theForm" onSubmit="return validateform(this)" method="post"> 
<INPUT type="hidden" name="Mode"		 value="#mode#">
<INPUT type="hidden" name="TickerMsg_id"		 value="#TickerMsg_id#">

<div align="center">
	<center>
		<div id="error" align="center"  style="DISPLAY: none">
			<font size=2 color="red">
				Fields marked with * are required
			</font>
		</div>

		<TABLE cellSpacing=10 cellPadding=1 width="75%" border="0" style="LEFT: 120px; TOP: 147px">
			<!--- <TR>
				<TD width="20%" align="right">
						Ticker Date

				</TD>
				<TD>

					<INPUT style="WIDTH: 90px; HEIGHT: 25px" size="9" name="EventDate" value="#msgDate#" readonly 
						onclick="javascript:show_calendar('EventMaintain.EventDate');"> &nbsp;
						<a href="javascript:show_calendar('EventMaintain.EventDate');" 
							onmouseover="window.status='Date Picker';return true;" 
							onmouseout="window.status='';return true;"> mmddyy</a>
				</TD>
			</TR>
			<TR>
				<TD width="20%" align="right">

						Time

				</TD>
				<TD>
					<INPUT style="WIDTH: 90px; HEIGHT: 25px" size="7" name="EventTime" value="#msgTime#"> &nbsp; hh:mm (AM/PM)
				</TD>
			</TR>
			<TR>

				<TD width="20%" align="right">
					<FONT color=blue>
						<FONT color=#ff0000>*</FONT>
						Event type
					</FONT> 
				</TD>

				<TD>
					<input type="Radio" maxlength="1" name="Type" value="F" > News Flash
					<input type="Radio" maxlength="1" name="Type" value="T" checked> Ticker Message
					<input type="Radio" maxlength="1" name="Type" value="C" > Calendar Event
					<input type="Radio" maxlength="1" name="Type" value="B" > Both
				</TD>

			</TR>
			<TR>
				<TD width="20%" align="right">
					Location
				</TD>
				<TD>
					<INPUT style="WIDTH: 300px; HEIGHT: 25px"  name="Location" value= "##">
					(for Calendar and both)

				</TD>
			</TR> --->
			<TR>
				<TD width="20%" align="right">
						Description/Msg
				</TD>

				<TD>
					<FONT color=maroon>
						<TEXTAREA name="Description" rows=10  cols=50>#message#</TEXTAREA>
					</FONT>
				</TD>
			</TR>
  <TR align="center">
    <TD colspan="4">
		<input type="hidden" name="msgDate" value="#msgDate#">
		<input type="hidden" name="msgTime" value="#msgTime#">
		<INPUT type="submit" value="Save" >
	</TD>
  </TR>
		</TABLE>
	</center>

</div>


</FORM>

<cfinclude template="_footer.cfm"></cfoutput>