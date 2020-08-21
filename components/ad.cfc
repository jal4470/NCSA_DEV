<cfcomponent>
	<cffunction
		name="getAd"
		access="public"
		returntype="query">
		<cfargument name="ad_id" type="string" required="Yes">
		
		<cfquery datasource="#application.dsn#" name="getAd">
			select title, description, text, beginDate, endDate, href, customContent
			from tbl_ad
			where ad_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.ad_id#">
		</cfquery>
		
		<cfreturn getAd>
	</cffunction>
		
	<cffunction
		name="createAd"
		access="public"
		returntype="numeric"
		description="Creates an ad">
		<cfargument name="title" type="string" required="Yes">
		<cfargument name="description" type="string" required="Yes">
		<cfargument name="beginDate" type="date" required="Yes">
		<cfargument name="endDate" type="date" required="Yes">
		<cfargument name="href" type="string" required="Yes">
		<cfargument name="customContent" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_create_ad">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@title" type="In" value="#arguments.title#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@description" type="In" value="#arguments.description#">
			<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@beginDate" type="In" value="#arguments.beginDate#">
			<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@endDate" type="In" value="#arguments.endDate#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@href" type="In" value="#arguments.href#">
			<cfprocparam cfsqltype="CF_SQL_LONGVARCHAR" dbvarname="@customContent" type="In" value="#arguments.customContent#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@ad_id" type="Out" variable="ad_id">
		</cfstoredproc>
		
		<cfreturn ad_id>
		
	</cffunction>
		
	<cffunction
		name="updateAd"
		access="public"
		returntype="any"
		description="Creates an ad">
		<cfargument name="title" type="string" required="Yes">
		<cfargument name="description" type="string" required="Yes">
		<cfargument name="beginDate" type="date" required="Yes">
		<cfargument name="endDate" type="date" required="Yes">
		<cfargument name="href" type="string" required="Yes">
		<cfargument name="customContent" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_update_ad">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@ad_id" type="In" value="#arguments.ad_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@title" type="In" value="#arguments.title#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@description" type="In" value="#arguments.description#">
			<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@beginDate" type="In" value="#arguments.beginDate#">
			<cfprocparam cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@endDate" type="In" value="#arguments.endDate#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@href" type="In" value="#arguments.href#">
			<cfprocparam cfsqltype="CF_SQL_LONGVARCHAR" dbvarname="@customContent" type="In" value="#arguments.customContent#">
		</cfstoredproc>
		
		<cfreturn ad_id>
		
	</cffunction>
	
	<cffunction
		name="setText"
		access="public"
		returntype="any"
		description="Sets the content of the ad to be the given text">
		<cfargument name="ad_id" type="string" required="Yes">
		<cfargument name="text" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_set_ad_text">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@ad_id" type="In" value="#arguments.ad_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@text" type="In" value="#arguments.text#">
		</cfstoredproc>
		
	</cffunction>
	
	<cffunction
		name="setImage"
		access="public"
		returntype="any"
		description="Sets the content of the ad to be the given image content">
		<cfargument name="ad_id" type="string" required="Yes">
		<cfargument name="content" type="any" required="Yes">
		<cfargument name="filename" type="string" required="Yes">
		<cfargument name="extension" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_set_ad_image">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@ad_id" type="In" value="#arguments.ad_id#">
			<cfprocparam cfsqltype="CF_SQL_LONGVARBINARY" dbvarname="@content" type="In" value="#arguments.content#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@filename" type="In" value="#arguments.filename#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@extension" type="In" value="#arguments.extension#">
		</cfstoredproc>
		
	</cffunction>
	
	<cffunction
		name="deleteAd"
		access="public"
		returntype="any">
		<cfargument name="ad_id" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_remove_ad">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@ad_id" type="In" value="#arguments.ad_id#">
		</cfstoredproc>
		
	</cffunction>
	
	<cffunction
		name="flipStatus"
		access="public"
		returntype="any">
		<cfargument name="ad_id" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_flip_ad_status">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@ad_id" type="In" value="#arguments.ad_id#">
		</cfstoredproc>
		
	</cffunction>
	
	<cffunction
		name="logClick"
		access="public"
		returntype="any">
		<cfargument name="ad_id" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_log_ad_click">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@ad_id" type="In" value="#arguments.ad_id#">
		</cfstoredproc>
		
	</cffunction>
	
	<cffunction
		name="getCurrentAds"
		access="public"
		returntype="query">
		
		<cfquery datasource="#application.dsn#" name="ads">
			select title, text, description, href, ad_id, customContent
			from tbl_ad
			where getdate() > beginDate AND getdate() < endDate
			and active_flag=1
			order by seq
		</cfquery>
		
		<cfreturn ads>
		
	</cffunction>
	
	<cffunction
		name="getAdsToSequence"
		access="public"
		returntype="query">
		
		<cfquery datasource="#application.dsn#" name="ads">
			select title, text, description, href, ad_id, customContent
			from tbl_ad
			where getdate() < endDate
			and active_flag=1
			order by seq
		</cfquery>
		
		<cfreturn ads>
		
	</cffunction>
	
	<cffunction
		name="setAdSequence"
		access="public"
		returntype="any">
		<cfargument name="ad_id" type="string" required="Yes">
		<cfargument name="sequence" type="string" required="Yes">
		
		<cfstoredproc datasource="#application.dsn#" procedure="p_set_ad_sequence">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@ad_id" type="In" value="#arguments.ad_id#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@seq" type="In" value="#arguments.sequence#">
		</cfstoredproc>
		
	</cffunction>
	
	
	
</cfcomponent>