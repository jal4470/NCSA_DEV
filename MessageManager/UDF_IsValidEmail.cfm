<!------------------------------>
<!--- Created 08.23.2004	 --->
<!--- P. Waters				 --->
<!--- LastMod: 				 --->
<!------------------------------>
<!--- CHECK EMAIL VALIDITY --->
<cffunction
   name = "isValidEmail"
   returnType = "numeric"
   output="no"
   Hint = "checks to see if an email address is valid">

	<cfargument name="email" required="Yes">

	<!--- Do checks --->
	<cfif email DOES NOT CONTAIN "@"
	   OR email DOES NOT CONTAIN "."
	   OR email CONTAINS " "
	   OR email CONTAINS "!"
	   OR email CONTAINS "##"
	   OR email CONTAINS "$"
	   OR email CONTAINS "%"
	   OR email CONTAINS "^"
	   OR email CONTAINS "&"
	   OR email CONTAINS "*"
	   OR email CONTAINS "("
	   OR email CONTAINS ")"
	   OR REPLACE(email,"@","","ONE") CONTAINS "@">
		<cfset outcome = 0>
	<cfelse>
		<cfset outcome = 1>
	</cfif>

	<CFRETURN outcome>
</cffunction>

