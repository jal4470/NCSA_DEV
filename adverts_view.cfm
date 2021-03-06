<cfquery name="getBin" datasource="#session.DSN#">
	Select content, filename, extension
	from tbl_ad
	where ad_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#url.adid#">
</cfquery>



<!--- guess content type --->
<cfif listFindNoCase("xls,xlsx",getBin.extension)>
	<cfset mimeType="application/vnd.ms-excel">
<cfelseif listFindNoCase("doc,docx",getBin.extension)>
	<cfset mimeType="application/msword">
<cfelseif listFindNoCase("ppt",getBin.extension)>
	<cfset mimeType="application/vnd.ms-powerpoint">
<cfelseif listFindNoCase("pdf",getBin.extension)>
	<cfset mimeType="application/pdf">
<cfelse>
	<cfobject type="JAVA" class="java.net.URLConnection" name="urlcon">
	<cfset mimeType=urlcon.guessContentTypeFromName("#getBin.filename#.#getBin.extension#")>
</cfif>

<!--- if mime type is still blank, set to default --->
<cfif not isdefined("mimeType") OR mimeType EQ "">
	<cfset mimeType="application/file">
</cfif>

<cfheader name="Content-Disposition" value="inline; filename=""#getBin.filename#.#getBin.extension#""">

<cfcontent variable="#toBinary(getBin.content)#" type="#mimeType#">
