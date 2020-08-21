<!------------------------------------------
  NCSA Error Handling
  author: A.Pinzone
  created: 11/14/2017

  Modifications
--------------------------------------------->
<cfinclude template="/_header.cfm">

	<cfsavecontent variable="custom_styles">
		<style type="text/css">
			body:before {background-image: url(/assets/images/lonelyBoy.jpg);}
			#contentText { background-color: rgba(255,255,255,0.75); }
			.page-list { margin: 15px 0; }
			.page-list li { position: relative;font-size:18px;font-weight:300;padding:10px 0 5px 12px;}
			.page-list li:before {font-family:'FontAwesome';position:absolute;left:0;content:'\f105';}
		</style>
	</cfsavecontent>
	<cfhtmlhead text="#custom_styles#">


	<div id="contentText">

		<h1 class="pageheading">Red Card on the Field!</h1>
		<h2 class="subheading">We've encountered an error, perhaps one of these popular pages can help?</h2>

		<ul class="page-list">
			<li><a href="/clubTeams.cfm">Teams and Coaches</a></li>
			<li><a href="/gameSchedule.cfm?by=tm">Schedules &amp; Results</a></li>
			<li><a href="/standings.cfm">Standings</a></li>
			<li><a href="/contactUs.cfm">Contact Us</a></li>
			<li><a href="/faq.cfm">Frequently Asked Questions</a></li>
		</ul>

	</div>

<cfinclude template="/_footer.cfm">