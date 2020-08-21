<cfsetting requesttimeout="1000">

<!--- get list of coaches with no logins --->
<cfquery datasource="#application.dsn#" name="getCoaches">
select b.contact_id, b.firstname, b.lastname, b.email, c.club_name, b.* from xref_contact_role a
inner join tbl_contact b
on a.contact_id=b.contact_id
inner join tbl_club c
on b.club_id=c.club_id
where role_id=29
and season_id=6
and (b.username is null OR b.username = '')
and b.approve_yn='Y'
</cfquery>

<!--- init new file --->
<cffile action="WRITE" file="#getdirectoryfrompath(GetBaseTemplatePath())#assets\coachUsernames.csv" output="Contact_id, First Name, Last Name, Email, Club, Username, Password" addnewline="Yes">

<cfloop query="getCoaches">
	<!--- create username --->
	<cfset newusername=left(firstname,1) & lastname>
	
	<!--- check availability --->
	<cfquery datasource="#application.dsn#" name="checkAvail">
		select contact_id
		from tbl_contact
		where username=<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#newusername#">
	</cfquery>
	<cfset inc=1>
	<cfloop condition="checkAvail.recordcount GT 0">
		<cfset newusername=left(firstname,1) & lastname & inc>
		<cfset inc = inc + 1>
		<!--- check availability --->
		<cfquery datasource="#application.dsn#" name="checkAvail">
			select contact_id
			from tbl_contact
			where username=<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#newusername#">
		</cfquery>
	</cfloop>
	
	<!--- create password --->
	<cf_dcRandomPass size="10" minNumbers=4 charSet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@##$%&*" outputVariable="newpassword">
	
<cfoutput>#contact_id#: #newusername#: #newpassword#<br></cfoutput>

<!--- write file --->
<cffile action="APPEND" file="#getdirectoryfrompath(GetBaseTemplatePath())#assets\coachUsernames.csv" output="#contact_id#,#firstname#,#lastname#,#email#,#club_name#,#newusername#,#newpassword#" addnewline="Yes">

<!--- update db --->
<cfquery datasource="#application.dsn#" name="checkAvail">
	update tbl_contact
	set username=<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#newusername#">,
	password=<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#newpassword#">
	where contact_id=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#contact_id#">
</cfquery>
	
<!--- email contact new credentials --->

<cftry>
<cfmail from="NCSA Administrator <edseavers@earthlink.net>" to="#email#" subject="Coach Login to NCSA Site" type="HTML">
Dear NCSA Coach #firstname# #lastname#, <BR><BR>

NCSA has upgraded its website to allow coaches to login for 3 required functions beginning with the Spring 2011 season.

<ol>
	<li>All scores must be reported through this login.</li>
	<li>The Match Day Form must be printed for each game by each team with all game information already inserted 
		into the form; you will be able to edit coach information for which coaches are participating and will be required 
		to list all players "playing up" under NCSA rules (only teams from which those players are permitted to play 
		up are included as options).
	</li>
	<li>Any match or referee evaluation comments must be filed online.</li>
</ol>
<br>
IMPORTANT NOTE:  Detailed instructions for each aspect will be included in an email to all coaches and posted on the NCSA coach's page.
<BR><BR>
Your User ID is: <b>#newusername#</b>
<BR><BR>
Your Password is <b>#newpassword#</b>
<BR><BR>
We suggest that you change your password to something easy for you to remember once you login.  
Please refer to the instructional email before asking for further help.  If you have difficulty logging in or accessing 
any functions, please email edseavers@earthlink.net.  If you have any other questions, please email your division commissioner.
<BR><BR>
Regards,<BR>
NCSA
</cfmail>
<cfcatch>FAILED EMAIL<br></cfcatch>
</cftry>
</cfloop>