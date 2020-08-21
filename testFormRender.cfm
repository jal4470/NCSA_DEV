<cfsetting showdebugoutput="No">

<cfinclude template="_header.cfm">

		<cfset label_vars=structnew()>
		<cfset label_vars.ref_name="Ref Bob">
		<cfset label_vars.asst1ref_name="Asst ref 1 Jim">
		<cfset label_vars.asst2ref_name="asst ref 2 Frank">
		<cfmodule template="forms/renderForm.cfm" user_form_id="1" label_vars="#label_vars#">


<cfinclude template="_footer.cfm">