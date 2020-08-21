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
<H1 class="pageheading">NCSA - Edit Menu</H1>
<br> <!--- <h2>yyyyyy </h2> --->


<cfif isdefined("url.menu_id")>
	<cfset menu_id=url.menu_id>
<cfelse>
	<cfthrow message="menu_id must be defined in url">
</cfif>


<!--- get menu info --->
<cfinvoke
	component="#session.sitevars.cfcpath#.menu"
	method="getMenuInfo"
	menu_id="#menu_id#"
	returnvariable="menuInfo">

<cfif structkeyexists(session.user.strole,"61")>
	<cfset su=true>
<cfelse>
	<cfset su=false>
</cfif>
	

<form action="menu_edit_action.cfm" method="post" enctype="multipart/form-data">
	<input type="hidden" name="menu_id" value="#menu_id#">
	<table cellspacing="0" cellpadding="5" border="0" width="60%">
		<tr class="tblHeading">
			<TD colspan="2"> &nbsp; </TD>
		</tr>
		<tr><TD width="25%"   align="right"> 
				<b>Menu Name:</b>
			</TD>
			<TD nowrap> 
				<input type="text" name="name" value="#menuInfo.menu_name#" >
			</TD>
		</tr>

		<tr><TD align="right"> 
				<b>Location:</b>
			</TD>
			<TD nowrap> 
				<input type="text" name="location" value="#menuInfo.locator#" >
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
				<input type="Checkbox" name="chkAdminEdit" value="1" <cfif menuInfo.userDefined EQ 1>checked="checked"</cfif>>
			</TD>
		</tr>
		<cfelse>
			<input type="Hidden" name="chkAdminEdit" value="#menuInfo.isPublic#">
		</cfif>

		<tr><TD   align="right">
				&nbsp;
			</TD>
			<TD   nowrap> 
				<input type="Submit" name="save" value="Save" > <input type="Button" name="cancel" value="Cancel" onclick="javascript:history.go(-1);">
			</TD>
		</tr>

	</table>	
</form>




</cfoutput>
</div>
<cfinclude template="_footer.cfm"> 
