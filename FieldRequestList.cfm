<!--- 
	FileName:	FieldRequestList.cfm 
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

<CFIF isDefined("URL.CLUB") AND isNumeric(URL.CLUB)>
	<CFSET clubID = URL.CLUBID>
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

<H1 class="pageheading">NCSA - Requested Field List</H1>

<!--- <CFIF clubID GT 0>
	<!--- a club user is logged in --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubInfo" returnvariable="qClubinfo">
		<cfinvokeargument name="clubID" value="#VARIABLES.clubID#">
	</cfinvoke>
	<h2> for #qClubinfo.club_name# </h2>

	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getFields" returnvariable="qFields">
		<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
		<cfinvokeargument name="orderBy" value="NAME"><!--- ABBRV --->
	</cfinvoke>  
	
<CFELSE>	 
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getAllFields" returnvariable="qFields">
		<cfinvokeargument name="orderBy" value="NAME"><!--- ABBRV --->
	</cfinvoke>  
 </CFIF> --->

<!--- get Requested fields --->	
<cfinvoke component="#SESSION.SITEVARS.cfcPath#field" method="getRequestedFields" returnvariable="qFieldsRequested">
	<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
	<cfinvokeargument name="orderBy" value="CLUBABBR"><!--- ABBRV --->
</cfinvoke>  

<!--- get Requested fields 
<cfquery name="qFieldsRequested" dbtype="query">
	SELECT * FROM qFields WHERE REQUEST_YN = 'Y'
</cfquery>--->
 
<table cellspacing="0" cellpadding="3" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<td width="15%"> Club </td>
		<td width="05%"> ID </td>
		<td width="18%"> Abbreviation </td>
		<td width="33%"> Field Name	</td>
		<td width="21%"> City </td>
		<td width="08%"> Status </td>
	</tr>
</table>	
<!--- FIELD_ID, FIELDABBR, FIELDNAME, FIELDSIZE, FIELDSIZECOMMENT, ADDRESS, CITY, STATE, ZIPCODE, DIRECTIONS,
      Day1, Day1TimeFrom, day1TimeTo, day1comment, Day2, Day2TimeFrom, day2TimeTo, day2comment, exceptions, Active_YN --->
<div style="overflow:auto; height:375px; border:1px ##cccccc solid;">
<table cellspacing="0" cellpadding="3" align="left" border="0" width="98%">
	<CFLOOP query="qFieldsRequested">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#"> 
			<TD width="16%" class="tdUnderLine"> #CLUBABBR#
			</td>
			<TD width="05%" class="tdUnderLine" valign="middle"> 
				<A href="fieldDirectionsEdit.cfm?fid=#Field_ID#&m=approve">#Field_ID#</A>
			</TD>
			<TD width="20%" class="tdUnderLine"> 
				<CFIF len(trim(FIELDABBR))>#FIELDABBR#<cfelse>no abbr.</CFIF>			
			</TD>
			<TD width="36%" class="tdUnderLine"> 
				<A href="fieldDirectionsEdit.cfm?fid=#Field_ID#&m=approve">#FieldNAME#</A>			
			</TD>
			<TD width="26%" class="tdUnderLine"> 
				#CITY#			
			</td>
			<TD width="17%" class="tdUnderLine" > 
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
    <tr><td colspan="6" align="center"> &nbsp; </td>
    </tr>
</table>	
</div> 

<hr size="1">
	
</cfoutput>
</div>
<cfinclude template="_footer.cfm">
