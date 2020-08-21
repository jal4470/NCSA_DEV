<!---
MODIFICATIONS
08/14/2017 - A.Pinzone - NCSA27024
-- Fixed spelling error (@location >> @locator)
--->
<cfcomponent>

<!--- =================================================================== --->
<cffunction name="getPublicMenu" access="public" returntype="query">
	<!--- --------
		08/05/08 - AArnone - New function: getPublicMenu Returns public menu data for location supplied
	----- --->
	<cfargument name="dsn"		type="string"  required="Yes">
	<!--- <cfargument name="isPublic" type="boolean" required="No" default="1" > --->
	<cfargument name="location" type="numeric" required="No">
	<cfargument name="swGetChild" type="Boolean" required="No" default="1">

	<CFSET loc_list = "">
	<cfif isDefined("ARGUMENTS.location") and len(trim(ARGUMENTS.LOCATION))>
		<CFSET loc_list = ARGUMENTS.location>
	</cfif>
	<cfif isDefined("ARGUMENTS.swGetChild") and ARGUMENTS.swGetChild>
		<CFSET loc_list = listAppend(loc_list, 4)>
	</cfif>

<!--- 	
arguments[[<cfdump var="#arguments#">]]
loc_list[[<cfdump var="#loc_list#">]]
<CFABORT> --->	

	<cfquery name="qGetPublicMenu" datasource="#arguments.dsn#">
		select menu_id, menu_name, locator, parent_menu_id, seq, location_id, userdefined
		  from tbl_menu 
		 where isPublic = 1
		 <cfif len(trim(VARIABLES.loc_list))>
		 	AND LOCATION_ID IN  (<cfqueryparam cfsqltype="CF_SQL_NUMERIC" list="Yes" value="#VARIABLES.loc_list#">)
		 </cfif>
		 ORDER BY LOCATION_ID, PARENT_MENU_ID, SEQ
	</cfquery>  <!--- (#VARIABLES.loc_list#) --->
	<cfreturn qGetPublicMenu>
</cffunction>
	

<!--- =================================================================== --->
<cffunction name="getPrivateMenu" access="public" returntype="query">
	<!--- --------
		08/06/08 - AArnone - New function: getPrivateMenu 
						returns private link data for role specified
		12/12/08 - AA - made "2,3,4,18" use the same menu
		
	----- --->
	<cfargument name="dsn"		  type="string"  required="Yes">
	<!--- <cfargument name="isPublic" type="boolean" required="No" default="1" > --->
	<cfargument name="location"   type="numeric" required="No">
	<cfargument name="swGetChild" type="Boolean" required="No" default="1">
	<cfargument name="roleid"	  type="numeric" required="yes">

	<CFSET loc_list = "">
	<cfif isDefined("ARGUMENTS.location") and len(trim(ARGUMENTS.LOCATION))>
		<CFSET loc_list = ARGUMENTS.location>
	</cfif>
	<cfif isDefined("ARGUMENTS.swGetChild") and ARGUMENTS.swGetChild>
		<CFSET loc_list = listAppend(loc_list, 4)>
	</cfif>
<!--- 
	<!--- -------------------------------------------------------------------------------------------------------------------
		  All Div Commissioners use the same menu,   role ids are: 6,7,8,9,10,11,12,13,14,15,16,17
		  NJ and NY ref assignors use the same menu, role ids are: 22, 23
		  pres,vp,Secretary,ruleschair ""        ""  role ids are: 2,3,4,18 
	anything not part of a list has been mapped seperatly. for example ncsa pres(2) an ncsa vp(3) use same menu
	but they were mapped individually. same goes for 20 and 21 
	
	IF a role id that is part of a list needs to have a diferent menu setup, remove id from list and map menu values for it in xref_menu_role
				select * from tlkp_role
				select distinct role_id from xref_menu_role (role_ids 2,3,14,31 are extras because of code below)
	------------------------------------------------------------------------------------------------------------------- --->
	
	<CFIF listFind("6,7,8,9,10,11,12,13,14,15,16,17", ARGUMENTS.roleid) GT 0>
		<CFSET useRoleID = 6>
	<CFELSEIF listFind("22,23", ARGUMENTS.roleid) GT 0>
		<CFSET useRoleID = 24> <!--- use the ref coordinator's menu --->
	<CFELSEIF listFind("2,3,4,18", ARGUMENTS.roleid) GT 0>
		<CFSET useRoleID = 2> <!--- use the pres's menu --->
	<CFELSE>
		<CFSET useRoleID = ARGUMENTS.roleid>
	</CFIF>
	
	<cfquery name="qGetPrivateMenu" datasource="#arguments.dsn#">
		select m.menu_id, m.menu_name, m.locator, m.parent_menu_id, m.MENU_CODE, m.location_id, m.seq, 
			   (select rr.ROLEDISPLAYNAME from TLKP_ROLE rr WHERE rr.ROLE_ID = #ARGUMENTS.roleid#) AS ROLEDISPLAYNAME
		  from XREF_MENU_ROLE x 
						INNER JOIN TBL_MENU  m ON m.MENU_ID = X.MENU_ID
						INNER JOIN TLKP_ROLE R ON R.ROLE_ID = X.ROLE_ID
		 where m.isPublic = 0
				<cfif len(trim(VARIABLES.loc_list))>
					AND LOCATION_ID IN (<cfqueryparam cfsqltype="CF_SQL_NUMERIC" list="Yes" value="#VARIABLES.loc_list#">)
				</cfif>
		   AND x.ROLE_ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.useRoleID#">
		 ORDER BY m.LOCATION_ID, m.PARENT_MENU_ID, x.SEQ
	</cfquery>  --->
	
	
	<!--- modified by B. Cooper 10/30/2009 - changed query to use roles for submenu items and get parents for all submenus.  roles are not
	used for parent menu items --->
	
	<cfquery datasource="#session.dsn#" name="qGetPrivateMenu">
		select a.menu_id, b.menu_name, b.locator, b.parent_menu_id, b.menu_code, a.seq, c.roledisplayname
		from xref_menu_role a
		inner join tbl_menu b
		on a.menu_id=b.menu_id
		inner join tlkp_role c
		on a.role_id=c.role_id
		where a.role_id=<cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#arguments.roleid#">
	</cfquery>
	
	
	<cfreturn qGetPrivateMenu>
</cffunction>

<cffunction
	name="getAllPrivateMenus"
	access="public"
	returntype="query">
	
	<cfquery datasource="#session.dsn#" name="getMenus">
		select a.*, b.menu_id as parent_menu_id, b.menu_name as parent_menu_name 
		from tbl_menu a
		left join tbl_menu b
		on a.parent_menu_id=b.menu_id
		where a.isPublic=0
		order by isnull(b.menu_name, a.menu_name), a.parent_menu_id, a.menu_name
	</cfquery>
	
	<cfreturn getMenus>
	
</cffunction>

<cffunction
	name="addMenu"
	access="public"
	returntype="numeric">
	<cfargument name="menu_name" type="string" required="Yes">
	<cfargument name="location" type="string" required="Yes">
	<cfargument name="parent_menu_id" type="string" required="Yes">
	<cfargument name="isPublic" type="string" required="Yes">
	<cfargument name="location_id" type="string" required="Yes">
	<cfargument name="adminEditable" type="string" required="No" default="false">
	
	<cfif arguments.adminEditable>
		<cfset userDefined="1">
	<cfelse>
		<cfset userDefined="0">
	</cfif>
	<!--- <cfdump var=#arguments#><cfdump var=#userDefined#><cfabort> --->
	<cfstoredproc datasource="#session.dsn#" procedure="p_insert_menu">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@menu_name" type="In" value="#arguments.menu_name#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@menu_code" type="In" value="#arguments.menu_name#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@locator" type="In" value="#arguments.location#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@parent_menu_id" type="In" value="#arguments.parent_menu_id#" null="#yesnoformat(arguments.parent_menu_id EQ "")#">
		<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@isPublic" type="In" value="#arguments.isPublic#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@location_id" type="In" value="#arguments.location_id#">
		<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@userDefined" type="In" value="#userDefined#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@menu_id" type="Out" variable="menu_id">
	</cfstoredproc>
	
	<cfreturn menu_id>
	
</cffunction>


<cffunction
	name="updateMenu"
	access="public"
	returntype="any">
	<cfargument name="menu_id" type="string" required="Yes">
	<cfargument name="menu_name" type="string" required="Yes">
	<cfargument name="location" type="string" required="Yes">
	<cfargument name="adminEditable" type="string" required="No" default="false">
	
	<cfif arguments.adminEditable>
		<cfset userDefined="1">
	<cfelse>
		<cfset userDefined="0">
	</cfif>
	
	<cfstoredproc datasource="#session.dsn#" procedure="p_update_menu">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@menu_id" type="In" value="#arguments.menu_id#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@menu_name" type="In" value="#arguments.menu_name#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@menu_code" type="In" value="#arguments.menu_name#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@locator" type="In" value="#arguments.location#">
		<cfprocparam cfsqltype="CF_SQL_BIT" dbvarname="@userDefined" type="In" value="#userDefined#">
	</cfstoredproc>
	
</cffunction>


<cffunction
	name="updateMenuSeq"
	access="public"
	returntype="any">
	<cfargument name="menu_id" type="string" required="Yes">
	<cfargument name="seq" type="string" required="Yes">
	<cfargument name="parent_menu_id" type="string" required="Yes">
	
	<cfquery datasource="#session.dsn#" name="updateMenuSeq">
		update tbl_menu
		set seq=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.seq#">,
		parent_menu_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.parent_menu_id#" null="#yesnoformat(arguments.parent_menu_id EQ "")#">
		where menu_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.menu_id#">
	</cfquery>
	
</cffunction>


<cffunction
	name="updateMenuRoleSeq"
	access="public"
	returntype="any">
	<cfargument name="menu_id" type="string" required="Yes">
	<cfargument name="role_id" type="string" required="Yes">
	<cfargument name="seq" type="string" required="Yes">
	
	<cfquery datasource="#session.dsn#" name="updateMenuSeq">
		update xref_menu_role
		set seq=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.seq#">
		where menu_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.menu_id#">
		and role_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.role_id#">
	</cfquery>
	
</cffunction>


<cffunction
	name="getMenuInfo"
	access="public"
	returntype="any">
	<cfargument name="menu_id" type="string" required="Yes">
	
	<cfquery datasource="#session.dsn#" name="getMenu">
		select * from tbl_menu
		where menu_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.menu_id#">
	</cfquery>
	
	<cfreturn getMenu>
	
</cffunction>


<cffunction
	name="getMenuRoles"
	access="public"
	returntype="any">
	<cfargument name="menu_id" type="string" required="no">
	<cfargument name="role_id" type="string" required="no">
	
	<cfquery datasource="#session.dsn#" name="getRoles">
		select a.role_id, a.menu_id, b.roledisplayname, c.menu_name, c.parent_menu_id from xref_menu_role a
		inner join tlkp_role b
		on a.role_id=b.role_id
		inner join tbl_menu c
		on a.menu_id=c.menu_id
		where 1=1
		<cfif isdefined("arguments.menu_id")>
		and a.menu_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.menu_id#">
		</cfif>
		<cfif isdefined("arguments.role_id")>
		and a.role_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.role_id#">
		</cfif>
	</cfquery>
	
	<cfreturn getRoles>
	
</cffunction>


<cffunction
	name="RemoveMenuRoles"
	access="public"
	returntype="any">
	<cfargument name="menu_id" type="string" required="Yes">
	
	<cfquery datasource="#session.dsn#" name="getRoles">
		delete from xref_menu_role
		where menu_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.menu_id#">
	</cfquery>
	
</cffunction>


<cffunction
	name="AddMenuRole"
	access="public"
	returntype="any">
	<cfargument name="menu_id" type="string" required="Yes">
	<cfargument name="role_id" type="string" required="Yes">
	
	<cfstoredproc datasource="#session.dsn#" procedure="p_insert_menu_role">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@menu_id" value="#arguments.menu_id#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@role_id" value="#arguments.role_id#">
	</cfstoredproc>
	
</cffunction>


<cffunction
	name="RemoveMenuRole"
	access="public"
	returntype="any">
	<cfargument name="menu_id" type="string" required="Yes">
	<cfargument name="role_id" type="string" required="Yes">
	
	<cfstoredproc datasource="#session.dsn#" procedure="p_remove_menu_role">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@menu_id" value="#arguments.menu_id#">
		<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@role_id" value="#arguments.role_id#">
	</cfstoredproc>
	
</cffunction>


<cffunction
	name="RemoveMenu"
	access="public"
	returntype="any">
	<cfargument name="menu_id" type="string" required="Yes">
	
	<cfquery datasource="#session.dsn#" name="getRoles">
		delete from tbl_menu
		where menu_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.menu_id#">
	</cfquery>
	
</cffunction>


</cfcomponent>