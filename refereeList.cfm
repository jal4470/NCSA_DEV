<!--- 
	FileName:	refereeList.cfm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
01/13/09 - AA - changed to use reg season when active else current (was doing it but in wrong place

 --->
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Referee List </H1> <!--- <br>  <h2>yyyyyy </h2> --->

<cfset ReturnPage = "">	
<cfset LastStateRegisteredIn = "X">

<CFIF isDefined("SESSION.REGSEASON")>
	<cfset useSeasonID = SESSION.REGSEASON.ID>
<CFELSE>
	<cfset useSeasonID = SESSION.CURRENTSEASON.ID>
</CFIF>

<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getReferees" returnvariable="qGetRefs">
	<cfinvokeargument name="sortby" value="STATE">
</cfinvoke>

<cfif SESSION.MENUROLEID EQ 25> <!--- 25=referee --->
	<!--- for refs, only show NJ/NY, omit unassigned --->
	<cfquery name="qGetRefs" dbtype="query">
		SELECT * FROM qGetRefs WHERE StateRegisteredIn IS NOT NULL 
		order by certified_yn desc
	</cfquery>
	
<cfelse>
	<!--- <cfset useSeasonID = SESSION.CURRENTSEASON.ID>
	<CFIF isDefined("SESSION.REGSEASON")>
		<cfset useSeasonID = SESSION.REGSEASON.ID>
	</CFIF> --->
	<!--- get any Newly Requested REFS --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#CONTACT" method="getRequestedReferees" returnvariable="qReqRefInfo">
		<cfinvokeargument name="seasonID" value="#VARIABLES.useSeasonID#">
	</cfinvoke>
</cfif>



<cfif SESSION.MENUROLEID NEQ 25 and qReqRefInfo.recordcount> <!--- 25=referee --->
	<table cellspacing="0" cellpadding="2" align="center" border="0" width="825px" >
	<tr><td colspan="6" align="middle">
			<span class="red">Click on a referee's name to Edit.</span>
			<br>
		</td>
	</tr>
	<tr class="tblHeading">
		<td colspan=6> Requested Referees waiting for logins.</td>
	</tr>
	</table>

	<div style="overflow:auto; height:100px; border:1px ##cccccc solid;"> 
	<table cellspacing="0" cellpadding="2" align="left" border="0" width="800px" >
		<CFLOOP query="qReqRefInfo">
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<TD width="20%" class="tdUnderLine" align=Left>
				<cfif SESSION.MENUROLEID EQ 25> <!--- 25=referee --->
					&nbsp;#LastName#, #FirstName#
				<cfelse>
					<!--- <a href="contactEdit.cfm?c=#contact_ID#&cid=1">#LastName#, #FirstName#	</a> --->
					<a href="refereemaintain.cfm?rfid=#contact_id#">#LastName#, #FirstName#	</a>
				</cfif>
			</td>
			<TD width="20%" class="tdUnderLine" align=Left> 
				<cfif SESSION.MENUROLEID NEQ 25> <!--- 25=referee ---> 
					#USERNAME# &nbsp;
				<cfelse>
					&nbsp;
				</cfif>	
			</td>
			<TD width="15%" class="tdUnderLine" align=Left>   (c) #phoneCell# <br>(h) #phoneHome#	</td>
			<TD width="10%" class="tdUnderLine" align=center> #StateRegisteredIn#		&nbsp;</td>
			<TD width="28%" class="tdUnderLine" align=Left>   #Email#					&nbsp;</td>
			<TD				class="tdUnderLine" align=Left>   
								<cfif certified_yn EQ "Y" >
									<span class="green"><b>Yes</b></span>&nbsp;
								<cfelse>
									<span class="red">No</span>&nbsp;
								</cfif>
			</td>
		</tr>
	</CFLOOP>
	</table>
	</div>

</cfif>




<table cellspacing="0" cellpadding="2" align="center" border="0" width="825px" >
	<cfif SESSION.MENUROLEID NEQ 25> <!--- 25=referee --->
		<tr><td colspan=6>
				<SPAN class="red">
					Referees are group by the state they registered in. 
					<br> 
					Ceritified Referees will appear in dropdown lists.
				</SPAN>
			</td>
		</tr>
	</cfif>
	<tr class="tblHeading">			<!--- <td width="03%">&nbsp;</td> --->
		<td width="19%" align=Left> Referee		</td>
		<td width="9%" align=Left> Avail	</td>
		<td width="18%" align=Left> UserID		</td>
		<td width="13%" align=Left> Phone##s	</td>
		<td width="10%" align=Left> State 		</td>
		<td width="21%" align=Left> EMail		</td>
		<td width="10%" align=Left> Certified	</td>
	</tr>
</table>
 
<div style="overflow:auto; height:350px; border:1px ##cccccc solid;"> 
<table cellspacing="0" cellpadding="3" border="0" width="800px" align="left" >
	<CFLOOP query="qGetRefs">
		<cfset StateName			= "" >
		<cfif trim(LastStateRegisteredIn) NEQ trim(StateRegisteredIn)>
			<CFIF StateRegisteredIn EQ "NJ" and certified_yn eq 'Y'>
				<CFSET StateName = "New Jersey">
			<CFELSEIF StateRegisteredIn EQ "NY" and certified_yn eq 'Y'>
				<CFSET StateName = "New York">
			<CFELSEIF len(trim(StateRegisteredIn)) and certified_yn eq 'Y'>
				<CFSET StateName = StateRegisteredIn>
			<CFELSE>
				<CFSET StateName = "Not Registered in a State">
			</CFIF>
			<cfset LastStateRegisteredIn = StateRegisteredIn >
			<tr class="tblHeading">
				<td colspan=7> #StateName# </td>
			</tr>
		</cfif>
		<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
			<!--- <TD width="02%" class="tdUnderLine"><INPUT type=radio value="#RefereeId#" name="RefereeId" onclick="EditRec()">	</TD> --->
			<TD width="20%" class="tdUnderLine" align=Left>
				<cfif SESSION.MENUROLEID EQ 25> <!--- 25=referee --->
					#LastName#, #FirstName#
				<cfelse>
					<a href="refereeMaintain.cfm?rfid=#contact_id#">#LastName#, #FirstName#	</a>
				</cfif>
			</td>
			<td width="9%" class="tdUnderLine"><a href="ref_avail.cfm?cid=#contact_id#" title="Edit Availability"><img src="assets/images/calendar.gif" border="0"></a></td>
			<TD width="20%" class="tdUnderLine" align=Left> 
				&nbsp;
				<cfif SESSION.MENUROLEID NEQ 25> <!--- 25=referee ---> 
					#USERNAME#
				</cfif>	
			</td>
			<TD width="15%" class="tdUnderLine" align=Left> (c) #phoneCell# <br>(h) #phoneHome#	</td>
			<TD width="10%" class="tdUnderLine" align=center> #StateRegisteredIn#		&nbsp;</td>
			<TD width="28%" class="tdUnderLine" align=Left> #Email#					&nbsp;</td>
			<TD				class="tdUnderLine" align=Left>
								<cfif certified_yn EQ "Y" >
									<span class="green"><b>Yes</b></span>&nbsp;
								<cfelse>
									<span class="red">No</span>&nbsp;
								</cfif>
			</td>
		</tr>
	</CFLOOP>
</TABLE>
</div>


</div>
</cfoutput>
<cfinclude template="_footer.cfm">
