

<cfquery datasource="#application.dsn#" name="qry">
select top 500 family_name + ' Family' as name, 
	primary_address as address, 
	primary_city as city, 
	primary_state as state, 
	primary_zip5 as zip 
from tbl_family
</cfquery>

<cfreport format="PDF" template="avery5160.cfr" name="rptout" query="#qry#"></cfreport>


<!--- <cfoutput>#rptout#</cfoutput> --->
<cfheader name="Content-Disposition" value="filename=labels.pdf">
<cfcontent variable="#rptout#" type="application/pdf">