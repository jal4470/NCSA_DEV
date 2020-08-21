<!--- 
MODIFICATIONS
3/11/2010, J. Oriente
  > set product_id to 25
  > update DSN to NCSAdev
  > update queries to reflect table and view changes

--->

<cfcomponent displayname="AsynchE-mailer" output="false" hint="Asynchronous CMFL gateway for sending of e-mails from the E-Mail Blaster">
    <cffunction name="onIncomingMessage" output="false">
        <cfargument name="CFEvent" type="struct" required="true" />

		<!----------------------------------------->
		<!--- CREATE ERROR LOG FILENAME			--->
		<!----------------------------------------->
		<cfset variables.api_path = "NCSAROOT.MessageManager.API.">
		<cfset variables.dsn = "NCSA">
       <!--------- <cfset logFileName = DateFormat(now(), "YYYYMMDD") & "_" & TimeFormat(now(), "HHmmss") & "_" & #CFEvent.Data.message_id# & ".txt" />
        <cffile action="write" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Component	ID	Description	Date/Time	Code" addnewline="yes" />
        
        -------------------------------->
		<!--- INSERT FIRST ENTRY				--->
		<!----------------------------------------->
        <cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Begin Transaction">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="0">
		</cfstoredproc>
      	<!---------  <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	Begin Transaction	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	0" addnewline="yes" />


	-------------------------------->
		<!--- GET MESSAGE METADATA				--->
		<!----------------------------------------->
		
   		
   		<cftry>
   			<cfquery name="GetMessageInfo" datasource="#variables.dsn#">
				select message_id,
					   message_desc,
					   from_email_address,
					   from_email_alias,
					   replyto_email_address,
					   replyto_email_alias,
					   subject,
					   cc_emails,
					   bcc_emails,
					   html_copy,
					   text_copy,
					   scheduled_date,
					   sent_date,
					   confirmed_date,
					   track_opens_flag,
					   datecreated,
					   dateupdated,
					   status_id,
					   FirstName,
					   LastName,
					   email
				  from v_message
				 where message_id = #CFEvent.Data.message_id#
			</cfquery>
		
		<cfmail to="#email#"
			from="#from_email_address#"
			replyto="#replyto_email_address#"
			subject="#subject#"
			
			type="HTML"
			query="GetMessageInfo">
			#replace(replace(replace(GetMessageInfo.html_copy,'{!EMAILADDRESS}',GetMessageInfo.email,'All'),'{!FNAME}',GetMessageInfo.FirstName,'All'),'{!LNAME}',GetMessageInfo.LastName,'All')#
		</cfmail>
			
		
			<cfcatch type="any">
				<cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
					<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
					<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
					<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Error on message data #CFCATCH.Detail#">
					<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="1">
				</cfstoredproc>
		  	</cfcatch>
		</cftry>
		




		<!--- -----------------------------------
		<!--- LOG SUCCESS						--->
		<!----------------------------------------->
        <cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Got message data">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="0">
		</cfstoredproc>
        <!--- <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	Got message data #GetMessageInfo.recordcount# Files	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	0" addnewline="yes" /> --->
        
        <!----------------------------------------->
		<!--- CREATE XML						--->
		<!----------------------------------------->
        <CFOUTPUT>
        <CFIF GetMessageInfo.scheduled_date IS NOT "">
        	<CFSET senddate = #DateFormat(GetMessageInfo.scheduled_date,"MM/DD/YYYY")# & " " & #TimeFormat(GetMessageInfo.scheduled_date,"h:mm tt")#>
        <CFELSE>
        	<CFSET senddate = #DateFormat(now(),"MM/DD/YYYY")# & " " & #TimeFormat(now(),"h:mm tt")#>
        </CFIF>
		<!--- replace unsupported XML characters --->
		<cfset GetMessageInfo.html_copy=replaceEncodings(GetMessageInfo.html_copy)>
        <cfsavecontent variable="XMLToSend"><?xml version="1.0" encoding="utf-8"?><message id="#GetMessageInfo.message_id#" name="message"><header name="header"><product_id>25</product_id><event_id>#GetMessageInfo.message_id#</event_id><launch_date>#senddate#</launch_date><from_email>#GetMessageInfo.from_email_address#</from_email><from_alias>#URLENCODEDFORMAT(GetMessageInfo.from_email_alias)#</from_alias><reply_to_email>#GetMessageInfo.replyto_email_address#</reply_to_email><reply_to_alias>#URLENCODEDFORMAT(GetMessageInfo.replyto_email_alias)#</reply_to_alias><subject>#URLENCODEDFORMAT(GetMessageInfo.subject)#</subject><return_receipt_api>https://register.communitypass.net/api/SetMessageConfirmedDate.cfm</return_receipt_api><track_opens_flag>#GetMessageInfo.track_opens_flag#</track_opens_flag></header><email_copy name="email_copy"><html_copy>#URLENCODEDFORMAT(GetMessageInfo.html_copy)#</html_copy><text_copy>#URLENCODEDFORMAT(GetMessageInfo.html_copy)#</text_copy></email_copy></cfsavecontent>
        </CFOUTPUT>
        
        
        <!----------------------------------------->
		<!--- GET PERSONALIZATION CODES			--->
		<!----------------------------------------->
        <CFSET html_copy = GetMessageInfo.html_copy>
        <CFSET perstring = "">
		<CFSET curindex = "0">
		<CFSET curblock = REFind("{![A-Z]+}", "#html_copy#",1,1)>
		<CFIF curblock.pos[1] GT 0>
		<CFSET curindex = "1">
			<CFLOOP CONDITION="#curindex# GT 0">
				<CFSET curblock=REFind("{![A-Z]+}", "#html_copy#",curindex,1)>
				<CFSET curindex = curblock.pos[1]>
				<CFSET curlen = curblock.len[1]>
				<CFIF curindex GT 0>
					<CFSET leftstart = curindex>
					<CFSET rightend = curlen>
					<CFIF perstring IS NOT "">
						<CFSET perstring = perstring & "," & "#Mid(html_copy,leftstart,rightend)#">
					<CFELSE>
						<CFSET perstring = "#Mid(html_copy,leftstart,rightend)#">
					</CFIF>
					<CFSET curindex = curindex + curlen + 1>
				<CFELSE>
					<CFSET curindex = "0">
				</CFIF>
			</CFLOOP>		
		</CFIF>
		
		
		<!----------------------------------------->
		<!--- GET ATTRIBUTES FROM DB			--->
		<!----------------------------------------->
		
		<cftry>
			<CFSTOREDPROC datasource="#variables.dsn#" procedure="p_get_message_attribs" returncode="YES">
				<CFPROCRESULT NAME="getPerson" RESULTSET="1">
				<CFPROCRESULT NAME="getRecipients" RESULTSET="2">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#perstring#" DBVARNAME="@message_per_fields">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="," DBVARNAME="@string_delimiter">
				<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_INTEGER" VALUE="#CFEvent.Data.message_id#" DBVARNAME="@message_id">
			</CFSTOREDPROC>
		
			<cfcatch>
				<!--- <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	Error getting Attribs from db #CFCATCH.Detail#	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	4" addnewline="yes" /> --->
		<cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Error getting Attribs from db: #cfcatch.message#-#cfcatch.detail#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="2">
		</cfstoredproc>
			</cfcatch>
		</cftry>
		
		<!----------------------------------------->
		<!--- APPEND ATTRIBUTES TO XML			--->
		<!----------------------------------------->
		
		<CFIF getPerson.recordcount GT 0>
		<CFOUTPUT>
        <cfsavecontent variable="XMLToSend">#XMLToSend#<recipient_attributes name="recipient_attributes"><CFLOOP QUERY="getPerson"><recipient_attrib id="#message_per_fields_id#"><code>#code#</code><name>#field_name#</name></recipient_attrib></CFLOOP></recipient_attributes></cfsavecontent>
        </CFOUTPUT>
	  	</CFIF>
	  	
      <!---   <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	Got Attributes	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	0" addnewline="yes" /> --->
        <cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Got Attributes">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="0">
		</cfstoredproc>
        
        <!----------------------------------------->
		<!--- STRUCTURE RECIPIENT DATA			--->
		<!----------------------------------------->
        
        <CFSCRIPT>
		St = structNew();
		</CFSCRIPT>
		<CFLOOP QUERY="getPerson">
		<CFSCRIPT>StructInsert(St,'#field_name#',#MESSAGE_PER_FIELDS_ID#);</CFSCRIPT>
		</CFLOOP>
        
     <!---    <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	Made Structure	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	0" addnewline="yes" /> --->
        <cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Structure Created">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="0">
		</cfstoredproc>
        
        <CFSET curdata="">
		<CFSET curfield="">
		<cfset x = "">
		<cfset y = "">
		<cfloop query="getPerson">
			<cfset "curfield#getPerson.currentrow#" = "getRecipients." & field_name>
			<CFSET "curdata#getPerson.currentrow#" = "St." & field_name>
			<cfset numColumn = getPerson.recordcount>
		</cfloop>
		
         <cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Set Attribs">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="0">
		</cfstoredproc>
        <!--- <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	Set Attribs	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	0" addnewline="yes" /> --->
       
        
        <!----------------------------------------->
		<!--- APPEND RECIPIENTS TO XML			--->
		<!----------------------------------------->
		
		<CFOUTPUT>
		<cfsavecontent variable="XMLToSend">#XMLToSend#<recipient_list name="recipient_list"><CFLOOP QUERY="getRecipients"><recipient id="#contact_id#" name="recipient" email="#email#"><CFIF getPerson.recordcount GT 0><CFLOOP from="1" to="#numColumn#" index="i"><cfset curfield = evaluate("curfield"&i)><cfset curdata = evaluate("curdata"&i)><attrib id="#evaluate(curdata)#">#URLENCODEDFORMAT(evaluate(curfield))#</attrib></CFLOOP></CFIF><CFSET curfield=""><CFSET curdata=""></recipient></CFLOOP></recipient_list></message></cfsavecontent>
        </CFOUTPUT>
        
        <!--- <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	Looped Recips	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	0" addnewline="yes" /> --->
          <cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Iterated thru Recipients">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="0">
		</cfstoredproc>
		<!--- Log XML Packet --->
        <cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_XML">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Message_Xml" value="#urldecode(XMLToSend)#">
		</cfstoredproc>
      <!---   <cffile action="write" file="E:\Inetpub\securewwwroot\products\communitypass\log\xml#logFileName#" output="#XMLToSend#" addnewline="yes" />
       --->
        
        <!----------------------------------------->
		<!--- LOG SUCCESS						--->
		<!----------------------------------------->
        
       <!---  <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	XML Created	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	0" addnewline="yes" /> --->
        
        <cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="XML Created">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="0">
		</cfstoredproc>
        <!----------------------------------------->
		<!--- POST XML TO CP_EMAIL				--->
		<!----------------------------------------->
        
        <cftry>
		<!--- 	<CFHTTP METHOD="POST" URL="https://register.communitypass.net/api/CreateTransmission.cfm" redirect="NO" throwonerror="Yes">
				<CFHTTPPARAM NAME="XMLToSend" TYPE="FormField" VALUE="#XMLToSend#">
			</CFHTTP> --->
			<cfinvoke component="#variables.api_path#EmailTransmission" method="CreateTransmission" returnvariable="rs">
				<cfinvokeargument name="xmlToSend" value="#xmlToSend#">
			</cfinvoke>

			<cfcatch type="any">
				<!--- <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	Error on post to service #CFCATCH.Detail#	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	2" addnewline="yes" /> --->
		<cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="Error on post to service #CFCATCH.Detail#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="3">
		</cfstoredproc>


		  	</cfcatch>
		</cftry>
		<!--- Set variables based on API output --->
		<cfset status = rs.status_code>
		<cfset returncode = rs.transmission_id>
		
		<cfif trim(status) NEQ 0>
			<!--- <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	XML Post Error	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	#returncode#" addnewline="yes" /> --->
		<cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="XML Post Error">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="0">
		</cfstoredproc>
			<cfabort>
		</cfif>
        
        
        <!----------------------------------------->
		<!--- LOG SUCCESS						--->
		<!----------------------------------------->
        
        <!--- <cffile action="append" file="E:\Inetpub\securewwwroot\products\communitypass\log\#logFileName#" output="Newsletter	#CFEvent.Data.message_id#	Posted XML #returncode#	#DateFormat(now(), "MM/DD/YYYY")# - #TimeFormat(now(), "HH:mm ss")#	0" addnewline="yes" /> --->
        <cfstoredproc  datasource="#variables.dsn#" procedure="P_INSERT_MESSAGE_GATEWAY_LOG">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" dbvarname="@Message_id" value="#CFEvent.Data.message_id#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Component" value="Newsletter">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Description" value="XML Posted to CP_EMAIL Transmission_id:#returncode#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="@Error_Code" value="0">
		</cfstoredproc> --->

    </cffunction>
	
	
	<cffunction
		name="replaceEncodings"
		access="private"
		returntype="string">
		<cfargument name="inputString" type="string" required="Yes">
		
		<cfset t=arguments.inputString>
		
		<cfset arrReplaces=arraynew(2)>
		<cfset arrReplaces[1][1]="Aacute"><cfset arrReplaces[1][2]="193"><!--- Latin capital letter A with acute --->
		<cfset arrReplaces[2][1]="aacute"><cfset arrReplaces[2][2]="225"><!--- Latin small letter a with acute --->
		<cfset arrReplaces[3][1]="Acirc"><cfset arrReplaces[3][2]="194"><!--- Latin capital letter A with circumflex --->
		<cfset arrReplaces[4][1]="acirc"><cfset arrReplaces[4][2]="226"><!--- Latin small letter a with circumflex --->
		<cfset arrReplaces[5][1]="acute"><cfset arrReplaces[5][2]="180"><!--- acute accent (= spacing acute) --->
		<cfset arrReplaces[6][1]="AElig"><cfset arrReplaces[6][2]="198"><!--- Latin capital letter AE (= Latin capital ligature AE) --->
		<cfset arrReplaces[7][1]="aelig"><cfset arrReplaces[7][2]="230"><!--- Latin small letter ae (= Latin small ligature ae) --->
		<cfset arrReplaces[8][1]="Agrave"><cfset arrReplaces[8][2]="192"><!--- Latin capital letter A with grave (= Latin capital letter A grave) --->
		<cfset arrReplaces[9][1]="agrave"><cfset arrReplaces[9][2]="224"><!--- Latin small letter a with grave --->
		<cfset arrReplaces[10][1]="alefsym"><cfset arrReplaces[10][2]="8501"><!--- alef symbol (= first transfinite cardinal)[13] --->
		<cfset arrReplaces[11][1]="Alpha"><cfset arrReplaces[11][2]="913"><!--- Greek capital letter Alpha --->
		<cfset arrReplaces[12][1]="alpha"><cfset arrReplaces[12][2]="945"><!--- Greek small letter alpha --->
		<cfset arrReplaces[13][1]="amp"><cfset arrReplaces[13][2]="38"><!--- ampersand --->
		<cfset arrReplaces[14][1]="and"><cfset arrReplaces[14][2]="8743"><!--- logical and (= wedge) --->
		<cfset arrReplaces[15][1]="ang"><cfset arrReplaces[15][2]="8736"><!--- angle --->
		<cfset arrReplaces[16][1]="apos"><cfset arrReplaces[16][2]="39"><!--- apostrophe (= apostrophe-quote); see below --->
		<cfset arrReplaces[17][1]="Aring"><cfset arrReplaces[17][2]="197"><!--- Latin capital letter A with ring above (= Latin capital letter A ring) --->
		<cfset arrReplaces[18][1]="aring"><cfset arrReplaces[18][2]="229"><!--- Latin small letter a with ring above --->
		<cfset arrReplaces[19][1]="asymp"><cfset arrReplaces[19][2]="8776"><!--- almost equal to (= asymptotic to) --->
		<cfset arrReplaces[20][1]="Atilde"><cfset arrReplaces[20][2]="195"><!--- Latin capital letter A with tilde --->
		<cfset arrReplaces[21][1]="atilde"><cfset arrReplaces[21][2]="227"><!--- Latin small letter a with tilde --->
		<cfset arrReplaces[22][1]="Auml"><cfset arrReplaces[22][2]="196"><!--- Latin capital letter A with diaeresis --->
		<cfset arrReplaces[23][1]="auml"><cfset arrReplaces[23][2]="228"><!--- Latin small letter a with diaeresis --->
		<cfset arrReplaces[24][1]="bdquo"><cfset arrReplaces[24][2]="8222"><!--- double low-9 quotation mark --->
		<cfset arrReplaces[25][1]="Beta"><cfset arrReplaces[25][2]="914"><!--- Greek capital letter Beta --->
		<cfset arrReplaces[26][1]="beta"><cfset arrReplaces[26][2]="946"><!--- Greek small letter beta --->
		<cfset arrReplaces[27][1]="brvbar"><cfset arrReplaces[27][2]="166"><!--- broken bar (= broken vertical bar) --->
		<cfset arrReplaces[28][1]="bull"><cfset arrReplaces[28][2]="8226"><!--- bullet (= black small circle)[10] --->
		<cfset arrReplaces[29][1]="cap"><cfset arrReplaces[29][2]="8745"><!--- intersection (= cap) --->
		<cfset arrReplaces[30][1]="Ccedil"><cfset arrReplaces[30][2]="199"><!--- Latin capital letter C with cedilla --->
		<cfset arrReplaces[31][1]="ccedil"><cfset arrReplaces[31][2]="231"><!--- Latin small letter c with cedilla --->
		<cfset arrReplaces[32][1]="cedil"><cfset arrReplaces[32][2]="184"><!--- cedilla (= spacing cedilla) --->
		<cfset arrReplaces[33][1]="cent"><cfset arrReplaces[33][2]="162"><!--- cent sign --->
		<cfset arrReplaces[34][1]="Chi"><cfset arrReplaces[34][2]="935"><!--- Greek capital letter Chi --->
		<cfset arrReplaces[35][1]="chi"><cfset arrReplaces[35][2]="967"><!--- Greek small letter chi --->
		<cfset arrReplaces[36][1]="circ"><cfset arrReplaces[36][2]="710"><!--- modifier letter circumflex accent --->
		<cfset arrReplaces[37][1]="clubs"><cfset arrReplaces[37][2]="9827"><!--- black club suit (= shamrock)[25] --->
		<cfset arrReplaces[38][1]="cong"><cfset arrReplaces[38][2]="8773"><!--- congruent to --->
		<cfset arrReplaces[39][1]="copy"><cfset arrReplaces[39][2]="169"><!--- copyright sign --->
		<cfset arrReplaces[40][1]="crarr"><cfset arrReplaces[40][2]="8629"><!--- downwards arrow with corner leftwards (= carriage return) --->
		<cfset arrReplaces[41][1]="cup"><cfset arrReplaces[41][2]="8746"><!--- union (= cup) --->
		<cfset arrReplaces[42][1]="curren"><cfset arrReplaces[42][2]="164"><!--- currency sign --->
		<cfset arrReplaces[43][1]="dagger"><cfset arrReplaces[43][2]="8224"><!--- dagger --->
		<cfset arrReplaces[44][1]="Dagger"><cfset arrReplaces[44][2]="8225"><!--- double dagger --->
		<cfset arrReplaces[45][1]="darr"><cfset arrReplaces[45][2]="8595"><!--- downwards arrow --->
		<cfset arrReplaces[46][1]="dArr"><cfset arrReplaces[46][2]="8659"><!--- downwards double arrow --->
		<cfset arrReplaces[47][1]="deg"><cfset arrReplaces[47][2]="176"><!--- degree sign --->
		<cfset arrReplaces[48][1]="Delta"><cfset arrReplaces[48][2]="916"><!--- Greek capital letter Delta --->
		<cfset arrReplaces[49][1]="delta"><cfset arrReplaces[49][2]="948"><!--- Greek small letter delta --->
		<cfset arrReplaces[50][1]="diams"><cfset arrReplaces[50][2]="9830"><!--- black diamond suit[27] --->
		<cfset arrReplaces[51][1]="divide"><cfset arrReplaces[51][2]="247"><!--- division sign --->
		<cfset arrReplaces[52][1]="Eacute"><cfset arrReplaces[52][2]="201"><!--- Latin capital letter E with acute --->
		<cfset arrReplaces[53][1]="eacute"><cfset arrReplaces[53][2]="233"><!--- Latin small letter e with acute --->
		<cfset arrReplaces[54][1]="Ecirc"><cfset arrReplaces[54][2]="202"><!--- Latin capital letter E with circumflex --->
		<cfset arrReplaces[55][1]="ecirc"><cfset arrReplaces[55][2]="234"><!--- Latin small letter e with circumflex --->
		<cfset arrReplaces[56][1]="Egrave"><cfset arrReplaces[56][2]="200"><!--- Latin capital letter E with grave --->
		<cfset arrReplaces[57][1]="egrave"><cfset arrReplaces[57][2]="232"><!--- Latin small letter e with grave --->
		<cfset arrReplaces[58][1]="empty"><cfset arrReplaces[58][2]="8709"><!--- empty set (= null set = diameter) --->
		<cfset arrReplaces[59][1]="emsp"><cfset arrReplaces[59][2]="8195"><!--- em space[8] --->
		<cfset arrReplaces[60][1]="ensp"><cfset arrReplaces[60][2]="8194"><!--- en space[7] --->
		<cfset arrReplaces[61][1]="Epsilon"><cfset arrReplaces[61][2]="917"><!--- Greek capital letter Epsilon --->
		<cfset arrReplaces[62][1]="epsilon"><cfset arrReplaces[62][2]="949"><!--- Greek small letter epsilon --->
		<cfset arrReplaces[63][1]="equiv"><cfset arrReplaces[63][2]="8801"><!--- identical to; sometimes used for 'equivalent to' --->
		<cfset arrReplaces[64][1]="Eta"><cfset arrReplaces[64][2]="919"><!--- Greek capital letter Eta --->
		<cfset arrReplaces[65][1]="eta"><cfset arrReplaces[65][2]="951"><!--- Greek small letter eta --->
		<cfset arrReplaces[66][1]="ETH"><cfset arrReplaces[66][2]="208"><!--- Latin capital letter ETH --->
		<cfset arrReplaces[67][1]="eth"><cfset arrReplaces[67][2]="240"><!--- Latin small letter eth --->
		<cfset arrReplaces[68][1]="Euml"><cfset arrReplaces[68][2]="203"><!--- Latin capital letter E with diaeresis --->
		<cfset arrReplaces[69][1]="euml"><cfset arrReplaces[69][2]="235"><!--- Latin small letter e with diaeresis --->
		<cfset arrReplaces[70][1]="euro"><cfset arrReplaces[70][2]="8364"><!--- euro sign --->
		<cfset arrReplaces[71][1]="exist"><cfset arrReplaces[71][2]="8707"><!--- there exists --->
		<cfset arrReplaces[72][1]="fnof"><cfset arrReplaces[72][2]="402"><!--- Latin small letter f with hook (= function = florin) --->
		<cfset arrReplaces[73][1]="forall"><cfset arrReplaces[73][2]="8704"><!--- for all --->
		<cfset arrReplaces[74][1]="frac12"><cfset arrReplaces[74][2]="189"><!--- vulgar fraction one half (= fraction one half) --->
		<cfset arrReplaces[75][1]="frac14"><cfset arrReplaces[75][2]="188"><!--- vulgar fraction one quarter (= fraction one quarter) --->
		<cfset arrReplaces[76][1]="frac34"><cfset arrReplaces[76][2]="190"><!--- vulgar fraction three quarters (= fraction three quarters) --->
		<cfset arrReplaces[77][1]="frasl"><cfset arrReplaces[77][2]="8260"><!--- fraction slash (= solidus) --->
		<cfset arrReplaces[78][1]="Gamma"><cfset arrReplaces[78][2]="915"><!--- Greek capital letter Gamma --->
		<cfset arrReplaces[79][1]="gamma"><cfset arrReplaces[79][2]="947"><!--- Greek small letter gamma --->
		<cfset arrReplaces[80][1]="ge"><cfset arrReplaces[80][2]="8805"><!--- greater-than or equal to --->
		<cfset arrReplaces[81][1]="gt"><cfset arrReplaces[81][2]="62"><!--- greater-than sign --->
		<cfset arrReplaces[82][1]="harr"><cfset arrReplaces[82][2]="8596"><!--- left right arrow --->
		<cfset arrReplaces[83][1]="hArr"><cfset arrReplaces[83][2]="8660"><!--- left right double arrow --->
		<cfset arrReplaces[84][1]="hearts"><cfset arrReplaces[84][2]="9829"><!--- black heart suit (= valentine)[26] --->
		<cfset arrReplaces[85][1]="hellip"><cfset arrReplaces[85][2]="8230"><!--- horizontal ellipsis (= three dot leader) --->
		<cfset arrReplaces[86][1]="Iacute"><cfset arrReplaces[86][2]="205"><!--- Latin capital letter I with acute --->
		<cfset arrReplaces[87][1]="iacute"><cfset arrReplaces[87][2]="237"><!--- Latin small letter i with acute --->
		<cfset arrReplaces[88][1]="Icirc"><cfset arrReplaces[88][2]="206"><!--- Latin capital letter I with circumflex --->
		<cfset arrReplaces[89][1]="icirc"><cfset arrReplaces[89][2]="238"><!--- Latin small letter i with circumflex --->
		<cfset arrReplaces[90][1]="iexcl"><cfset arrReplaces[90][2]="161"><!--- inverted exclamation mark --->
		<cfset arrReplaces[91][1]="Igrave"><cfset arrReplaces[91][2]="204"><!--- Latin capital letter I with grave --->
		<cfset arrReplaces[92][1]="igrave"><cfset arrReplaces[92][2]="236"><!--- Latin small letter i with grave --->
		<cfset arrReplaces[93][1]="image"><cfset arrReplaces[93][2]="8465"><!--- black-letter capital I (= imaginary part) --->
		<cfset arrReplaces[94][1]="infin"><cfset arrReplaces[94][2]="8734"><!--- infinity --->
		<cfset arrReplaces[95][1]="int"><cfset arrReplaces[95][2]="8747"><!--- integral --->
		<cfset arrReplaces[96][1]="Iota"><cfset arrReplaces[96][2]="921"><!--- Greek capital letter Iota --->
		<cfset arrReplaces[97][1]="iota"><cfset arrReplaces[97][2]="953"><!--- Greek small letter iota --->
		<cfset arrReplaces[98][1]="iquest"><cfset arrReplaces[98][2]="191"><!--- inverted question mark (= turned question mark) --->
		<cfset arrReplaces[99][1]="isin"><cfset arrReplaces[99][2]="8712"><!--- element of --->
		<cfset arrReplaces[100][1]="Iuml"><cfset arrReplaces[100][2]="207"><!--- Latin capital letter I with diaeresis --->
		<cfset arrReplaces[101][1]="iuml"><cfset arrReplaces[101][2]="239"><!--- Latin small letter i with diaeresis --->
		<cfset arrReplaces[102][1]="Kappa"><cfset arrReplaces[102][2]="922"><!--- Greek capital letter Kappa --->
		<cfset arrReplaces[103][1]="kappa"><cfset arrReplaces[103][2]="954"><!--- Greek small letter kappa --->
		<cfset arrReplaces[104][1]="Lambda"><cfset arrReplaces[104][2]="923"><!--- Greek capital letter Lambda --->
		<cfset arrReplaces[105][1]="lambda"><cfset arrReplaces[105][2]="955"><!--- Greek small letter lambda --->
		<cfset arrReplaces[106][1]="lang"><cfset arrReplaces[106][2]="9001"><!--- left-pointing angle bracket (= bra)[22] --->
		<cfset arrReplaces[107][1]="laquo"><cfset arrReplaces[107][2]="171"><!--- left-pointing double angle quotation mark (= left pointing guillemet) --->
		<cfset arrReplaces[108][1]="larr"><cfset arrReplaces[108][2]="8592"><!--- leftwards arrow --->
		<cfset arrReplaces[109][1]="lArr"><cfset arrReplaces[109][2]="8656"><!--- leftwards double arrow[14] --->
		<cfset arrReplaces[110][1]="lceil"><cfset arrReplaces[110][2]="8968"><!--- left ceiling (= APL upstile) --->
		<cfset arrReplaces[111][1]="ldquo"><cfset arrReplaces[111][2]="8220"><!--- left double quotation mark --->
		<cfset arrReplaces[112][1]="le"><cfset arrReplaces[112][2]="8804"><!--- less-than or equal to --->
		<cfset arrReplaces[113][1]="lfloor"><cfset arrReplaces[113][2]="8970"><!--- left floor (= APL downstile) --->
		<cfset arrReplaces[114][1]="lowast"><cfset arrReplaces[114][2]="8727"><!--- asterisk operator --->
		<cfset arrReplaces[115][1]="loz"><cfset arrReplaces[115][2]="9674"><!--- lozenge --->
		<cfset arrReplaces[116][1]="lrm"><cfset arrReplaces[116][2]="8206"><!--- left-to-right mark --->
		<cfset arrReplaces[117][1]="lsaquo"><cfset arrReplaces[117][2]="8249"><!--- single left-pointing angle quotation mark[11] --->
		<cfset arrReplaces[118][1]="lsquo"><cfset arrReplaces[118][2]="8216"><!--- left single quotation mark --->
		<cfset arrReplaces[119][1]="lt"><cfset arrReplaces[119][2]="60"><!--- less-than sign --->
		<cfset arrReplaces[120][1]="macr"><cfset arrReplaces[120][2]="175"><!--- macron (= spacing macron = overline = APL overbar) --->
		<cfset arrReplaces[121][1]="mdash"><cfset arrReplaces[121][2]="8212"><!--- em dash --->
		<cfset arrReplaces[122][1]="micro"><cfset arrReplaces[122][2]="181"><!--- micro sign --->
		<cfset arrReplaces[123][1]="middot"><cfset arrReplaces[123][2]="183"><!--- middle dot (= Georgian comma = Greek middle dot) --->
		<cfset arrReplaces[124][1]="minus"><cfset arrReplaces[124][2]="8722"><!--- minus sign --->
		<cfset arrReplaces[125][1]="Mu"><cfset arrReplaces[125][2]="924"><!--- Greek capital letter Mu --->
		<cfset arrReplaces[126][1]="mu"><cfset arrReplaces[126][2]="956"><!--- Greek small letter mu --->
		<cfset arrReplaces[127][1]="nabla"><cfset arrReplaces[127][2]="8711"><!--- nabla (= backward difference) --->
		<cfset arrReplaces[128][1]="nbsp"><cfset arrReplaces[128][2]="160"><!--- no-break space (= non-breaking space)[4] --->
		<cfset arrReplaces[129][1]="ndash"><cfset arrReplaces[129][2]="8211"><!--- en dash --->
		<cfset arrReplaces[130][1]="ne"><cfset arrReplaces[130][2]="8800"><!--- not equal to --->
		<cfset arrReplaces[131][1]="ni"><cfset arrReplaces[131][2]="8715"><!--- contains as member --->
		<cfset arrReplaces[132][1]="not"><cfset arrReplaces[132][2]="172"><!--- not sign --->
		<cfset arrReplaces[133][1]="notin"><cfset arrReplaces[133][2]="8713"><!--- not an element of --->
		<cfset arrReplaces[134][1]="nsub"><cfset arrReplaces[134][2]="8836"><!--- not a subset of --->
		<cfset arrReplaces[135][1]="Ntilde"><cfset arrReplaces[135][2]="209"><!--- Latin capital letter N with tilde --->
		<cfset arrReplaces[136][1]="ntilde"><cfset arrReplaces[136][2]="241"><!--- Latin small letter n with tilde --->
		<cfset arrReplaces[137][1]="Nu"><cfset arrReplaces[137][2]="925"><!--- Greek capital letter Nu --->
		<cfset arrReplaces[138][1]="nu"><cfset arrReplaces[138][2]="957"><!--- Greek small letter nu --->
		<cfset arrReplaces[139][1]="Oacute"><cfset arrReplaces[139][2]="211"><!--- Latin capital letter O with acute --->
		<cfset arrReplaces[140][1]="oacute"><cfset arrReplaces[140][2]="243"><!--- Latin small letter o with acute --->
		<cfset arrReplaces[141][1]="Ocirc"><cfset arrReplaces[141][2]="212"><!--- Latin capital letter O with circumflex --->
		<cfset arrReplaces[142][1]="ocirc"><cfset arrReplaces[142][2]="244"><!--- Latin small letter o with circumflex --->
		<cfset arrReplaces[143][1]="OElig"><cfset arrReplaces[143][2]="338"><!--- Latin capital ligature oe[5] --->
		<cfset arrReplaces[144][1]="oelig"><cfset arrReplaces[144][2]="339"><!--- Latin small ligature oe[6] --->
		<cfset arrReplaces[145][1]="Ograve"><cfset arrReplaces[145][2]="210"><!--- Latin capital letter O with grave --->
		<cfset arrReplaces[146][1]="ograve"><cfset arrReplaces[146][2]="242"><!--- Latin small letter o with grave --->
		<cfset arrReplaces[147][1]="oline"><cfset arrReplaces[147][2]="8254"><!--- overline (= spacing overscore) --->
		<cfset arrReplaces[148][1]="Omega"><cfset arrReplaces[148][2]="937"><!--- Greek capital letter Omega --->
		<cfset arrReplaces[149][1]="omega"><cfset arrReplaces[149][2]="969"><!--- Greek small letter omega --->
		<cfset arrReplaces[150][1]="Omicron"><cfset arrReplaces[150][2]="927"><!--- Greek capital letter Omicron --->
		<cfset arrReplaces[151][1]="omicron"><cfset arrReplaces[151][2]="959"><!--- Greek small letter omicron --->
		<cfset arrReplaces[152][1]="oplus"><cfset arrReplaces[152][2]="8853"><!--- circled plus (= direct sum) --->
		<cfset arrReplaces[153][1]="or"><cfset arrReplaces[153][2]="8744"><!--- logical or (= vee) --->
		<cfset arrReplaces[154][1]="ordf"><cfset arrReplaces[154][2]="170"><!--- feminine ordinal indicator --->
		<cfset arrReplaces[155][1]="ordm"><cfset arrReplaces[155][2]="186"><!--- masculine ordinal indicator --->
		<cfset arrReplaces[156][1]="Oslash"><cfset arrReplaces[156][2]="216"><!--- Latin capital letter O with stroke (= Latin capital letter O slash) --->
		<cfset arrReplaces[157][1]="oslash"><cfset arrReplaces[157][2]="248"><!--- Latin small letter o with stroke (= Latin small letter o slash) --->
		<cfset arrReplaces[158][1]="Otilde"><cfset arrReplaces[158][2]="213"><!--- Latin capital letter O with tilde --->
		<cfset arrReplaces[159][1]="otilde"><cfset arrReplaces[159][2]="245"><!--- Latin small letter o with tilde --->
		<cfset arrReplaces[160][1]="otimes"><cfset arrReplaces[160][2]="8855"><!--- circled times (= vector product) --->
		<cfset arrReplaces[161][1]="Ouml"><cfset arrReplaces[161][2]="214"><!--- Latin capital letter O with diaeresis --->
		<cfset arrReplaces[162][1]="ouml"><cfset arrReplaces[162][2]="246"><!--- Latin small letter o with diaeresis --->
		<cfset arrReplaces[163][1]="para"><cfset arrReplaces[163][2]="182"><!--- pilcrow sign ( = paragraph sign) --->
		<cfset arrReplaces[164][1]="part"><cfset arrReplaces[164][2]="8706"><!--- partial differential --->
		<cfset arrReplaces[165][1]="permil"><cfset arrReplaces[165][2]="8240"><!--- per mille sign --->
		<cfset arrReplaces[166][1]="perp"><cfset arrReplaces[166][2]="8869"><!--- up tack (= orthogonal to = perpendicular)[20] --->
		<cfset arrReplaces[167][1]="Phi"><cfset arrReplaces[167][2]="934"><!--- Greek capital letter Phi --->
		<cfset arrReplaces[168][1]="phi"><cfset arrReplaces[168][2]="966"><!--- Greek small letter phi --->
		<cfset arrReplaces[169][1]="Pi"><cfset arrReplaces[169][2]="928"><!--- Greek capital letter Pi --->
		<cfset arrReplaces[170][1]="pi"><cfset arrReplaces[170][2]="960"><!--- Greek small letter pi --->
		<cfset arrReplaces[171][1]="piv"><cfset arrReplaces[171][2]="982"><!--- Greek pi symbol --->
		<cfset arrReplaces[172][1]="plusmn"><cfset arrReplaces[172][2]="177"><!--- plus-minus sign (= plus-or-minus sign) --->
		<cfset arrReplaces[173][1]="pound"><cfset arrReplaces[173][2]="163"><!--- pound sign --->
		<cfset arrReplaces[174][1]="prime"><cfset arrReplaces[174][2]="8242"><!--- prime (= minutes = feet) --->
		<cfset arrReplaces[175][1]="Prime"><cfset arrReplaces[175][2]="8243"><!--- double prime (= seconds = inches) --->
		<cfset arrReplaces[176][1]="prod"><cfset arrReplaces[176][2]="8719"><!--- n-ary product (= product sign)[16] --->
		<cfset arrReplaces[177][1]="prop"><cfset arrReplaces[177][2]="8733"><!--- proportional to --->
		<cfset arrReplaces[178][1]="Psi"><cfset arrReplaces[178][2]="936"><!--- Greek capital letter Psi --->
		<cfset arrReplaces[179][1]="psi"><cfset arrReplaces[179][2]="968"><!--- Greek small letter psi --->
		<cfset arrReplaces[180][1]="quot"><cfset arrReplaces[180][2]="34"><!--- quotation mark (= APL quote) --->
		<cfset arrReplaces[181][1]="radic"><cfset arrReplaces[181][2]="8730"><!--- square root (= radical sign) --->
		<cfset arrReplaces[182][1]="rang"><cfset arrReplaces[182][2]="9002"><!--- right-pointing angle bracket (= ket)[23] --->
		<cfset arrReplaces[183][1]="raquo"><cfset arrReplaces[183][2]="187"><!--- right-pointing double angle quotation mark (= right pointing guillemet) --->
		<cfset arrReplaces[184][1]="rarr"><cfset arrReplaces[184][2]="8594"><!--- rightwards arrow --->
		<cfset arrReplaces[185][1]="rArr"><cfset arrReplaces[185][2]="8658"><!--- rightwards double arrow[15] --->
		<cfset arrReplaces[186][1]="rceil"><cfset arrReplaces[186][2]="8969"><!--- right ceiling --->
		<cfset arrReplaces[187][1]="rdquo"><cfset arrReplaces[187][2]="8221"><!--- right double quotation mark --->
		<cfset arrReplaces[188][1]="real"><cfset arrReplaces[188][2]="8476"><!--- black-letter capital R (= real part symbol) --->
		<cfset arrReplaces[189][1]="reg"><cfset arrReplaces[189][2]="174"><!--- registered sign ( = registered trade mark sign) --->
		<cfset arrReplaces[190][1]="rfloor"><cfset arrReplaces[190][2]="8971"><!--- right floor --->
		<cfset arrReplaces[191][1]="Rho"><cfset arrReplaces[191][2]="929"><!--- Greek capital letter Rho --->
		<cfset arrReplaces[192][1]="rho"><cfset arrReplaces[192][2]="961"><!--- Greek small letter rho --->
		<cfset arrReplaces[193][1]="rlm"><cfset arrReplaces[193][2]="8207"><!--- right-to-left mark --->
		<cfset arrReplaces[194][1]="rsaquo"><cfset arrReplaces[194][2]="8250"><!--- single right-pointing angle quotation mark[12] --->
		<cfset arrReplaces[195][1]="rsquo"><cfset arrReplaces[195][2]="8217"><!--- right single quotation mark --->
		<cfset arrReplaces[196][1]="sbquo"><cfset arrReplaces[196][2]="8218"><!--- single low-9 quotation mark --->
		<cfset arrReplaces[197][1]="Scaron"><cfset arrReplaces[197][2]="352"><!--- Latin capital letter s with caron --->
		<cfset arrReplaces[198][1]="scaron"><cfset arrReplaces[198][2]="353"><!--- Latin small letter s with caron --->
		<cfset arrReplaces[199][1]="sdot"><cfset arrReplaces[199][2]="8901"><!--- dot operator[21] --->
		<cfset arrReplaces[200][1]="sect"><cfset arrReplaces[200][2]="167"><!--- section sign --->
		<cfset arrReplaces[201][1]="shy"><cfset arrReplaces[201][2]="173"><!--- soft hyphen (= discretionary hyphen) --->
		<cfset arrReplaces[202][1]="Sigma"><cfset arrReplaces[202][2]="931"><!--- Greek capital letter Sigma --->
		<cfset arrReplaces[203][1]="sigma"><cfset arrReplaces[203][2]="963"><!--- Greek small letter sigma --->
		<cfset arrReplaces[204][1]="sigmaf"><cfset arrReplaces[204][2]="962"><!--- Greek small letter final sigma --->
		<cfset arrReplaces[205][1]="sim"><cfset arrReplaces[205][2]="8764"><!--- tilde operator (= varies with = similar to)[18] --->
		<cfset arrReplaces[206][1]="spades"><cfset arrReplaces[206][2]="9824"><!--- black spade suit[24] --->
		<cfset arrReplaces[207][1]="sub"><cfset arrReplaces[207][2]="8834"><!--- subset of --->
		<cfset arrReplaces[208][1]="sube"><cfset arrReplaces[208][2]="8838"><!--- subset of or equal to --->
		<cfset arrReplaces[209][1]="sum"><cfset arrReplaces[209][2]="8721"><!--- n-ary summation[17] --->
		<cfset arrReplaces[210][1]="sup"><cfset arrReplaces[210][2]="8835"><!--- superset of[19] --->
		<cfset arrReplaces[211][1]="sup1"><cfset arrReplaces[211][2]="185"><!--- superscript one (= superscript digit one) --->
		<cfset arrReplaces[212][1]="sup2"><cfset arrReplaces[212][2]="178"><!--- superscript two (= superscript digit two = squared) --->
		<cfset arrReplaces[213][1]="sup3"><cfset arrReplaces[213][2]="179"><!--- superscript three (= superscript digit three = cubed) --->
		<cfset arrReplaces[214][1]="supe"><cfset arrReplaces[214][2]="8839"><!--- superset of or equal to --->
		<cfset arrReplaces[215][1]="szlig"><cfset arrReplaces[215][2]="223"><!--- Latin small letter sharp s (= ess-zed); see German Eszett --->
		<cfset arrReplaces[216][1]="Tau"><cfset arrReplaces[216][2]="932"><!--- Greek capital letter Tau --->
		<cfset arrReplaces[217][1]="tau"><cfset arrReplaces[217][2]="964"><!--- Greek small letter tau --->
		<cfset arrReplaces[218][1]="there4"><cfset arrReplaces[218][2]="8756"><!--- therefore --->
		<cfset arrReplaces[219][1]="Theta"><cfset arrReplaces[219][2]="920"><!--- Greek capital letter Theta --->
		<cfset arrReplaces[220][1]="theta"><cfset arrReplaces[220][2]="952"><!--- Greek small letter theta --->
		<cfset arrReplaces[221][1]="thetasym"><cfset arrReplaces[221][2]="977"><!--- Greek theta symbol --->
		<cfset arrReplaces[222][1]="thinsp"><cfset arrReplaces[222][2]="8201"><!--- thin space[9] --->
		<cfset arrReplaces[223][1]="THORN"><cfset arrReplaces[223][2]="222"><!--- Latin capital letter THORN --->
		<cfset arrReplaces[224][1]="thorn"><cfset arrReplaces[224][2]="254"><!--- Latin small letter thorn --->
		<cfset arrReplaces[225][1]="tilde"><cfset arrReplaces[225][2]="732"><!--- small tilde --->
		<cfset arrReplaces[226][1]="times"><cfset arrReplaces[226][2]="215"><!--- multiplication sign --->
		<cfset arrReplaces[227][1]="trade"><cfset arrReplaces[227][2]="8482"><!--- trademark sign --->
		<cfset arrReplaces[228][1]="Uacute"><cfset arrReplaces[228][2]="218"><!--- Latin capital letter U with acute --->
		<cfset arrReplaces[229][1]="uacute"><cfset arrReplaces[229][2]="250"><!--- Latin small letter u with acute --->
		<cfset arrReplaces[230][1]="uarr"><cfset arrReplaces[230][2]="8593"><!--- upwards arrow --->
		<cfset arrReplaces[231][1]="uArr"><cfset arrReplaces[231][2]="8657"><!--- upwards double arrow --->
		<cfset arrReplaces[232][1]="Ucirc"><cfset arrReplaces[232][2]="219"><!--- Latin capital letter U with circumflex --->
		<cfset arrReplaces[233][1]="ucirc"><cfset arrReplaces[233][2]="251"><!--- Latin small letter u with circumflex --->
		<cfset arrReplaces[234][1]="Ugrave"><cfset arrReplaces[234][2]="217"><!--- Latin capital letter U with grave --->
		<cfset arrReplaces[235][1]="ugrave"><cfset arrReplaces[235][2]="249"><!--- Latin small letter u with grave --->
		<cfset arrReplaces[236][1]="uml"><cfset arrReplaces[236][2]="168"><!--- diaeresis (= spacing diaeresis); see German umlaut --->
		<cfset arrReplaces[237][1]="upsih"><cfset arrReplaces[237][2]="978"><!--- Greek Upsilon with hook symbol --->
		<cfset arrReplaces[238][1]="Upsilon"><cfset arrReplaces[238][2]="933"><!--- Greek capital letter Upsilon --->
		<cfset arrReplaces[239][1]="upsilon"><cfset arrReplaces[239][2]="965"><!--- Greek small letter upsilon --->
		<cfset arrReplaces[240][1]="Uuml"><cfset arrReplaces[240][2]="220"><!--- Latin capital letter U with diaeresis --->
		<cfset arrReplaces[241][1]="uuml"><cfset arrReplaces[241][2]="252"><!--- Latin small letter u with diaeresis --->
		<cfset arrReplaces[242][1]="weierp"><cfset arrReplaces[242][2]="8472"><!--- script capital P (= power set = Weierstrass p) --->
		<cfset arrReplaces[243][1]="Xi"><cfset arrReplaces[243][2]="926"><!--- Greek capital letter Xi --->
		<cfset arrReplaces[244][1]="xi"><cfset arrReplaces[244][2]="958"><!--- Greek small letter xi --->
		<cfset arrReplaces[245][1]="Yacute"><cfset arrReplaces[245][2]="221"><!--- Latin capital letter Y with acute --->
		<cfset arrReplaces[246][1]="yacute"><cfset arrReplaces[246][2]="253"><!--- Latin small letter y with acute --->
		<cfset arrReplaces[247][1]="yen"><cfset arrReplaces[247][2]="165"><!--- yen sign (= yuan sign) --->
		<cfset arrReplaces[248][1]="yuml"><cfset arrReplaces[248][2]="255"><!--- Latin small letter y with diaeresis --->
		<cfset arrReplaces[249][1]="Yuml"><cfset arrReplaces[249][2]="376"><!--- Latin capital letter y with diaeresis --->
		<cfset arrReplaces[250][1]="Zeta"><cfset arrReplaces[250][2]="918"><!--- Greek capital letter Zeta --->
		<cfset arrReplaces[251][1]="zeta"><cfset arrReplaces[251][2]="950"><!--- Greek small letter zeta --->
		<cfset arrReplaces[252][1]="zwj"><cfset arrReplaces[252][2]="8205"><!--- zero-width joiner --->
		<cfset arrReplaces[253][1]="zwnj"><cfset arrReplaces[253][2]="8204"><!--- zero-width non-joiner --->
		
		<cfloop from="1" to="#arraylen(arrReplaces)#" index="i">
			<cfset t=replace(t,"&#arrReplaces[i][1]#;","&###arrReplaces[i][2]#;","all")>
		</cfloop>
		
		<cfreturn t>
		
	</cffunction>
	
</cfcomponent>