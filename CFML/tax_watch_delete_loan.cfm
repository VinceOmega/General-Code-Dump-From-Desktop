<cfif "I" eq client.custtype or "A" eq client.tw_admin or "R" eq client.tw_admin>

    <cfif '' eq client.tw_custcodes>
        <cfset tw_custcodes = client.custcode>
    <cfelse>
        <cfset tw_custcodes = Replace(client.tw_custcodes,' ',',','all')>
    </cfif>

    <cfinclude template="_tax_watch_header.cfm">
    <cfif not IsDefined('form.limit_by')>
        <cfset form.limit_by = 0>
    </cfif>
    <table style="width: 100%; background-color: #003466; color: #FFFFFF;" cellspacing="0">
        <tr>
            <td>
    <br />
<!--    <div style="color: #FFFFFF; font-weight: bold;" align="right"><img src="/images/taxwatchsm.png" border="0" alt=""> </div> -->
    <span style="width: 100%; font-size: 21px; text-align: center;"><img src="/images/Minus3.gif" border="0"> Delete Loan to Watch</span><br>
   
    <form action="" method="post">
    <table style="width: 95%; background-color: #FFFFFF; border: 1px solid black;" align="center">
        <tr>
            <td>
                Loan Identifier: <input type="text" name="loan_identifier" value="<cfif IsDefined("form.loan_identifier")><cfoutput>#form.loan_identifier#</cfoutput></cfif>">
            </td>
        </tr>
        <tr>
            <td><input type="submit" name="submit" value="[Find]"></td>
        </tr>
    </table>
    </form>

    <cfif IsDefined("form.tax_search_loan_id")>
        <table style="width: 100%; background-color: white;">
            <tr>
                <td>
                    <cfquery name="stec_mysql_track" datasource="STLinux1MySQL">
                        INSERT INTO
                            tax_search_track
                        SET
                            created = now(),
                            last_modified = now(),
                            created_by = 0,
                            last_modified_by = 0,
                            pick_userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.userid#">,
                            command = 'Remove from watch',
                            table_name = 'tax_search_loans',
                            id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.tax_search_loan_id#">
                    </cfquery>
                    <cfquery name="stec_mysql_update" datasource="STLinux1MySQL">
                        UPDATE
                            tax_search_loans
                        SET
                            last_modified = now(),
                            active = 'N'
                        WHERE
                            tax_search_loan_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.tax_search_loan_id#">
                    </cfquery>
                    <b>Loan removed from Tax Watch.</b><br />
                </td>
            </tr>
        </table>
    </cfif>
    <cfif IsDefined('form.loan_identifier')>

        <cfquery name="stec_mysql_search_results" datasource="STLinux1MySQL">
        SELECT
            tsl.tax_search_loan_id,
            tslo.pick_userid,
            tsl.loan_identifier,
            tsl.address,
            tsl.borrower,
            tsl.parcel,
            tsl.block,
            tsl.lot,
            tss.name as status,
            (SELECT tsr.delinquency_status FROM tax_search_results tsr WHERE tsr.tax_search_id = ts.tax_search_id AND tsr.active = 'Y' ORDER BY tsr.tax_search_result_id DESC LIMIT 1) as delinquency_status
        FROM tax_searches ts
        LEFT JOIN
            tax_search_loans tsl
        ON
            (ts.tax_search_loan_id = tsl.tax_search_loan_id)
        LEFT JOIN
            tax_search_loan_officers tslo
        ON
            (tsl.tax_search_loan_officer_id = tslo.tax_search_loan_officer_id)
        LEFT JOIN
            tax_search_statuses tss
        ON
            (tss.tax_search_status_id = ts.current_tax_search_status_id)
        WHERE
            ts.active = 'Y' AND
            tsl.active = 'Y' AND
            tslo.active = 'Y' AND
            tslo.customer_code IN (<cfqueryparam value="#tw_custcodes#" cfsqltype="cf_sql_varchar" list="yes">) AND
            tsl.loan_identifier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.loan_identifier#">
            <cfif "R" eq client.tw_admin>
                AND tslo.pick_userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.userid#">
            </cfif>
        </cfquery>

        <cfif stec_mysql_search_results.recordcount>

            <table style="width: 100%; background-color: white;">
                <tr>
                    <td></td>
                    <td><b>Loan&nbsp;Officer</b></td>
                    <td style="width: 140px;"><b>Loan&nbsp;Id</b></td>
                    <td><b>Address</b></td>
                    <td><b>Borrower</b></td>
                    <td><b>Parcel</b></td>
                    <td><b>Block</b></td>
                    <td><b>Lot</b></td>
                    <td><b>Status</b></td>
                    <td><b>Delinquency</b></td>
                </tr>
            <cfoutput query="stec_mysql_search_results">

                <cfset fullname = stec_mysql_search_results.pick_userid>

                <CFOBJECT type="COM" action="CREATE" class="D3ADO.Recordset" name="COMObject">
                <CFSET COMParams = "w3HostName=SEARCHTEC&w3Exec=OMSW3&sessionid=#client.sessionid#&FUNCTION=GET_UID_NAME&userid=#stec_mysql_search_results.pick_userid#">
                <CFSET temp = COMOBJECT.D3Open(#COMParams#)>
                <CFSET fldcount = COMObject.RecordCount>

                <cfif fldcount gt 0>
                    
                    <CFSET temp2 = COMObject.Fields>
                    <CFSET temp3 = temp2.Item("FULLNAME")>
                    <CFSET fullname = temp3.Value>
                </cfif>

                <tr valign="top">
                    <td><form method="POST"><input type="hidden" name="tax_search_loan_id" value="#stec_mysql_search_results.tax_search_loan_id#"><input type="submit" name="submit" value="Confirm Deletion"></form></td>
                    <td style="width: 100px;">#fullname#</td>
                    <td><a href="/secure/onguard/tax_loan_details.cfm?tax_search_loan_id=#stec_mysql_search_results.tax_search_loan_id#" target="new">#stec_mysql_search_results.loan_identifier#</a></td>
                    <td>#stec_mysql_search_results.address#</td>
                    <td>#stec_mysql_search_results.borrower#</td>
                    <td>#stec_mysql_search_results.parcel#</td>
                    <td>#stec_mysql_search_results.block#</td>
                    <td>#stec_mysql_search_results.lot#</td>
                    <td>#stec_mysql_search_results.status#</td>
                    <td>#stec_mysql_search_results.delinquency_status#</td>
                </tr>
            </cfoutput>
            </table>
        </cfif>
    </cfif>

            </td>
        </tr>
    </table>
</cfif>
