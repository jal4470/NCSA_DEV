		  </div><!--- #content.container --->
		</main><!--- #content --->

		<cfinclude template="_sidebar.cfm">

	</div><!--- #page_body.container --->
</div><!--- #page_body --->

<!--- 
12/03/08 - AA - CLUBMAINT temp shown, change to supress
			  - GAMEPRESEASCHED, logic added
01/09/09 - AA - Club Maintenance made permanent				
01/12/09 - AA - added toggles for PRE-SEASON ACTIVITIES
01/14/09 - AA - added link to Team Flighting. 
01/19/09 - AA - fixed counts for ref's new assignments
01/27/09 - AA - added cfc to get next season for the flighting link.
--->

<!--- =========================================================================================
START NAV BAR --->

<cfoutput>
<!--- pmid is OPTIONAL. It can either be passed via URL, or set as a variable before "_footer.cfm" is included. 
	  It is used to expand the side menu when something is selected  --->
<CFIF isDefined("URL.pmid")>
	<CFSET pmid = URL.pmid>
<CFELSEIF isDefined("SESSION.pmid")>
	<CFSET pmid = SESSION.pmid>
<CFELSE>
	<CFSET pmid = 0>
</CFIF>

<CFIF isDefined("VARIABLES.pmid") AND VARIABLES.pmid>
	<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
		<CFSET SESSION.pmid = pmid>
	</CFLOCK>
	<script language="JavaScript">
		// x = showMenu('privMenu#VARIABLES.pmid#','privItem#VARIABLES.pmid#','ul');
	</script>
</CFIF>
</cfoutput>



<!-- end navbar -->
<!---  ========================================================================================= --->


<!--- =============================
	start FOOTER --->

<!--- get PUBLIC MENU for BOTTOM of page --->
<CFIF NOT isDefined("SESSION.footerMenu") OR True>
	<cfinvoke component="#SESSION.sitevars.cfcPath#Menu" method="getPublicMenu" returnvariable="footerMenu">
		<cfinvokeargument name="DSN" value="#Application.DSN#">
		<cfinvokeargument name="isPublic" value="1">
		<cfinvokeargument name="location" value="3">
		<cfinvokeargument name="swGetChild" value="0">
	</cfinvoke>  <!--- <cfdump var="#publicMenu#"> --->
	<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
		<CFSET SESSION.footerMenu = footerMenu>
	</CFLOCK>
</CFIF>	
<footer id="page_footer">
	<cfoutput>
	<ul class="footer_menu">
	<CFLOOP query="SESSION.FOOTERMENU">
			<CFIF UCASE(listFirst(LOCATOR,".")) EQ "WWW">
				<cfset useHTTP = "//">
			<CFELSE>
				<cfset useHTTP = "">
			</CFIF>
			<li><a href="#useHTTP##LOCATOR#">#MENU_NAME#</a></li>
	</CFLOOP>
	</ul>
	</cfoutput>
	<div class="copyright">
		NCSA League Office, P.O. Box 26, Ho-Ho-Kus, NJ 07423 &copy; Northern Counties Soccer Association 1999-<cfoutput>#DateFormat(Now(),"YYYY")#</cfoutput> All Rights Reserved
	</div>

</footer>

<!--- END FOOTER
==================================== --->


<!--- =============================
	JAVASCRIPT --->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>

<script type="text/javascript">
	function recordOutboundLink(link, category, action, label) {
		try {
			ga('send', 'event', category, action, label);
		}catch(err){}
	}
</script>
<!--- END GOOGLE ANALYTICS CODE --->

<script src="assets/bxslider/jquery.bxslider.min.js"></script>
<script>
	// Ticker functionality is global
	$(document).ready(function(){
	  $('.news_list').bxSlider({
	    mode: 'horizontal',
	    auto: ($(".news_list li").length > 1) ? true: false,
	    controls: ($(".news_list li").length > 1) ? true: false,
	    pause: 2000,
	    speed: 10000,
	    pager: false,
	    nextSelector: '.ticker_right',
	    prevSelector: '.ticker_left',
	    nextText: '<i class="fa fa-caret-right" aria-hidden="true"></i>',
	    prevText: '<i class="fa fa-caret-left" aria-hidden="true"></i>'
	  });
	});
</script>

<cfinclude template="_universal_scripts.cfm">

<cfif isDefined("cf_footer_scripts")>
  <cfoutput>#cf_footer_scripts#</cfoutput>
</cfif>

<!--- =============================
	END OF PAGE --->
<!--- Desktop Indicator used in JS instead of trying to match media query and window.width() sizes, just check if this exists --->
<div id="desktop_indicator"></div> 
<div id="veil"></div>
</body>
</html>

<!--- DUMPS =================================================================================== --->
<CFIF ( isDefined("URL.DUMP") and URL.DUMP EQ 1 )
   OR ( UCASE(CGI.HTTP_HOST) EQ "NCSADEV.CAPTUREPOINT.COM")>
	<CFLOCK scope="SESSION" type="EXCLUSIVE" timeout="5">
		<CFSET SESSION.showdumps = 1>
	</CFLOCK>
</CFIF>

<CFIF isDefined("SESSION.showdumps") AND SESSION.showdumps>
	<br><HR>
	<br> APPLICATION:<CFIF isDefined("APPLICATION")> <cfdump var="#APPLICATION#" expand="No"><CFELSE> [empty] </CFIF>
	<br> SESSION: 	 <CFIF isDefined("SESSION")>	 <cfdump var="#SESSION#" expand="No">	 <CFELSE> [empty] </CFIF>
	<!--- <br> REQUEST: 	 <CFIF isDefined("REQUEST")>	 <cfdump var="#REQUEST#">	 <CFELSE> [empty] </CFIF> --->
	<br> FORM: 		 <CFIF isDefined("FORM")>		 <cfdump var="#FORM#" expand="No">		 <CFELSE> [empty] </CFIF>
	<!--- <br> VARIABLES:  <CFIF isDefined("VARIABLES")>	 <cfdump var="#VARIABLES#">	 <CFELSE> [empty] </CFIF> --->
</CFIF>


