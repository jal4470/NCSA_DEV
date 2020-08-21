<!--- 
	FileName:	fields.cfm
	Created on: 08/12/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: used to display a list of all fields
	
MODS: mm/dd/yyyy - flastname - comments
	12/30/08 - aa -  supress club 1
 --->
<CFIF isDefined("URL.MID")>
	<CFSET mid = URL.MID>
<CFELSE>	
	<cfset mid = 2>
</CFIF>
<cfinclude template="_header.cfm">

<cfoutput>

<div id="contentText">
<H1 class="pageheading">	NCSA - Field List </H1>
<!--- <br><H2>Select a club and click Enter to see the club's teams.</H2> --->



<CFIF isDefined("URL.ALL")>
	<CFSET swAllclubs = 1>
	<CFSET clubID = 0>
<CFELSE>
	<CFSET swAllclubs = 0>
	<CFIF isDefined("FORM.clubID")>
		<CFSET clubID = FORM.clubid>
	<CFELSE>
		<CFSET clubID = 0>
	</CFIF>
	
	<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="clubInfo">
		<cfinvokeargument name="DSN"     value="#SESSION.DSN#">
		<cfinvokeargument name="orderby" value="clubname">
	</cfinvoke>  <!--- <cfdump var="#clubInfo#"> --->
		
	<FORM action="fields.cfm" method="post">
		<select name="clubid">
			<option value="0">Select a Club...</option>
			<CFLOOP query="clubInfo">
				<cfif CLUB_ID NEQ 1> <!--- supress club 1 --->
					<option value="#CLUB_ID#" <cfif variables.clubid EQ CLUB_ID>selected</cfif> >#CLUB_NAME#</option>
				</cfif>
			</CFLOOP>
		</select> 
		<input type="Submit" name="getTeams" value="Enter">
	
	</FORM>
</CFIF>

<!--- <CFIF VARIABLES.clubid GT 0> --->
<CFIF VARIABLES.clubid GT 0 OR swALLclubs EQ 1> 

	<cfif swALLclubs>
		<cfinvoke component="#SESSION.sitevars.cfcPath#field" method="getFields" returnvariable="qfieldList">
			<cfinvokeargument name="orderby" value="name">
		</cfinvoke>  <!--- <cfdump var="#fieldInfo#"> --->
	<CFELSE>
		<cfinvoke component="#SESSION.sitevars.cfcPath#field" method="getFields" returnvariable="qfieldList">
			<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
			<cfinvokeargument name="orderby" value="abbrv">
		</cfinvoke>  <!--- <cfdump var="#fieldInfo#"> --->
	</cfif>
	
	<h3>Click on a field to view the directions</h3>       
	<table width="100%" cellspacing="0" cellpadding="5" align="center" border="0">
		<tr class="tblHeading">
			<td width="30%"> Name 		 </td>
			<td width="20%"> Abbreviation </td>
			<td width="25%"> Club 		 </td>
			<td width="25%"> Town 		 </td>
		</tr>
		<cfset ctLoop = 1>
	</table>
	<div style="overflow:auto; height:350px; border:1px ##cccccc solid;">
	<table width="100%" cellspacing="0" cellpadding="5" align="center" border="0">
		<CFLOOP query="qfieldList">
			<CFIF len(trim(FIELDABBR))> <!--- if Abbreviation is blank, don't show --->
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,VARIABLES.ctLoop)#">
					<td width="30%" valign="top" class="tdUnderLine">
						<a href="fieldDirections.cfm?fid=#FIELD_ID#">#FIELDNAME#</a> &nbsp;
					</td>
					<td width="20%" valign="top" class="tdUnderLine">
						<a href="fieldDirections.cfm?fid=#FIELD_ID#">#FIELDABBR#</a>&nbsp;
					</TD>
					<td width="25%" valign="top" class="tdUnderLine">
						#CLUB_NAME#&nbsp;
					</TD>
					<td width="25%" valign="top" class="tdUnderLine">
						#CITY# &nbsp;
					</td>
				</TR>
				<cfset ctLoop = ctLoop + 1>
			</CFIF>
		</CFLOOP>
	</table>
	</DIV>
</CFIF>

</div>

</cfoutput>
<cfinclude template="_footer.cfm">

