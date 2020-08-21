<cfcomponent displayname="emailTransmission" namespace="emailTransmission">
	<cfset dsn = "CP_EMAIL">
	<cffunction name="CreateTransmission" access="public" returntype="struct">
		<cfargument name="xmlToSend" type="any">
		<CFSET returndata =XMLParse("#arguments.xmltosend#",false)>
		<CFSET message_id = #returndata.message.XmlAttributes.id#>
		<CFSET product_id = #returndata.message.header.product_id.xmltext#>
		<CFSET event_id = #returndata.message.header.event_id.xmltext#>
		<CFSET launch_date = #returndata.message.header.launch_date.xmltext#>
		<CFSET from_email = #returndata.message.header.from_email.xmltext#>
		<CFSET from_alias = "#URLDECODE(returndata.message.header.from_alias.xmltext)#">
		<CFSET reply_to_email = #returndata.message.header.reply_to_email.xmltext#>
		<CFSET reply_to_alias = "#URLDECODE(returndata.message.header.reply_to_alias.xmltext)#">
		<CFSET subject = "#URLDECODE(returndata.message.header.subject.xmltext)#">
		<CFSET return_receipt_api = #returndata.message.header.return_receipt_api.xmltext#>
		<CFSET track_opens_flag = #returndata.message.header.track_opens_flag.xmltext#>
		<CFSET html_copy = "#URLDECODE(returndata.message.email_copy.html_copy.xmltext)#">
		<CFSET text_copy = "#URLDECODE(returndata.message.email_copy.text_copy.xmltext)#">
		<CFSET TheSql = "select * from tbl_recipient where recipient_id between 1 and 3">
		<cfset listserv_email = "listserv@venus.capturepoint.com">
	    <cfset listserv_password = "s8turnsq1">

		
		
		<CFSET hasattribs = 0>
		
		<cfset rs = structNew()>
		<cfset rs.status_code = 0>
		<!----------------------------------------->
		<!--- REPLACE P TAGS WITH CHAR10 AND 13 --->
		<!----------------------------------------->
		
		<!--- \r\n --->
		
		<CFSET carreturn = chr(13) & chr(10)>
		
		
		<CFSET text_copy = "#replace(text_copy,"<p>",carreturn,"ALL")#">
		<CFSET text_copy = "#replace(text_copy,"</p>",carreturn,"ALL")#">
		
		
		
		<!----------------------->
		<!--- PARSE TEXT COPY --->
		<!----------------------->
		
		<CFIF text_copy IS NOT "">
			<CFSET cutstring = "">
			<CFSET curindex = "0">
				<CFSET curblock = Find("<", "#text_copy#",1)>
				<CFIF curblock GT 0>
				<CFSET curindex = "1">
					<CFLOOP CONDITION="#curindex# GT 0">
						<CFSET curblock=Find("<", "#text_copy#",curindex)>
						<CFSET curindex = curblock>
						<CFSET curblockend=Find(">", "#text_copy#",curindex)>
						<CFIF curindex GT 0 AND curblockend GT 0>
							<CFSET leftstart = curindex>
							<CFSET rightend = (curblockend - leftstart) + 1>
							<CFSET cutstring = "#Mid(text_copy,leftstart,rightend)#">
							<CFSET text_copy = "#replace(text_copy,cutstring,"","ALL")#">
							<CFSET curindex = leftstart>
						<CFELSE>
							<CFSET curindex = "0">
						</CFIF>
					</CFLOOP>		
				</CFIF>
		</CFIF>
		
		<CFSET spacecopy = "&nbsp;">
		<CFSET text_copy = "#replace(text_copy,spacecopy,"","ALL")#">
		
		
		<!----------------------->
		<!--- PERSONALIZATION FOR LISTSERV --->
		<!----------------------->
		
		<CFSET openper = "{!">
		<CFSET text_copy = "#replace(text_copy,openper,"&","ALL")#">
		<CFSET html_copy = "#replace(html_copy,openper,"&","ALL")#">
		
		<CFSET closeper = "}">
		<CFSET text_copy = "#replace(text_copy,closeper,";","ALL")#">
		<CFSET html_copy = "#replace(html_copy,closeper,";","ALL")#">
		
		<!------------------->
		<!--- Validations --->
		<!------------------->
		<cfif product_id EQ "">
			<cfset rs.errorMsg = "ERROR,Required parameter product not supplied.">
		</cfif>
		
		<cfif event_id EQ "">
			<cfset rs.errorMsg = "ERROR,Required parameter event_id not supplied.">
		</cfif>
		
		<!-------------------------------->
		<!--- Execute stored procedure --->
		<!-------------------------------->
		<!----------------------------------------->
		<!--- Create Transmission         		--->
		<!----------------------------------------->
		<cftry>
			<CFSTOREDPROC datasource="#dsn#" procedure="p_create_transmission_log" returncode="YES" >
				<CFPROCRESULT NAME="RS">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#product_id#" DBVARNAME="@product_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#event_id#" DBVARNAME="@event_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="" DBVARNAME="@campaign_id" NULL="yes">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="1" DBVARNAME="@live_transmission">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_BIT" VALUE="0" DBVARNAME="@transmission_confirmed">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#launch_date#" DBVARNAME="@send_date" NULL="#YesNoFormat(launch_date EQ "")#">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#return_receipt_api#" DBVARNAME="@return_receipt_api" NULL="#YesNoFormat(return_receipt_api EQ "")#">
				<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="transmission_id" DBVARNAME="@transmission_id">
			</CFSTOREDPROC>
			
			<cfcatch type="database">		
				<cfset rs.errorMsg = "ERROR,"& cfcatch.nativeErrorCode >
						<cfset rs.status_code = -1>
			</cfcatch>
			<cfcatch type="any">
					<cfset rs.errorMsg = "ERROR,000011">		
					<cfset rs.status_code = -1>
			</cfcatch>
		</cftry>
		<CFIF NOT(ISDEFINED("transmission_id"))>
			<cfset rs.errorMsg = "ERROR, No Transmission id for attrib">
			<cfset rs.status_code = -1>
		</CFIF>
		
		<!----------------------------------------->
		<!--- INSERT ATTRIBUTES			        --->
		<!----------------------------------------->
		
		<CFIF ISDEFINED("returndata.message.recipient_attributes")>
			<CFSET hasattribs = 1>
		</CFIF>
		
		<CFIF hasattribs EQ 1>
			<cfset ele=returndata.message.recipient_attributes.XmlChildren>
			
			<cfloop from="1" to="#ArrayLen(ele)#" index="i">
			
			<CFSET field_name = "#ele[i].code.xmltext#">
			<CFSET openper = "{!">
			<CFSET field_name = "#replace(field_name,openper,"","ALL")#">
			<CFSET closeper = "}">
			<CFSET field_name = "#replace(field_name,closeper,"","ALL")#">
			
			<CFSET field_code = "#ele[i].code.xmltext#">
			
			<!---<cffile action="append" file="E:\Inetpub\VirtualWWWRoot\services\log\#rawlogFileName#" output="#field_name#;#field_code#;#transmission_id#" addnewline="yes" />--->
			
			<cftry>
				<CFSTOREDPROC datasource="#dsn#" procedure="p_insert_transmission_attrib" returncode="YES" >
					<CFPROCRESULT NAME="RS">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#transmission_id#" DBVARNAME="@transmission_id">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#field_name#" DBVARNAME="@field_name">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#field_code#" DBVARNAME="@listserv_field_code">
					<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="transmission_attrib_id" DBVARNAME="@transmission_attrib_id">
				</CFSTOREDPROC>
				
				<cfcatch type="database">		
						<cfset rs.errorMsg = "ERROR,"& cfcatch.nativeErrorCode >
								<cfset rs.status_code = -1>
				</cfcatch>
				<cfcatch type="any">
					<cfset rs.errorMsg = "ERROR, 000011">
							<cfset rs.status_code = -1>
				</cfcatch>
			</cftry>
			</cfloop> 
		</CFIF>
		
		<!----------------------------------------->
		<!--- INSERT RECIPIENTS			        --->
		<!----------------------------------------->
		
		
		<cfset ele1=returndata.message.recipient_list.recipient>
		
		<cfloop from="1" to="#ArrayLen(ele1)#" index="i">
			<cfloop from="1" to="#arrayLen(ele1[i])#" index="j">
			<cftry>
				<CFSTOREDPROC datasource="#dsn#" procedure="p_create_transmission_list" returncode="YES" >
					<CFPROCRESULT NAME="RS">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#transmission_id#" DBVARNAME="@transmission_id">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ele1[i].XmlAttributes.email#" DBVARNAME="@email">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#ele1[i].XmlAttributes.id#" DBVARNAME="@profile_id">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="0" DBVARNAME="@undeliverable">
					<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="transmission_list_id" DBVARNAME="@transmission_list_id">
				</CFSTOREDPROC>
				
				<cfcatch type="database">		
						<cfset rs.errorMsg = "ERROR,"& cfcatch.nativeErrorCode >
								<cfset rs.status_code = -1>
				</cfcatch>
				<cfcatch type="any">
					<cfset rs.errorMsg = "ERROR, 000011">
							<cfset rs.status_code = -1>
				</cfcatch>
			</cftry>
			<CFIF hasattribs EQ 1>
				<cfloop from="1" to="#arrayLen(ele1[i].XmlChildren)#" index="k">
					<CFQUERY NAME="getattrib" DATASOURCE="#dsn#">
						SELECT TRANSMISSION_ATTRIB_ID
						  FROM V_TRANSMISSION_ATTRIB
						 WHERE TRANSMISSION_ID = #TRANSMISSION_ID#
					<CFIF ele1[i].XmlChildren[k].XmlAttributes.id EQ 1>
						   AND FIELD_NAME = 'FNAME'
					<CFELSEIF ele1[i].XmlChildren[k].XmlAttributes.id EQ 2>
						   AND FIELD_NAME = 'LNAME'
					<CFELSEIF ele1[i].XmlChildren[k].XmlAttributes.id EQ 3>
						   AND FIELD_NAME = 'EMAILADDRESS'
					<CFELSEIF ele1[i].XmlChildren[k].XmlAttributes.id EQ 4>
						   AND FIELD_NAME = 'FAMILYNAME'
					<CFELSEIF ele1[i].XmlChildren[k].XmlAttributes.id EQ 5>
						   AND FIELD_NAME = 'PRIMARY_ADDRESS'
					<CFELSEIF ele1[i].XmlChildren[k].XmlAttributes.id EQ 6>
						   AND FIELD_NAME = 'PRIMARY_CITY'
					<CFELSEIF ele1[i].XmlChildren[k].XmlAttributes.id EQ 7>
						   AND FIELD_NAME = 'PRIMARY_STATE'
					<CFELSEIF ele1[i].XmlChildren[k].XmlAttributes.id EQ 8>
						   AND FIELD_NAME = 'PRIMARY_ZIP5'
					</CFIF>
					</CFQUERY>
					<CFSET cur_attrib_id = getattrib.TRANSMISSION_ATTRIB_ID>
					
					<cftry>
						<CFSTOREDPROC datasource="#dsn#" procedure="p_insert_transmission_list_attrib" returncode="YES" >
							<CFPROCRESULT NAME="RS">
							<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#transmission_list_id#" DBVARNAME="@transmission_list_id">
							<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#cur_attrib_id#" DBVARNAME="@transmission_attrib_id">
							<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ele1[i].XmlChildren[k].xmltext#" DBVARNAME="@value">
							<CFPROCPARAM TYPE="OUT" CFSQLTYPE="CF_SQL_INTEGER" VARIABLE="transmission_list_attrib_id" DBVARNAME="@transmission_list_attrib_id">
						</CFSTOREDPROC>
						
						<cfcatch type="database">		
							<cfset rs.errorMsg = "ERROR," & cfcatch.nativeErrorCode >
									<cfset rs.status_code = -1>
						</cfcatch>
						<cfcatch type="any">
							<cfset rs.errorMsg = "ERROR, 000011">
									<cfset rs.status_code = -1>
						</cfcatch>
					</cftry>
					
				</cfloop>
			</CFIF>		
			</cfloop>
		</cfloop> 
		
		<cfset logFileName = DateFormat(now(), "YYYYMMDD") & "_" & TimeFormat(now(), "HHmmss") & "_" & message_id & ".txt" />
		<!---<cffile action="write" file="E:\Inetpub\VirtualWWWRoot\services\log\#logFileName#" output="#returndata#" addnewline="yes" />--->
		
		
		<!----------------------------------------->
		<!--- GET RECIPIENT SQL			        --->
		<!----------------------------------------->
		
		<cftry>
			<CFSTOREDPROC datasource="#dsn#" procedure="p_create_listserv_sql" returncode="YES">
				<CFPROCRESULT NAME="LISTSERV_SQL">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#transmission_id#" DBVARNAME="@transmission_id">
			</CFSTOREDPROC>
			
			<cfcatch type="database">		
				<cfset rs.errorMsg = "ERROR,"& cfcatch.nativeErrorCode >		
				<cfset rs.status_code = -1>
			</cfcatch>
			<cfcatch type="any">
				<cfset rs.errorMsg = "ERROR, 000011">
						<cfset rs.status_code = -1>
			</cfcatch>
		</cftry>
		
		
		<!---<cffile action="append" file="E:\Inetpub\VirtualWWWRoot\services\log\#logFileName#" output="##LISTSERV_SQL.COMPUTED_COLUMN_1##" addnewline="yes" />--->
		
		<!----------------------------------------->
		<!--- CREATE LISTSERV WRAPPER	        --->
		<!----------------------------------------->
		
		
		
			<CFSET mailbody= "//" & replace(subject," ", "", "ALL") & " JOB ECHO=YES" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "// DISTRIBUTE MAIL-MERGE DBMS=YES ," & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "FROM=owner-nolist-e_" & trim(transmission_id) & "@venus.capturepoint.com ," & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "PW=#listserv_password#" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "//TO DD *" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & URLDecode(#LISTSERV_SQL.COMPUTED_COLUMN_1#) & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "/*" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "//DATA DD *" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "Date: &*DATE;" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "From: " & chr(34) & from_alias & chr(34) & "<" & from_email & ">" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "Subject: " & subject & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "To: &*TO;" & Chr(13) & Chr(10)> 
			<CFSET mailbody = mailbody & "MIME-Version: 1.0" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "Content-Type: multipart/alternative; boundary=""06986E0E1E196312E032AFBC""" & Chr(13) & Chr(10) & Chr(13) & Chr(10) >
			<CFSET mailbody = mailbody & "--06986E0E1E196312E032AFBC" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "Content-Type: text/plain; charset=us-ascii" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "Content-Transfer-Encoding: 7bit" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "Content-Disposition: inline" & Chr(13) & Chr(10) & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & urldecode(text_copy) & Chr(13) & Chr(10) & Chr(13) & Chr(10) >
			<CFSET mailbody = mailbody & "--06986E0E1E196312E032AFBC" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "Content-Type: text/html; charset=us-ascii" & Chr(13) & Chr(10)> 
			<CFSET mailbody = mailbody & "Content-Transfer-Encoding: 7bit" & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "Content-Disposition: inline" & Chr(13) & Chr(10) & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & urldecode(html_copy) & Chr(13) & Chr(10) & Chr(13) & Chr(10)>
			<CFSET mailbody = mailbody & "--06986E0E1E196312E032AFBC--" & Chr(13) & Chr(10) & "/*">
			
		
		
		<!----------------------------------------->
		<!--- UPDATE TBL_TRANSMISSION	        --->
		<!----------------------------------------->
		
		<cftry>
			<CFSTOREDPROC datasource="#dsn#" procedure="p_set_listserv_copy" returncode="YES" >
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#transmission_id#" DBVARNAME="@transmission_id">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#mailbody#" DBVARNAME="@listserv_message">
			</CFSTOREDPROC>
			
			<cfcatch type="database">		
				<cfset rs.errorMsg = "ERROR,"& cfcatch.nativeErrorCode >
						<cfset rs.status_code = -1>
			</cfcatch>
			<cfcatch type="any">
				<cfset rs.errorMsg = "ERROR, 000011">
						<cfset rs.status_code = -1>
			</cfcatch>
		</cftry>
		
		<cfif not rs.status_code >
			<cfset rs.status_code = 0>
			<cfset rs.msg = "Success">
			<cfif isdefined("transmission_id")>
				<cfset rs.transmission_id = transmission_id>
			<cfelse>
				<cfset rs.transmission_id = 0 >
			</cfif>
		</cfif>

	<cfreturn rs>
	</cffunction>

</cfcomponent>