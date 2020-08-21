<!--- 
	FileName:	homesite+\html\Default Template.htm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - Site Index</H1>
<br>
<!--- <h2>yyyyyy </h2> --->
<br>
<!--- get PUBLIC MENU from TOP of page --->
<CFIF NOT isDefined("SESSION.publicMenu")>
	<cfinvoke component="#SESSION.sitevars.cfcPath#Menu" method="getPublicMenu" returnvariable="publicMenu">
		<cfinvokeargument name="DSN" value="#SESSION.DSN#">
		<cfinvokeargument name="location" value="1">
		<cfinvokeargument name="swGetChild" value="1">
	</cfinvoke>  <!--- <cfdump var="#publicMenu#"> --->
	<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
		<CFSET SESSION.publicMenu = publicMenu>
	</CFLOCK>
</CFIF>	
<!--- get PUBLIC MENU from BOTTOM of page --->
<CFIF NOT isDefined("SESSION.footerMenu")>
	<cfinvoke component="#SESSION.sitevars.cfcPath#Menu" method="getPublicMenu" returnvariable="footerMenu">
		<cfinvokeargument name="DSN" value="#Application.DSN#">
		<cfinvokeargument name="isPublic" value="1">
		<cfinvokeargument name="location" value="3">
		<cfinvokeargument name="swGetChild" value="0">
	</cfinvoke>  <!--- <cfdump var="#publicMenu#"> --->
	<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
		<CFSET SESSION.footerMenu = footerMenu>
	</CFLOCK>
</CFIF>	

<TABLE cellSpacing=1 cellPadding=5 width="100%" align=center border="0">
<tr class="tblHeading">
	<td class="tblHeading"> TOP MENU </td>

	<td class="tblHeading"> FOOTER </td>
</tr>	
<tr><td valign="top" align="left">
		<!--- get PARENT menu --->
		<cfquery name="getParent" dbtype="query">
				SELECT LOCATION_ID, LOCATOR, MENU_ID, MENU_NAME, PARENT_MENU_ID, SEQ
				FROM SESSION.publicMenu
				WHERE Parent_menu_id is NULL
				order by SEQ
		</cfquery>
		<!--- dump out parent menu choices --->
		<table>
			<cfloop query="getParent">
				<tr class="tblHeading">
					<td> #MENU_NAME# </td>
				</tr>	
				<cfquery name="getSub" dbtype="query">
					SELECT LOCATOR, MENU_NAME FROM SESSION.publicMenu WHERE Parent_menu_id = #MENU_ID# order by SEQ
				</cfquery>
				<CFLOOP query="getSub">
					<tr><td>#repeatstring("&nbsp;",10)#<a href="#LOCATOR#"> #MENU_NAME# </a>
						</td>
					</tr>
				</CFLOOP>
			</cfloop>
		</table>
	</td>

	<td valign="top" align="left">
		<table  >
			<tr class="tblHeading">
				<td> Footer </td>
			</tr>	
			<CFLOOP query="SESSION.FOOTERMENU">
				<CFIF UCASE(listFirst(LOCATOR,".")) EQ "WWW">
					<cfset useHTTP = "http://">
				<CFELSE>
					<cfset useHTTP = "">
				</CFIF>
				<tr><td>#repeatstring("&nbsp;",10)# <a href="#useHTTP##LOCATOR#">#MENU_NAME#</a> </td>
				</tr>
			</CFLOOP>
		</table>
	</td>
</tr>
</TABLE>  
















</cfoutput>
</div>
<cfinclude template="_footer.cfm">
		