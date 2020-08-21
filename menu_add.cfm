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
<H1 class="pageheading">NCSA - Add Menu</H1>
<br> <!--- <h2>yyyyyy </h2> --->

<cfif isdefined("url.public")>
	<cfset public=url.public>
<cfelse>
	<cfthrow message="public must be defined in url">
</cfif>

<cfif public EQ 1>
	<cfquery datasource="#session.dsn#" name="getParentMenus">
		select menu_id, menu_name
		from tbl_menu
		where ispublic=1
		and location_id in (1,4)
		and parent_menu_id is null
		order by seq
	</cfquery>
<cfelseif public EQ 2>
	<cfinvoke component="#SESSION.sitevars.cfcPath#Menu" method="getPublicMenu" returnvariable="getParentMenus">
		<cfinvokeargument name="DSN" value="#Application.DSN#">
		<cfinvokeargument name="location" value="3">
		<cfinvokeargument name="swGetChild" value="0">
	</cfinvoke>
<cfelse>
	<cfquery datasource="#session.dsn#" name="getParentMenus">
		select menu_id, menu_name
		from tbl_menu
		where ispublic=0
		and parent_menu_id is null
		order by seq
	</cfquery>
</cfif>

<cfif structkeyexists(session.user.strole,"61")>
	<cfset su=true>
<cfelse>
	<cfset su=false>
</cfif>

<form action="menu_add_action.cfm" method="post" enctype="multipart/form-data">
	<input type="Hidden" name="public" value="#public#">
	<table cellspacing="0" cellpadding="5" border="0" width="60%">
		<tr class="tblHeading">
			<TD colspan="2"> &nbsp; </TD>
		</tr>
		<tr><TD width="25%"   align="right"> 
				<b>Menu Name:</b>
			</TD>
			<TD nowrap> 
				<input type="text" name="name" >
			</TD>
		</tr>
		
		<cfif public NEQ 2>
			<tr><TD width="25%"   align="right"> 
					<b>Parent:</b>
				</TD>
				<TD nowrap> 
					<select name="parent_menu_id">
						<cfloop query="getParentMenus">
							<option value="#menu_id#">#menu_name#</option>
						</cfloop>
					</select>
				</TD>
			</tr>
		<cfelse>
			<input type="Hidden" name="parent_menu_id" value="">
		</cfif>

		<tr><TD align="right"> 
				<b>Location:</b>
			</TD>
			<TD nowrap> 
				<input type="text" name="location" >
			</TD>
		</tr>

		<tr><TD align="center" colspan="2"> 
				<b>OR</b>
			</TD>
		</tr>

		<tr><TD align="right"> 
				<b>File:</b>
			</TD>
			<TD nowrap> 
				<input type="file" name="file" >
			</TD>
		</tr>
		
		<cfif su>
		<tr><TD class="tdUnderLine" align="right"> 
				<b>Admin Editable:</b>
			</TD>
			<TD class="tdUnderLine" nowrap> 
				<input type="Checkbox" name="chkAdminEdit" value="1">
			</TD>
		</tr>
		<cfelse>
			<input type="Hidden" name="chkAdminEdit" value="1">
		</cfif>
		<tr><TD   align="right"> 
				&nbsp;
			</TD>
			<TD   nowrap> 
				<input type="Submit" name="add" value="Save" > <input type="Button" name="cancel" value="Cancel" onclick="javascript:history.go(-1);">
			</TD>
		</tr>

	</table>	
</form>




</cfoutput>
</div>
<cfinclude template="_footer.cfm"> 
