<cfparam name="onload" DEFAULT="">

<script type="text/javascript" src="../../includes/jquery-1.6.4.min.js"></script>
<script type="text/javascript" src="../../includes/jquery-ui-1.8.16.custom.min.js"></script>




<html>
<head>
<title>SearchTec</title>

<link rel="stylesheet" type="text/css" href="../consult/loan_tracker.css">


<STYLE TYPE="text/css">

A:link {color:#2470C4; text-decoration: none}
A:visited {color:#2470C4; text-decoration: none}
A:hover {color:#2470C4; text-decoration: underline}
TD {
            FONT-SIZE: 12px; FONT-FAMILY: verdana
}
.sidelinks {
	FONT-SIZE: 10px; FONT-FAMILY: verdana;
	color:#000000; text-decoration: none}

	<!--
	.altTextField {
		border: #FFFFFF solid 0px;
		background-color: #FFFFFF;
		color: #006600;
		font-family: arial, verdana, ms sans serif;
		font-size: 10pt;
		}
	-->
	</STYLE>


<script>
$(function() {

$(".date-start").datepicker({dateFormat: "mm-dd-y"});
$(".date-start").datepicker("option", "dateFormat", "mm-dd-y");

});

$(function(){

$(".date-end").datepicker({dateFormat: "mm-dd-y"});
$(".date-end").datepicker("option", "dateFormat", "mm-dd-y");
$(".date-end").dataepicker('hide');
});

$(function(){

$("searchbar").tooltip();
$(".date-start").tooltip();
$(".date-end").tooltip();
$(".tracking_header-sub td").tooltip();
$(".count td").tooltip();
$("print-report").tooltip();
});



</script>
</head>
<body bgcolor="#FFFFFF" text="#003366" link="#0000FF" vlink="#000000" alink="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" <cfoutput>#onload#</cfoutput>>
<cfoutput>
<cfif #client.custscreen# is "T">
	<cfset search_page = "search_types_title.cfm">
<cfelse>
	<cfset search_page = "search_types.cfm">
</cfif>
</cfoutput>
<!-- <div style="position: absolute; left: 1000; top: 130;"><img src="/images/onguard_logo_250x32.png"></div> -->
<table width="1000" border="0" cellspacing="0" cellpadding="0" align="center"> 
    <tr> 
      <td width="999" valign="top">
        <table width="1000" border="0" cellspacing="0" cellpadding="0"> 
            <tr> 
                <td width="231">
                    <BR><BR><img src="/images/STLOGOREI.png">
                </td>
                <td width="548">&nbsp;</td> 
            </tr> 
            <tr bgcolor="#FFFFFF"> 
                <td colspan="2" valign="top">
                    <table width="1000" border="0" cellpadding="0" cellspacing="0"> 
                        <tr> 
                            <td width="970" align="left" valign="top">
                                <table border="0" cellspacing="0" cellpadding="4">
                                    <tr>
                                        <td style="background-color: #CECFD1;">
                                            <a href="/secure/search_types.cfm" style="text-decoration: none; color: #000000;">Home</a>
                                        </td>
                                        <td></td>
                                        <td style="background-color: #504B4B;">
                                            <a href="/secure/onguard/recording_reports.cfm" style="text-decoration: none; color: #FFFFFF;">Reports</a>
                                        </td>
                                        <td></td>
                                        <!---
                                        <td style="background-color: #592264;">
                                            <a href="/secure/onguard/recording_lookup.cfm" style="text-decoration: none; color: #FFFFFF;">Lookup</a>
                                        </td>
                                        --->
                                        <td></td>
									
                                            <td style="background-color: #FFFFFF;">
                                                <font size="1"><a href="/secure/onguard.cfm"><span class="sidelinks">Dashboard</span></a></font>
                                            </td>
										
                                        <!---
                                        <td style="background-color: #003466;">
                                            <a href="/secure/onguard/manager.cfm" style="text-decoration: none; color: #FFFFFF;">Manager</a>
                                        </td>
                                        <cfif client.custtype eq "I">
                                            <td></td>
                                            <td style="background-color: #FFFFFF;">
                                                <font size="1"><a href="/secure/onguard/in-house.cfm"><span class="sidelinks">In-House</span></a></font>
                                            </td>
											<td></td>
                                            <td style="background-color: #FFFFFF;">
                                                <font size="1"><a href="/secure/onguard.cfm"><span class="sidelinks">Dashboard</span></a></font>
                                            </td>
											
                                        </cfif>
                                        <td></td>
                                        --->
                                        <td style="background-color: #FFFFFF;">
                                            <font size="1"><a href="/secure/logout.cfm"><span class="sidelinks">Logout</span></a></font>
											
                                        </td>
                                    </tr>
                                </table>
                            </td><div align="right"><img src="/images/onguard-e-recordingsm2.png" border="0"> </div>
                        </tr> 
                    </table>
                </td> 
            </tr>
        </table>
