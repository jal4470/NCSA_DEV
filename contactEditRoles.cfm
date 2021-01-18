<!--- 
	FileName:	contactEditRoles.cfm
	Created on: 7/2/2009
	Created by: b. cooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
 <cfset restrictClub=false>
 <cfif isdefined("form.restrictClub")>
 	<cfset restrictClub=true>
 </cfif>
 <cfif isdefined("form.club_id")>
 	<cfset club_id=form.club_id>
<cfelseif isdefined("url.cid")>
	<cfset club_id=url.cid>
	<cfset restrictClub=true>
<cfelse>
	<cfset club_id="">
 </cfif>
 <cfif isdefined("form.contact_id")>
 	<cfset contact_id=form.contact_id>
<cfelseif isdefined("url.contact_id")>
	<cfset contact_id=url.contact_id>
<cfelse>
	<cfset contact_id="">
 </cfif>
 <cfif isdefined("form.season_id")>
 	<cfset season_id=form.season_id>
<cfelse>
	<cfset season_id="">
 </cfif>
 
 <cfif isdefined("form.cancel")>
	<CFIF listFindNoCase(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID)>
		<cflocation url="contactList.cfm">
	<CFELSE>
		<cflocation url="contactList.cfm?cid=#club_id#">
	</CFIF>
 </cfif>
 
 <CFIF listFind(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID) GT 0>
	<!--- we are logged in as "CU" as a CLUB user(rep,alt,pres) 
		  Make the selected club equal to the user's club	--->
	<CFSET club_id = SESSION.USER.CLUBID>
	<cfset restrictClub=true>
</CFIF> 
 
 
 <!--- form submit --->
 <cfif isdefined("form.apply") OR isdefined("form.save")>

 	<cfif isdefined("form.role_id")>
		<cfset role_list=form.role_id>
	<cfelse>
		<cfset role_list="">
	</cfif>
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="setContactRoleList">
		<cfinvokeargument name="assignor_contact_id" value="#session.user.contactid#">
		<cfinvokeargument name="contact_id" value="#contact_id#">
		<cfinvokeargument name="season_id" value="#season_id#">
		<cfinvokeargument name="role_list" value="#role_list#">
	</cfinvoke>
	
	<cfif isdefined("form.save")>
		<!--- redirect to contact list --->
		<CFIF listFindNoCase(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID)>
			<cflocation url="contactList.cfm">
		<CFELSE>
			<cflocation url="contactList.cfm?cid=#club_id#">
		</CFIF>
	</cfif>
 
 </cfif>
 
 
 
 <cfif not restrictClub>
 	<!--- get club list --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#club" method="getClubs" returnvariable="qClubs">
	</cfinvoke>
	
 </cfif>
 
<cfif club_id NEQ "">
	<!--- get club contacts --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getClubContacts" returnvariable="clubContacts">
		<cfinvokeargument name="clubID" value="#club_id#">
	</cfinvoke>
	<cfquery name="clubContacts" dbtype="query">
		select * from clubContacts where active_yn = 'Y'
	</cfquery>
</cfif>
 
<cfif contact_id NEQ "">
	<!--- get seasons --->
	<!--- <cfinvoke component="#SESSION.SITEVARS.cfcPath#season" method="getOpenSeasons" returnvariable="qSeasons">
	</cfinvoke> --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#season" method="getClubOpenSeasons" returnvariable="qSeasons">
		<cfinvokeargument name="club_id" value="#club_id#">
	</cfinvoke>
	<cfif qSeasons.recordcount EQ 1>
		<cfset season_id=qSeasons.season_id>
	</cfif>
</cfif>

<cfif season_id NEQ "">
	<!--- get role list --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getContactRoles" returnvariable="qContactRoles">
		<cfinvokeargument name="contactid" value="#contact_id#">
		<cfinvokeargument name="seasonid" value="#season_id#">
	</cfinvoke>
	
	<cfset lsContactRoles=valuelist(qContactRoles.role_id)>
	
	<!--- get full role list --->
	<cfinvoke component="#SESSION.SITEVARS.cfcPath#contact" method="getAssignableRoleList" returnvariable="qRoles">
		<cfinvokeargument name="contact_id" value="#session.user.contactid#">
	</cfinvoke>
	
</cfif>
 
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<script language="JavaScript" type="text/javascript" src="assets/jquery-1.3.2.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$("select[name=club_id]").change(function(){$("form[name=frmContact]").submit()});
		$("select[name=contact_id]").change(function(){$("form[name=frmContact]").submit()});
		$("select[name=season_id]").change(function(){$("form[name=frmContact]").submit()});
	});
</script>

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Edit Contact Roles</H1>
<br>
<!--- ============================================================================================= --->
<form name="frmContact" action="contactEditRoles.cfm" method="post">
	<!--- <input type="Hidden" name="club_id" value="#club_id#">
	<input type="hidden" name="contact_id" value="#contact_id#">
	<input type="Hidden" name="season_id" value="#season_id#"> --->
	<cfif restrictClub>
		<input type="hidden" name="restrictClub" value="1">
	</cfif>
 
 	<div class="h2">
		Edit Contact Roles
	</div>
	
	<table border="0" cellpadding="0" cellspacing="8">
		<cfif not restrictClub>
			<tr>
				<td>
					Select Club
				</td>
				<td>
					<select name="club_id">
						<option value="">-- Select a Club --</option>
						<cfloop query="qClubs">
							<option value="#club_id#" <cfif qClubs.club_id EQ variables.club_id>selected="selected"</cfif>>#club_name#</option>
						</cfloop>
					</select>
				</td>
			</tr>
		<cfelse>
			<input type="hidden" name="club_id" value="#club_id#">
		</cfif>
		<cfif club_id NEQ "">
			<tr>
				<td>
					Select Contact
				</td>
				<td>
					<select name="contact_id">
						<option value="">-- Select a Contact --</option>
						<cfloop query="clubContacts">
							<option value="#contact_id#" <cfif clubContacts.contact_id EQ variables.contact_id>selected="selected"</cfif>>#lastname#, #firstname#</option>
						</cfloop>
					</select>
				</td>
			</tr>
		</cfif>
		<cfif contact_id NEQ "">
			<tr>
				<td>
					Select Season
				</td>
				<td>
					<cfif qSeasons.recordcount GT 1>
					<select name="season_id">
						<option value="">-- Select a Season --</option>
						<cfloop query="qSeasons">
							<option value="#season_id#" <cfif qSeasons.season_id EQ variables.season_id>selected="selected"</cfif>>#season_sf# #season_year#</option>
						</cfloop>
					</select>
					<cfelse>
						#qSeasons.season_sf# #qSeasons.season_year#
						<input type="hidden" name="season_id" value="#season_id#">
					</cfif>
				</td>
			</tr>
		</cfif>
		
		<cfif season_id NEQ "">
			<tr>
				<td>
					Select Roles
				</td>
				<td>
					<cfloop query="qRoles">
						<input type="Checkbox" name="role_id" value="#role_id#" <cfif listfind(lsContactRoles,role_id)>checked="checked"</cfif>>#roleDisplayName#<br>
					</cfloop>
				</td>
			</tr>
		</cfif>
	</table>
	
	<cfif season_id NEQ "">
		<input type="submit" name="apply" value="Apply">
		<input type="submit" name="save" value="Save">
		<input type="submit" name="cancel" value="Cancel">
	</cfif>
</form>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
