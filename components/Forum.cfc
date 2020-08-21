 
<cfcomponent>
<CFSET DSN = SESSION.DSN>

<!--- =================================================================== --->
<cffunction name="getForumCounts" access="public" returntype="query">
	<!--- 11/13/08 - AArnone - 	----- 
		05/20/2009 - AArnone - T:7763 - Added "AND RefThread = 0" to correct counts
	--->
	<cfargument name="categoryType" type="string" 	required="Yes"> 
	
	<cfset ForumWhere = " ">
	<CFIF isDefined("ARGUMENTS.categoryType")>
		<cfswitch expression="#UCASE(ARGUMENTS.categoryType)#">
			<cfcase value="PUBLIC">
				<cfset ForumWhere = " WHERE t.Category = 'PUBLIC' ">
			</cfcase>
			<!--- <cfcase value="CLUBS">
				<cfset ForumWhere = " WHERE t.Category = 'CLUBS' " >
			</cfcase> --->
			<cfcase value="ALL">
				<cfset ForumWhere = " ">
			</cfcase>
		</cfswitch>
	</CFIF>

	<!--- <cfquery name="qForum" datasource="#SESSION.DSN#">
		Select f.TopicID, Count(*) as topic_total,
			   t.TOPICDESCRIPTION 
		  From TBL_FORUM f inner Join TBL_ForumTopics t ON t.TopicID = f.TopicID
		 Where f.Released = 'Y'
		 #preserveSingleQuotes(ForumWhere)#
		 Group by f.TopicID,  t.TOPICDESCRIPTION 
	</cfquery> <cfdump var="#qForum#"> --->

	<cfquery name="qForum" datasource="#SESSION.DSN#">
		Select t.TopicID, t.TOPICDESCRIPTION, 
			   (select Count(*) from TBL_FORUM where TopicID = t.TopicID AND RefThread = 0 AND Released = 'Y'  ) as topic_total
		  From TBL_ForumTopics t 
		   #preserveSingleQuotes(ForumWhere)#
		 Group by t.TopicID,  t.TOPICDESCRIPTION 
	</cfquery> <!--- <cfdump var="#qForum#"> --->


	
	
	<cfreturn qForum>

</cffunction>

<cffunction name="InsertForumPost" access="public" >
	<!--- 11/20/08 - AArnone - 	----- 
					swReleasYN when set to "Y" it means that the post can be released right away, its usually
					a post by an admin or board member

		<cfinvoke component="#SESSION.SITEVARS.cfcPath#FORUM" method="InsertForumPost" >
			<cfinvokeargument name="TopicID"	value="#.#">
			<cfinvokeargument name="RefThread"	value="#.#">
			<cfinvokeargument name="MainThread" value="#.#">
			<cfinvokeargument name="Subject"	value="#.#">
			<cfinvokeargument name="Message"	value="#.#">
			<cfinvokeargument name="PostedBy"	value="#.#">
			<cfinvokeargument name="swReleasYN"	value="#.#">
		</cfinvoke>

	--->
	<cfargument name="TopicID"		type="numeric"	required="Yes">
	<cfargument name="RefThread"	type="numeric"	required="Yes">
	<cfargument name="MainThread"	type="numeric"	required="Yes">
	<cfargument name="Subject"		type="string"	required="Yes">
	<cfargument name="Message"		type="string"	required="Yes">
	<cfargument name="PostedBy"		type="string"	required="Yes">
	<cfargument name="swReleasYN"	type="string"	required="Yes">
	
	<CFQUERY name="qInsertForumPost" datasource="#SESSION.DSN#">
		Insert Into TBL_Forum
			( TopicID, RefThread, MainThread
			, Subject, Message
			, PostedBy, PostDate, PostTime
			<cfif isDefined("ARGUMENTS.swReleasYN") AND ARGUMENTS.swReleasYN EQ "Y">
				, Released, ReleaseDate, ReleaseTime 
			</cfif>
			)
		values 
			( <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.TopicID#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.RefThread#">
			, <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#ARGUMENTS.MainThread#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Subject#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.Message#">
			, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.PostedBy#">
			, getDate()
			, getDate()
			<cfif isDefined("ARGUMENTS.swReleasYN") AND ARGUMENTS.swReleasYN EQ "Y">
				, 'Y'			
				, getDate()
				, getDate()
			</cfif>
			) 
	</CFQUERY>
		
</cffunction>



 
 	
<!--- --------------------------
	End component fineFees	
--------------------------- --->
 </cfcomponent>	

