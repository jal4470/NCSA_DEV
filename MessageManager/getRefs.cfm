<script type="text/javascript">



function checkedOne(ele1,textBox1)
{

var out =  document.getElementById(ele1).id + ';' ; // replace this

var dummy = ""; // With this
var temp = document.getElementById(textBox1).value; // temporary holder

 if (!document.getElementById(ele1).checked)
 {
 	document.getElementById(ele1).checked = false;
	while (temp.indexOf(out)>-1) {
		pos= temp.indexOf(out);
		temp = "" + (temp.substring(0, pos) + dummy + 
		temp.substring((pos + out.length), temp.length));
		document.getElementById(textBox1).value = temp;
	}
}
else if(document.getElementById(ele1).checked)  {
	document.getElementById(ele1).checked = true;
	document.getElementById(textBox1).value = document.getElementById(textBox1).value + out;
	}
}

function checkedAll (All,ele,textBox) {
	var aa= document.getElementById('ele');
	 if (All.checked)
          {
           checked = true
          }
        else
          {
          checked = false
          }
	for (var i =0; i < ele.length; i++) 
	{
	 ele[i].checked = checked;
	 if(checked)
	 	document.getElementById(textBox).value = document.getElementById(textBox).value  + ele[i].id + ';';
	 else
	 	document.getElementById(textBox).value = '';
	}
  }
</script>

<cfquery name="getRefs" datasource="#application.dsn#">
select distinct r.Contact_id, FirstName, LastName, Email,xmc.contact_id as selected_contact_id,certified from v_referees_all r left  join xref_message_contact xmc on r.contact_id = xmc.contact_id 
and  message_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#iif(len(trim(message_id)), de(message_id), de(0))#">
where email is not null
order by lastName, firstName
</cfquery>

<tr><td><input type="Checkbox" name="contactAll" onclick="checkedAll(contactAll, contact, 'Text1');"></td><td colspan="4">ALL REFEREES</td></tr>
<cfoutput query="getRefs">
<tr>
	<td><input type="checkbox" name="contact" id="#Email#"  value="#contact_id#" onclick="checkedOne('#Email#','Text1');" <cfif len(trim(selected_contact_id))>Checked="true"</cfif>></td>
<td><cfif certified eq 'Y'><img src="assets\icons\Check.gif" width="10" border="0" align="center" alt="Certified" title="Certified"/><cfelse><img src="assets\icons\UnCheck.gif" width="10" border="0" align="center" alt="Not-Certified" title="Not-Certified"/></cfif>&nbsp;&nbsp;&nbsp;</td>
<td>#Contact_id#&nbsp;&nbsp;&nbsp;</td><td>#FirstName#</td><td>#LastName#</td><td>#Email#</td>
</tr>
</cfoutput>

