<!--- 
	FileName:	approveReviewField.cfm 
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfoutput>
<div id="contentText">


<CFIF isDefined("URL.CID")>
	<CFSET clubID = URL.CID>
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


<CFIF isDefined("FORM.ADD")>
	<cflocation url="fieldDirectionsEdit.cfm?cid=#VARIABLES.CLUBID#&m=add">
</CFIF>
<CFIF isDefined("FORM.EDIT")> 
	<cflocation url="fieldDirectionsEdit.cfm?cid=#VARIABLES.CLUBID#&fid=#VARIABLES.FieldID#&m=edit"> 
</CFIF>
<CFIF isDefined("FORM.PRINT")>
	<cflocation url="fieldDirections.cfm?rcid=#VARIABLES.CLUBID#">
</CFIF>
<CFIF isDefined("FORM.DELETE")>
	<!--- DELETE - doesn't actually delete, it deactivates it in the xref --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="removeFieldFromClub">
		<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
		<cfinvokeargument name="fieldID" value="#VARIABLES.fieldID#">
	</cfinvoke>
</CFIF>
<CFIF isDefined("FORM.BACK")>
	<cflocation url="ApproveClubNewSeason.cfm?a=f">
</CFIF>





<H1 class="pageheading">NCSA - Registered Field Directions List</H1>
<br>
<CFIF clubID GT 0>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubinfo">
		<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
	</cfinvoke>
	<h2> for #qClubinfo.club_name# </h2>
</CFIF>

<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getRegFields" returnvariable="qRegFields">
	<cfinvokeargument name="clubID"	 value="#VARIABLES.CLUBID#">
	<cfinvokeargument name="orderBy" value="NAME">
</cfinvoke>  


<FORM name="Directions" action="approveReviewField.cfm" method="post">
<input type="hidden" name="ClubID" value="#VARIABLES.ClubId#">


<table cellspacing="0" cellpadding="5" align="left" border="0" width="95%">
	<tr class="tblHeading">
		<td width="0%" > &nbsp; </td>
		<td width="70%"> Field	</td>
		<td width="15%"> &nbsp; </td>
		<td width="15%"> &nbsp; </td>
	</tr>

	<CFLOOP query="qRegFields">
		<!--- DirectionHRef = "App_Directions.asp?ClubId=" & cInt(ClubID) & "&Field=" & server.URLEncode(trim(HRefField)) --->
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
			<TD class="tdUnderLine"> 
				<INPUT type=radio value="#Field_ID#" name="FieldID">
			</TD>
			<TD class="tdUnderLine">
				<A href="fieldDirections.cfm?fid=#Field_ID#">#FieldNAME#</A>
				 
			</TD>
			<TD class="tdUnderLine">
				<span class="red">
					<cfif Approved EQ "N"> 
						&nbsp;
					<cfelse>
						Approved
					</cfif>
				</span>
			</td>
			<TD class="tdUnderLine">
				<span class="red">
					<cfif active_Club_filed_YN EQ "Y">
						&nbsp;
					<cfelse>
						InActive
					</cfif>
				</span>
			</td>
		</tr>
	</CFLOOP>
    <tr><td colspan="4" align="center">
			<br>
			<INPUT type="submit" value="Add"	name="Add"	  >&nbsp;
			<INPUT type="submit" value="Edit"	name="Edit"   >&nbsp;
			<INPUT type="submit" value="Print"	name="Print"  >&nbsp;
			<INPUT type="submit" value="Delete"	name="Delete" >&nbsp;
			<INPUT type="submit" value="Back"   name="Back"   >
        </td>
    </tr>
</table>	
 
</FORM>
	
	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
