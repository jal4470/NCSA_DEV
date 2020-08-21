<!--- Author: Joe Lechuga 5-4-2010 
      Purpose: To Select or add new seeds to a given campaign --->

<cfmodule template="../_checkLogin.cfm">
 
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
</cflock>
<cfif isdefined("form.message_id")>
	<cfset message_id  = form.message_id>
<cfelseif isdefined("url.message_id")>
	<cfset message_id = url.message_id>
<cfelse>
	<CF_ERROR error="Message is not defined.">
</CFIF>

<cfquery name="getRecipientCnt" datasource="#dsn#">
select count(*) as recipient_cnt 
from tbl_message_recipient 
where message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#message_id#">
and seed_flag <> 1

</cfquery>
<cfquery name="getRecipientSeedCnt" datasource="#dsn#">
select count(*) as recipient_seed_cnt 
from tbl_message_recipient 
where message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#message_id#">
and seed_flag = 1

</cfquery>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<link rel="stylesheet" type="text/css" href="style.css" media="print,screen">
 	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet" > 
	<link  href="../ReportBuilder/_rptBldr_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<title>Step 5</title>
	<script language="javascript">
	function setTextBoxValue(textBox, SetElement)
	{
		var list = document.getElementById(SetElement);
		document.getElementById(textBox).value = "";
		var listAgr;
		for(var i = 0; i < list.options.length; ++i)
		{
			if (list.options[i].selected == true)
			{
				if(i == 0){
					//alert(list.options[i].value);
				   listAgr = list.options[i].value;
			     }else{
						listAgr = list.options[i].value + "," + listAgr;}
			}
		}
		document.getElementById(textBox).value = listAgr;
	}
	</script>	
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">
<cfhtmlhead text="<title>Message Manager Step 4</title>">
<CFINCLUDE TEMPLATE="assets/js/tooltip.js">

<!--- Header --->
<CFINCLUDE TEMPLATE="header_nltr.cfm">

<!--- BODY --->
<cfset stepnum=5>
<cfinclude template="tpl_rptBldr_head.cfm">

<form method="post" action="Step4_SendMessage.cfm">
<table border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td colspan="3">Message will be sent to 
		<cfif isdefined("getRecipientSeedCnt") and getRecipientSeedCnt.recipient_seed_cnt gt 0>
		<cfoutput>#getRecipientSeedCnt.recipient_seed_cnt#</cfoutput> seed(s) and
		</cfif>
		<cfoutput>#getRecipientCnt.recipient_cnt#</cfoutput> recipients within the next 10 minutes.<input type="submit" value="Launch Now!" class="itemformbuttonleft">
		</td>
	</tr>
	<cfoutput><input type="hidden" name="message_id" value="#message_id#"></cfoutput>
</form>

<cfinclude template="inc_seed_recipient.cfm">
		<tr><td colspan="3"><hr></td></tr>
		<tr>
			<td colspan="3">Or Add a New Seed</td>
		</tr>						
	<cfif isdefined('url.error') and len(trim(url.error))>
		<tr>
			<td colspan="3">
				<cfoutput>#urldecode(url.error)#</cfoutput>
			</td>
		</tr>
	</cfif>
	<form method="post" action="AddSeedAction.cfm">
		<tr>
			<td colspan="5">seed name: <input type="text" name="SeedName"> seed email:<input type="text" name="SeedEmail"> seed group:
							<select name="SeedGroup">
							<cfoutput query="SeedGroups">
								<option value="#seed_group_id#"> #seed_group_name# [#seed_group_description#]</option>
							</cfoutput>
							</select>
							<input type="Submit" name="Add" value="Add" class="itemformbuttonleft">
							<input type="hidden" name="UrlLocation" value="Step4_DefineLaunchSeeds.cfm">
					<cfoutput>			
							<input type="hidden" name="message_id" value="#message_id#">
				  			<input type="hidden" name="seedList" id="seedList" value="#seedList#">
							<input type="hidden" name="seedGroupList" id="seedGroupList" value="#seedGroupList#">
					</cfoutput>
			</td>
		</tr>
				
	</form>						
						
</table>
<cfinclude template="tpl_rptBldr_foot.cfm">
</body>
</html
