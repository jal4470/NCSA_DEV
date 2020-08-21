<!--- 
	FileName:	menu_manage.cfm
	Created on: 10/29/2009
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - Manage Menus</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfquery datasource="#session.dsn#" name="getPublicMenus">
	select a.*, b.menu_id as parent_menu_id, b.menu_name as parent_menu_name 
	from tbl_menu a
	left join tbl_menu b
	on a.parent_menu_id=b.menu_id
	where a.isPublic=1
	and a.location_id in (1,4) --don't know what this is
	order by isnull(b.seq, a.seq), a.parent_menu_id, a.seq
</cfquery>
<cfinvoke
	component="#session.sitevars.cfcpath#.menu"
	method="getAllPrivateMenus"
	returnvariable="getPrivateMenus">
	
<cfinvoke component="#SESSION.sitevars.cfcPath#Menu" method="getPublicMenu" returnvariable="getFooterMenus">
	<cfinvokeargument name="DSN" value="#Application.DSN#">
	<cfinvokeargument name="location" value="3">
	<cfinvokeargument name="swGetChild" value="0">
</cfinvoke>

<!--- find super user role in logged in user's role list --->
<cfif structkeyexists(session.user.strole,"61")>
	<cfset su=true>
<cfelse>
	<cfset su=false>
</cfif>

<h2>Public Menu
<div style="float:right;">
	<a href="menu_add.cfm?public=1">Add</a> | <a href="menu_sequence.cfm?public=1">Sequence</a>
</div>
</h2>
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD>&nbsp;</TD>
		<TD>Name</TD>
		<TD>Parent</TD>
		<TD>Location</TD>
	</tr>
	<CFLOOP query="getPublicMenus">
		<cfset actionArr=arraynew(1)>
		<cfif su OR userDefined>
			<cfset arrayappend(actionArr,"<a href=""menu_edit.cfm?menu_id=#menu_id#"">Edit</a>")>
			<cfset arrayappend(actionArr,"<a href=""menu_delete.cfm?menu_id=#menu_id#"" onclick=""return confirm('Are you sure you want to remove this menu item?');"">Delete</a>")>
		</cfif>
		<tr>
			<TD align="center" class="tdUnderLine" style="white-space:nowrap;">
				#arraytolist(actionArr," | ")#
			</TD>
			<TD class="tdUnderLine" align="left" <cfif parent_menu_id EQ "">style="font-weight:bold;"</cfif>> #menu_name# </TD>
			<TD class="tdUnderLine" align="left"> #parent_menu_name#&nbsp; </TD>
			<td class="tdUnderLine" align="left">#locator#&nbsp;</td>
		</tr>
	</CFLOOP>
</table>


<h2 style="margin-top:50px;">Footer Menu
<div style="float:right;">
	<a href="menu_add.cfm?public=2">Add</a> | <a href="menu_sequence.cfm?public=2">Sequence</a>
</div>
</h2>
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD>&nbsp;</TD>
		<TD>Name</TD>
		<TD>Location</TD>
	</tr>
	<CFLOOP query="getFooterMenus">
		<cfset actionArr=arraynew(1)>
		<cfif su OR userDefined EQ "1">
			<cfset arrayappend(actionArr,"<a href=""menu_edit.cfm?menu_id=#menu_id#"">Edit</a>")>
			<cfset arrayappend(actionArr,"<a href=""menu_delete.cfm?menu_id=#menu_id#"" onclick=""return confirm('Are you sure you want to remove this menu item?');"">Delete</a>")>
		</cfif>
		<tr>
			<TD align="center" class="tdUnderLine" style="white-space:nowrap;">
				#arraytolist(actionArr," | ")#
			</TD>
			<TD class="tdUnderLine" align="left" <cfif parent_menu_id EQ "">style="font-weight:bold;"</cfif>> #menu_name# </TD>
			<td class="tdUnderLine" align="left">#locator#&nbsp;</td>
		</tr>
	</CFLOOP>
</table>


<h2 style="margin-top:50px;">Private Menu
<div style="float:right;">
	<a href="menu_add.cfm?public=0">Add</a> | <a href="menu_sequence_private.cfm">Sequence</a>
</div>
</h2>
<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
	<tr class="tblHeading">
		<TD>&nbsp;</TD>
		<TD>Name</TD>
		<TD>Parent</TD>
		<TD>Location</TD>
	</tr>
	<CFLOOP query="getPrivateMenus">
		<cfset actionArr=arraynew(1)>
		<cfif su OR userDefined EQ "1">
			<cfset arrayappend(actionArr,"<a href=""menu_edit.cfm?menu_id=#menu_id#"">Edit</a>")>
			<cfset arrayappend(actionArr,"<a href=""menu_delete.cfm?menu_id=#menu_id#"" onclick=""return confirm('Are you sure you want to remove this menu item?');"">Delete</a>")>
		</cfif>
		<cfif parent_menu_id NEQ "">
			<cfset arrayappend(actionArr,"<a href=""menu_role_manage.cfm?menu_id=#menu_id#"">Roles</a>")>
		</cfif>
		<tr>
			<TD align="left" class="tdUnderLine" style="white-space:nowrap;">
				#arraytolist(actionArr," | ")#
			</TD>
			<TD class="tdUnderLine" align="left" <cfif parent_menu_id EQ "">style="font-weight:bold;"</cfif>> #menu_name# </TD>
			<TD class="tdUnderLine" align="left"> #parent_menu_name#&nbsp; </TD>
			<td class="tdUnderLine" align="left"><cfif parent_menu_id NEQ "">#locator#</cfif>&nbsp;</td>
		</tr>
	</CFLOOP>
</table>


</cfoutput>
</div>
<cfinclude template="_footer.cfm"> 
