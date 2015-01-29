<!--- Header is generated above this point --->


<!--- MySQL queries begins here --->
<cfif "I" eq client.custtype or "A" eq client.tw_admin or "L" eq client.tw_admin>

    <cfinclude template="_tax_watch_header.cfm">
    <script language="javascript" defer="defer">
        window.changeCustomerCode = function changeCustomerCode(){
            $.ajax("https://www.searchtec.com/secure/ajax_custfetch.cfm?cust=" + document.OptionsForm.cust.value)
                .fail(function() { alert('Failed to change customer code.') })
                .done(function(data) { document.location.href = data; });
        }

        window.findCust = function findCust(){
            var newWind=window.open('select_cust.cfm','remote','width=400,height=400,scrollbars,resizeable');
        }
    </script>
    <table style="width: 100%; background-color: #003466; color: #FFFFFF;" cellspacing="0" class="main_body">
        <tr>
            <td>

    <cfif isDefined('form.add')>

        <cfset fullname = form.pick_userid>

        <CFOBJECT type="COM" action="CREATE" class="D3ADO.Recordset" name="COMObject">
        <CFSET COMParams = "w3HostName=SEARCHTEC&w3Exec=OMSW3&sessionid=#client.sessionid#&FUNCTION=GET_UID_NAME&userid=#form.pick_userid#">
        <CFSET temp = COMOBJECT.D3Open(#COMParams#)>
        <CFSET fldcount = COMObject.RecordCount>

        <cfif fldcount gt 0>
            
            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("FULLNAME")>
            <CFSET fullname = temp3.Value>
            
            <cfoutput>
            <cfquery name="stec_mysql_test" datasource="STLinux1MySQL">
                SELECT
                    tax_search_loan_officer_id
                FROM tax_search_loan_officers
                WHERE
                    active = 'Y' AND
                    pick_userid = '#form.pick_userid#'
            </cfquery>
            <cfif stec_mysql_test.recordcount>
                Could not add user, #fullname#, to Loan Officers as they are already a Loan Officer.<br />
            <cfelse>
                <cfquery name="stec_mysql_add" datasource="STLinux1MySQL">
                    INSERT INTO
                        tax_search_loan_officers
                    SET
                        created = now(),
                        last_modified = now(),
                        created_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.userid#">,
                        last_modified_by = 0,
                        name = '#form.pick_userid#',
                        pick_userid = '#form.pick_userid#',
                        customer_code = '#client.custcode#'
                </cfquery>
                User: #fullname# successfully added to the Loan Officers.<br />
            </cfif>
            </cfoutput>
        </cfif>
    </cfif>
    <br />

    <cfif isDefined('form.delete')>

        <cfquery name="stec_mysql_test" datasource="STLinux1MySQL">
            SELECT
                tslo.tax_search_loan_officer_id
            FROM tax_search_loan_officers as tslo
            LEFT JOIN
                tax_search_loans tsl
            ON
                (tslo.tax_search_loan_officer_id = tsl.tax_search_loan_officer_id)
            WHERE
                tslo.active = 'Y' AND
                tslo.tax_search_loan_officer_id = '#form.tax_search_loan_officer_id#' AND
                tsl.active = 'Y'
        </cfquery>
        <cfif stec_mysql_test.recordcount is 0>
            <cfoutput>
            <cfquery name="stec_mysql_delete" datasource="STLinux1MySQL">
                UPDATE
                    tax_search_loan_officers
                SET
                    active = 'N',
                    last_modified = now(),
                    last_modified_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.userid#">,
                WHERE
                    tax_search_loan_officer_id = '#form.tax_search_loan_officer_id#'
            </cfquery>
            Loan Officer removed.
            </cfoutput>
        <cfelse>
            Loan Officer cannot be removed until their loans have been reassigned.
        </cfif>
    </cfif>
	

<cfif IsDefined('url.start')>	
<cfquery name="stec_mysql_loan_tracking_qry" result="meta_tracking" datasource="STLinux1MySQL">
Select
  tslo.created,
  tslo.created_by,
  tslo.last_modified,
  tslo.last_modified_by,
  tslo.active,
  tslo.is_manager,
  tslo.pick_userid,
  tslo.customer_code,
  tslo.name,
  tst.user_ip as ip,
  tsl.loan_identifier,
  tst.command,
  tsl.tax_search_loan_id as id
From
  tax_search_loan_officers tslo Left Join
  tax_search_loans tsl On tsl.tax_search_loan_officer_id =
    tslo.tax_search_loan_officer_id Left Join
  tax_search_track tst On tst.pick_userid = tslo.pick_userid
Where
  tslo.customer_code In (<cfqueryparam value="#tw_custcodes#" cfsqltype="cf_sql_varchar" list="yes">)
 
  <cfif IsDefined('url.active')>
	<cfif url.active neq "">
	AND
	tslo.active = <cfqueryparam value="#Trim(url.active)#" cfsqltype="cf_sql_varchar" list="yes">
	</cfif>
 </cfif>
 
 <cfif IsDefined('url.is_managed')>
	<cfif url.is_managed neq "">
	AND
	tslo.is_manager = <cfqueryparam value="#Trim(url.is_managed)#" cfsqltype="cf_sql_varchar" list="yes">
	</cfif>
 </cfif>
 
 
 <cfif IsDefined('url.start_date')>
	<cfif url.start_date neq "" and url.end_date eq "">

AND

<cfqueryparam value="#Trim(url.start_date)#" cfsqltype="cf_sql_date"> <= tslo.last_modified
AND

DATE_FORMAT(tslo.last_modified, '%Y-%m-%d') <= NOW()

		
	</cfif>
 </cfif>
 
 <cfif IsDefined('url.start_date')>
 	<cfif url.end_date neq "" and url.start_date eq "">
AND
'2010-01-01' <= tslo.last_modified
AND 
tslo.last_modified <= <cfqueryparam value="#Trim(url.end_date)#" cfsqltype="cf_sql_date">

	</cfif>
 </cfif>
 
 <cfif isDefined('url.start_date')>
	<cfif (url.start_date neq "") and (url.end_date neq "") >
		
AND
	<cfqueryparam value="#Trim(url.start_date)#" cfsqltype="cf_sql_date"> <= tslo.last_modified 
 AND
tslo.last_modified  <= <cfqueryparam value="#Trim(url.end_date)#" cfsqltype="cf_sql_date">
			
		</cfif>
 </cfif>
 

  <!---
 <cfif IsDefined('url.searchbar')>
	<cfif url.search neq "">
 AND (tsl.loan_indentifier = <cfqueryparam value="#Trim(url.searchbar)#" cfsqltype="cf_sql_varchar" list="yes">
OR tslo.name = <cfqueryparam value="#Trim(url.searchbar)#" cfsqltype="cf_sql_varchar" list="yes">
OR tslo.pick_userid = <cfqueryparam value="#Trim(url.searchbar)#" cfsqltype="cf_sql_varchar" list="yes">) 
	</cfif>
 </cfif>

 --->
 
	</cfquery>
</cfif>
<!--- MySQL queries end here --->


<!--- Content begins here --->	

  
    <hr />
    <span style="font-size: 21px;">Update Tax Watch</span><br />
    <br />

    <a href="tax_watch_add_loan.cfm"><img src="/images/Plus3.gif" border="0"></a> <span style="font-size: 18px;">Add Loan</span><br />
    <br />
	<cfif "I" eq client.custtype or "A" eq client.tw_admin>
	
    <a href="tax_watch_delete_loan.cfm"><img src="/images/Minus3.gif" border="0"></a> <span style="font-size: 18px;">Delete Loan</span><br />
    </cfif>
            </td>
	<tr>
		<td><a class="btn-small" href="tax_watch_loan_tracker.cfm" alt="link to tracker">Loan Tracker</a></td>
	</tr>
	
    </table>
</cfif>
<!--- Content Ends here --->

<!--- Footer is appended here --->