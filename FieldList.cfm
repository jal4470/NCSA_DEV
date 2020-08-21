<!--- 
	FileName:	FieldList.cfm 
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
	01/06/09 - AA - added link to availability
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">

<CFIF isDefined("URL.CLUB")>
	<CFSET clubID = SESSION.USER.CLUBID>
<CFELSEif isDefined("FORM.CLUBID")>
	<CFSET clubID = FORM.CLUBID>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>

<CFIF isDefined("FORM.FieldID")>
	<CFSET FieldID = FORM.FieldID>
<CFELSE>
	<CFSET FieldID = 0>
</CFIF>

<CFIF isDefined("FORM.AddField")>
	<cflocation url="fieldDirectionsAdd.cfm?cid=#VARIABLES.CLUBID#&m=add">
</CFIF>

<!--- 
<CFIF isDefined("FORM.EDIT")> 	<cflocation url="fieldDirectionsEdit.cfm?cid=#VARIABLES.CLUBID#&fid=#VARIABLES.FieldID#&m=edit"> 
</CFIF>
<CFIF isDefined("FORM.PRINT")>	<cflocation url="fieldDirections.cfm?rcid=#VARIABLES.CLUBID#">
</CFIF>
<CFIF isDefined("FORM.DELETE")>
	<!--- DELETE - doesn't actually delete, it deactivates it in the xref --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="removeFieldFromClub">
		<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
		<cfinvokeargument name="fieldID" value="#VARIABLES.fieldID#">
	</cfinvoke>
</CFIF>
<CFIF isDefined("FORM.BACK")>	<cflocation url="ApproveClubNewSeason.cfm">
</CFIF>
 --->

<H1 class="pageheading">NCSA - Field List</H1>
<CFIF clubID GT 0> <!--- a club user is logged in --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubinfo">
		<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
	</cfinvoke>
	<h2> for #qClubinfo.club_name# </h2>
	<!--- get Approved fields --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getFields" returnvariable="qFieldsApproved">
		<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
		<cfinvokeargument name="orderBy" value="NAME"><!--- ABBRV --->
	</cfinvoke>  
	<!--- get Requested fields --->	
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getRequestedFields" returnvariable="qFieldsRequested">
		<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
		<cfinvokeargument name="orderBy" value="NAME"><!--- ABBRV --->
	</cfinvoke>  
<CFELSE>	
	<!--- get Approved fields --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAllFields" returnvariable="qFieldsApproved">
		<cfinvokeargument name="orderBy" value="NAME"><!--- ABBRV --->
	</cfinvoke>  
	<!--- get Requested fields --->	
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getRequestedFields" returnvariable="qFieldsRequested">
		<cfinvokeargument name="orderBy" value="NAME"><!--- ABBRV --->
	</cfinvoke>  
</CFIF>

<cfif isDefined("qFieldsRequested") AND qFieldsRequested.RECORDCOUNT>
	<cfif qFieldsRequested.RECORDCOUNT GT 4>
		<cfset reqDivHeight = 100>
	<cfelse>
		<cfset reqDivHeight = 25 * qFieldsRequested.RECORDCOUNT > 
	</cfif>
	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<td colspan="8"> Requested Fields </td>
		</tr>
		<tr class="tblHeading">
			<td width="06%"> ID </td>
			<td width="19%"> Abbreviation </td>
			<td width="30%"> Field Name	</td>
			<td width="18%"> City </td>
			<!--- <td width="08%" > Lights </td>
			<td width="09%" > Turf </td>
			<td width="10%" > Status </td> --->
			<td width="07%" > &nbsp; </td>
			<td width="06%" > Lights </td>
			<td width="06%" > Turf </td>
			<td width="08%" > Status </td>
		</tr>
	</table>	
	<div style="overflow:auto; height:#reqDivHeight#px; border:1px ##cccccc solid;">
	<table cellspacing="0" cellpadding="3" align="left" border="0" width="98%">
		<cfif listFindNoCase(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID) EQ 0>
			<!--- admin, board --->
			<cfset urlModVal = "approve">
		<cfelse>
			<!--- club reps --->
			<cfset urlModVal = "edit">
		</cfif>
	
		<CFLOOP query="qFieldsRequested">
			<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
				<TD width="06%" class="tdUnderLine" valign="middle"> 
					<A href="fieldDirectionsEdit.cfm?fid=#Field_ID#&m=#urlModVal#">#Field_ID#</A>
				</TD>
				<TD width="20%" class="tdUnderLine"> 
					<CFIF len(trim(FIELDABBR))>#FIELDABBR#<cfelse>no abbr.</CFIF>			
				</TD>
				<TD width="30%" class="tdUnderLine"> 
					<A href="fieldDirectionsEdit.cfm?fid=#Field_ID#&m=#urlModVal#">#FieldNAME#</A>			
				</TD>
				<TD width="20%" class="tdUnderLine"> 
					#CITY#			
				</td>
				<TD width="08%" class="tdUnderLine"> 
					&nbsp;
				</td>
				<TD width="06%" class="tdUnderLine"> 
					&nbsp; <CFIF LIGHTS_YN EQ "Y">Yes <CFELSEIF LIGHTS_YN EQ "N">No <CFELSE> ? </CFIF>
				</td>
				<TD width="06%" class="tdUnderLine"> 
					&nbsp; <CFIF len(trim(TURF_TYPE))>#TURF_TYPE# <CFELSE> ? </CFIF>
				</td>
				<TD width="06%" class="tdUnderLine" > 
					<cfif APPROVED EQ "N">
						<span class="red">Rejected</span>
					<cfelseif APPROVED EQ "Y">
						<span class="green">Approved</span>
					<cfelse>
						Pending
					</cfif>			
				</td>
			</tr>
		</CFLOOP>
	    <tr><td colspan="4" align="center"> &nbsp; </td>
	    </tr>
	</table>	
	</div> 
</cfif>


<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<td width="06%"> ID </td>
		<td width="19%"> Abbreviation </td>
		<td width="30%"> Field Name	</td>
		<td width="18%"> City </td>
		<td width="07%" > &nbsp; </td>
		<td width="06%" > Lights </td>
		<td width="06%" > Turf </td>
		<td width="08%" > Active </td>
	</tr>
</table>	
<div style="overflow:auto; height:300px; border:1px ##cccccc solid;">
<table cellspacing="0" cellpadding="3" align="left" border="0" width="98%">
	<CFLOOP query="qFieldsApproved">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
			<TD width="06%" class="tdUnderLine" valign="middle"> 
				<A href="fieldDirectionsEdit.cfm?fid=#Field_ID#&m=edit">#Field_ID#</A>
			</TD>
			<TD width="20%" class="tdUnderLine"> 
				<CFIF len(trim(FIELDABBR))>#FIELDABBR#<cfelse>no abbr.</CFIF>			
			</TD>
			<TD width="30%" class="tdUnderLine"> 
				<A href="fieldDirectionsEdit.cfm?fid=#Field_ID#&m=edit">#FieldNAME#</A>			
			</TD>
			<TD width="18%" class="tdUnderLine"> #CITY#			
			</td>
			<TD width="08%" class="tdUnderLine"> 
				&nbsp;<!---  <a href="fieldAvailEdit.cfm?fid=#Field_ID#&sid=#SESSION.CURRENTSEASON.ID#">availability</a>  --->
			</td>
			<TD width="06%" class="tdUnderLine"> 
				&nbsp; <CFIF LIGHTS_YN EQ "Y">Yes <CFELSEIF LIGHTS_YN EQ "N">No <CFELSE> ? </CFIF>
			</td>
			<TD width="06%" class="tdUnderLine"> 
				&nbsp; <CFIF len(trim(TURF_TYPE))>#TURF_TYPE# <CFELSE> ? </CFIF>
			</td>
			<TD width="06%" class="tdUnderLine"> 
				&nbsp; <cfif active_YN EQ "N"><span class="red">InActive</span> <cfelse> <span class="green">Active</span> </cfif>			
			</td>
		</tr>
	</CFLOOP>
    <tr><td colspan="8" align="center"> &nbsp; </td>
    </tr>
</table>	
</div> 


<hr size="1">
<CFIF listFindNoCase(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID) EQ 0>
	<FORM name="AllFields" action="FieldList.cfm" method="post">  
		<input type="Submit" name="AddField" value="Add a Field"> 
	</FORM>
</CFIF>	
	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
