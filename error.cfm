<cfif isdefined("cfcatch")>
	<cfset message=cfcatch.message>
<cfelse>
	<cfset message="An unknown error has occurred">
</cfif>


<!--- clear output buffer --->
<cfcontent reset="Yes">


<cfinclude template="_header.cfm">

<script language="JavaScript" type="text/javascript" src="assets/jquery-1.4.min.js"></script>
<script language="JavaScript" type="text/javascript">
	$(function(){
		$('#hideTrigger').toggle(function(){
			$('#hiddenMessage').show();
		},
		function(){
			$('#hiddenMessage').hide();
		});
	});
</script>
<cfoutput>
	<div class="error">
		<span id="hideTrigger">O</span>h no!  What happened?<br>
		#cfcatch.message#
		<br>
		<a style="font-size:.8em;" href="javascript:history.go(-1);">Click here to go back</a>
	</div>
	<div id="hiddenMessage" style="display:none;">
		<cfif isdefined("cfcatch")>
			<cfdump var=#cfcatch#>
		<cfelse>
			unknown
		</cfif>
	</div>
</cfoutput>


<cfabort>