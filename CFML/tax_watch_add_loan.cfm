<cfdump var="#form#">

<cfif "I" eq client.custtype or "A" eq client.tw_admin or "L" eq client.tw_admin>

    <cfif '' eq client.tw_custcodes>
        <cfset tw_custcodes = client.custcode>
    <cfelse>
        <cfset tw_custcodes = Replace(client.tw_custcodes,' ',',','all')>
    </cfif>

    <cfinclude template="_tax_watch_header.cfm">
    <script language="javascript" defer="defer">
        window.isValidUSZip = function isValidUSZip(zip_code) {
            return /^\d{5}(-\d{4})?$/.test(zip_code);
        }

        window.processZip = function processZip(obj) {

            if (window.isValidUSZip(obj.value)) {

                $.ajax("https://www.searchtec.com/secure/ajax_zipfetch.cfm?zip=" + obj.value)
                    .done(function(data) {

                        if (data.search('`') != -1) {

                            // more than one record found.. display popup
                            window.open('ajax_select_zip.cfm?zip='+obj.value,'remote','width=400,height=550,scrollbars,resizeable');
                        } else if (',,' == data) {

                            $('#addLoanForm input[name=city]').val('');
                            $('#addLoanForm input[name=state_id]').val('');
                            $('#addLoanForm input[name=county]').val('');
                        } else {

                            var mySplitResult = data.split(',');

                            if (mySplitResult.length != 3) {

                                alert('Invalid Information returned from server for this zip code: '+data);
                            } else {

                                $('#addLoanForm input[name=city]').val(mySplitResult[0]);
                                //$('#addLoanForm input[name=state_id]').val(mySplitResult[1]);
                                $("#state_id").find("option:contains("+mySplitResult[1]+")").each(function(){
                                        if( $(this).text() == mySplitResult[1]) {
                                            $(this).attr("selected","selected");
                                        }
                                    });
                                $('#addLoanForm input[name=county]').val(mySplitResult[2]);
                            }
                        }

                    });
            }
        }

        window.changeCycleOptions = function changeCycleOptions(obj) {
                
            switch (obj.options[obj.selectedIndex].value) {
                case '1':
                    var cycle_obj = document.getElementById('cycle_id');
                    cycle_obj.length = 0;
                    cycle_obj.options[0] = new Option('1st', 1, true, false);
                    cycle_obj.options[1] = new Option('2nd', 2, false, false);
                    cycle_obj.options[2] = new Option('3rd', 3, false, false);
                    cycle_obj.options[3] = new Option('4th', 4, false, false);
                    break;
                case '2':
                    var cycle_obj = document.getElementById('cycle_id');
                    cycle_obj.length = 0;
                    cycle_obj.options[0] = new Option('1st and 3rd', 5, true, false);
                    cycle_obj.options[1] = new Option('2nd and 4th', 6, false, false);
                    break;
                case '3':
                    var cycle_obj = document.getElementById('cycle_id');
                    cycle_obj.length = 0;
                    cycle_obj.options[0] = new Option('Every Quarter', 7, true, false);
                    break;
                default:
                    var cycle_obj = document.getElementById('cycle_id');
                    cycle_obj.length = 0;
                    break;
            }
        }
    </script>
    <cfset error_msg = "">



    <table style="width: 100%; background-color: #003466; color: #FFFFFF;" cellspacing="0">
        <tr>
            <td>

    <cfif isDefined('form.add_loan')>

        <cfset form_data_is_valid = true>

        <cfset form.zip = ltrim(rtrim(rereplace(form.zip, "[[:space:]]+", " ", "all")))>
        <cfset form.city = ltrim(rtrim(rereplace(form.city, "[[:space:]]+", " ", "all")))>
        <cfset form.county = ltrim(rtrim(rereplace(form.county, "[[:space:]]+", " ", "all")))>
        <cfset form.parcel = ltrim(rtrim(rereplace(form.parcel, "[[:space:]]+", " ", "all")))>
        <cfset form.loan_identifier = UCase(ltrim(rtrim(rereplace(form.loan_identifier, "[[:space:]]+", " ", "all"))))>

        <cfset borrower = form.first1 & " " & form.middle1 & " " & form.last1 & " " & form.suffix1>
        <cfset borrower = ltrim(rtrim(rereplace(borrower, "[[:space:]]+", " ", "all")))>

        <cfset borrower2 = form.first2 & " " & form.middle2 & " " & form.last2 & " " & form.suffix2>
        <cfset borrower2 = ltrim(rtrim(rereplace(borrower2, "[[:space:]]+", " ", "all")))>

        <cfif borrower neq "" and borrower2 neq "">
            <cfset borrower = borrower & chr(10)>
        </cfif>
        <cfset borrower = borrower & borrower2>

        <cfif borrower neq "" and form.business1 neq "">
            <cfset borrower = borrower & chr(10)>
        </cfif>
        <cfset borrower = borrower & form.business1>

        <cfset address = form.house_number & " " & form.direction & " " & form.street_name & " " & form.street_type & " " & form.condo>
        <cfset address = ltrim(rtrim(rereplace(address, "[[:space:]]+", " ", "all")))>

        <cfset form.city = ltrim(rtrim(rereplace(form.city, "[[:space:]]+", " ", "all")))>
        <cfset form.zip = ltrim(rtrim(rereplace(form.zip, "[[:space:]]+", " ", "all")))>
        <cfset form.county = ltrim(rtrim(rereplace(form.county, "[[:space:]]+", " ", "all")))>

        <cfif borrower eq "">
            <cfset form_data_is_valid = false>
            <cfset error_msg = error_msg & "Borrower required.<br />">
        </cfif>
        <cfif address eq "">
            <cfset form_data_is_valid = false>
            <cfset error_msg = error_msg & "Address required.<br />">
        </cfif>
        <cfif form.zip eq "" and (form.city eq "" or form.state_id eq "")>
            <cfset form_data_is_valid = false>
            <cfset error_msg = error_msg & "Zip or City, State required.<br />">
        </cfif>

        <cfif form.loan_officer_id eq "">
            <cfset form_data_is_valid = false>
            <cfset error_msg = error_msg & "Loan Officer required. Please be sure to add Loan officers on the Manager page.<br />">
        </cfif>
        <cfif form.loan_identifier eq "">
            <cfset form_data_is_valid = false>
            <cfset error_msg = error_msg & "Loan Identifier required.<br />">
        </cfif>

        <cfset state_abbreviation = "">
        <cfif form.state_id neq "">
            <cfquery name="stec_mysql_check_state_id" datasource="STLinux1MySQL">
                SELECT
                    abbreviation
                FROM
                    states
                WHERE
                    active = 'Y' AND
                    state_id = <cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#form.state_id#">
            </cfquery>
            <cfif stec_mysql_check_state_id.recordcount eq 1>
                <cfset state_abbreviation = stec_mysql_check_state_id.abbreviation>
            <cfelse>
                <cfset form_data_is_valid = false>
                <cfset error_msg = error_msg & "Invalid State selected. Contact Technical Support <a href=" & chr(39) & "mailto:techsupport@searchtec.com" & chr(39) & ">techsupport@searchtec.com</a><br />">
            </cfif>
        <cfelse>
            <cfset form_data_is_valid = false>
            <cfset error_msg = error_msg & "You must select a State from the Dropdown list of States.<br />">
        </cfif>

        <cfif form.zip neq "">
            <cfif not REFind("^[0-9]{5}(\-[0-9]{4})?$", form.zip)>
                <cfset form_data_is_valid = false>
                <cfset error_msg = error_msg & "Invalid Zip Code Format.  Please use the following format: 19107 or 19107-1234<br />">
            </cfif>
        </cfif>

        <cfquery name="stec_mysql_check_loan_officer" datasource="STLinux1MySQL">
            SELECT
                tax_search_loan_officer_id
            FROM tax_search_loan_officers
            WHERE
                active = 'Y' AND
                tax_search_loan_officer_id = <cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#form.loan_officer_id#">
        </cfquery>
        <cfif stec_mysql_check_loan_officer.recordcount neq 1>
            <cfset form_data_is_valid = false>
            <cfset error_msg = error_msg & "Invalid Loan Officer Id.<br />">
        </cfif>
        
        <cfif state_abbreviation eq "NJ">
            <cfif parcel neq "">
                <cfset block = form.parcel>
                <cfset lot = "">
            <cfelse>
                <cfset block = "">
                <cfset lot = "">
            </cfif>
        </cfif>

        <cfif form_data_is_valid>
            <cfquery name="stec_mysql_insert" datasource="STLinux1MySQL">
                INSERT INTO
                    tax_search_loans
                SET
                    created = now(),
                    created_by = 0,
                    last_modified = now(),
                    last_modified_by = 0,
                    tax_search_loan_officer_id = <cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#form.loan_officer_id#">,
                    branch = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.branch#">,
                    loan_identifier = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.loan_identifier#">,
                    address = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#address#">,
                    frequency_id = <cfif "" eq form.frequency_id>null<cfelse>'<cfoutput>#form.frequency_id#</cfoutput>'</cfif>,
                    cycle_id = <cfif IsDefined('form.cycle_id')>'<cfoutput>#form.cycle_id#</cfoutput>'<cfelse>null</cfif>,
                    <cfif city neq "">
                        city = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.city#">,
                    </cfif>
                    <cfif state_id neq "">
                        state_id = <cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#form.state_id#">,
                    </cfif>
                    <cfif city neq "">
                        zip = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.zip#">,
                    </cfif>
                    <cfif city neq "">
                        county = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.county#">,
                    </cfif>
                    borrower = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#borrower#">
                    <cfif state_abbreviation eq "NJ">
                        <cfif parcel neq "">
                            , lot = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#lot#">
                            , block = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#block#">
                        </cfif>
                    <cfelse>
                        <cfif parcel neq "">
                            , parcel = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#parcel#">
                        </cfif>
                    </cfif>
            </cfquery>



   
        <cfquery name="stec_mysql_get_new_loan" datasource="STLinux1MySQL" result="get_new_loan_tracking">
            SELECT MAX(tax_search_loan_id) as loan_id
            FROM tax_search_loans 
        </cfquery>

        <cfoutput query="stec_mysql_get_new_loan">
            <cfset loanid = #loan_id#>
        </cfoutput>

        <cfdump var="#loanid#">

<cftransaction>
        <cfquery name="stec_mysql_save_loan_tracker" datasource="STLinux1MySQL" result="new_loan_tracking">
        INSERT into tax_search_track(
            created,
            created_by,
            last_modified,
            last_modified_by,
            active,
            pick_userid,
            command,
            table_name,
            id,
            user_ip
        )
        VALUES
        (
            now(),
            0,
            now(),
            0,
            <cfqueryparam value="Y" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="Added Loan To Tax Watch" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="tax_search_loans" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#loanid#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">

        )
    </cfquery>
	
            <cfset form.zip = ''>
            <cfset form.city = ''>
            <cfset form.county = ''>
            <cfset form.parcel = ''>
            <cfset form.loan_identifier = ''>
            
            <cfset form.first1 = ''>
            <cfset form.middle1 = ''>
            <cfset form.last1 = ''>
            
            <cfset form.first2 = ''>
            <cfset form.middle2 = ''>
            <cfset form.last2 = ''>
            
            <cfset form.house_number = ''>
            <cfset form.direction = ''>
            <cfset form.street_name = ''>
            <cfset form.street_type = ''>
            <cfset form.condo = ''>
            
            <cfset form.loan_officer_id = ''>
            <cfset form.state_id = ''>
            
            <cfset form.frequency_id = ''>
            <cfset form.cycle_id = ''>

            <script language="javascript">
                alert('Your Loan Has Been Added to Your Tax Watch.');
            </script>
            
        </cfif>
    </cfif>

    <CFOBJECT type="COM" action="CREATE" class="D3ADO.Recordset" name="COMObject">
    <CFSET COMParams = "w3HostName=SEARCHTEC&w3Exec=OMSW3&sessionid=#client.sessionid#&FUNCTION=GET_USERIDS&custcode=#client.custcode#">
    <CFSET temp = COMOBJECT.D3Open(#COMParams#)>
    <CFSET fldcount = COMObject.RecordCount>

    <cfset display_available = 0>
    <cfif fldcount gt 0>
        <cfloop from="1" to="#fldcount#" index="fldloop">

            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("USERIDS")>
            <CFSET userid = temp3.Value>

            <CFSET temp3 = temp2.Item("STATUSES")>
            <CFSET status = temp3.Value>

            <cfif status eq "">
                <cfquery name="stec_mysql_test" datasource="STLinux1MySQL">
                    SELECT
                        tax_search_loan_officer_id
                    FROM tax_search_loan_officers
                    WHERE
                        active = 'Y' AND
                        pick_userid = '#userid#'
                </cfquery>
                <cfif stec_mysql_test.recordcount eq 0>
                    <cfset display_available = display_available +1>
                </cfif>
            </cfif>

            <cfset tempx = COMObject.MoveNext()>
        </cfloop>
    </cfif>

    <br />

    <span style="width: 100%; font-size: 21px; text-align: center;"><img src="/images/Plus3.gif" border="0"> Add Loan to Watch</span><br>
    <form action="" method="post" id="addLoanForm" name="addLoanForm">
    <table style="background-color: #FFFFFF; border: 1px solid black;" align="center">

        <cfif error_msg neq "">
            <tr>
                <td style="color: red;"><cfoutput>#error_msg#</cfoutput></td>
            </tr>
        </cfif>

        <tr>
            <td><b>Borrower</b></td>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td></td>
                        <td>First</td>
                        <td>M.</td>
                        <td>Last</td>
                        <td>Suffix</td>
                    </tr>
                    <tr>
                        <td>1</td>
                        <td><input type="text" name="first1" value="<cfif IsDefined("form.first1")><cfoutput>#form.first1#</cfoutput></cfif>"></td>
                        <td><input type="text" name="middle1" value="<cfif IsDefined("form.middle1")><cfoutput>#form.middle1#</cfoutput></cfif>"></td>
                        <td><input type="text" name="last1" value="<cfif IsDefined("form.last1")><cfoutput>#form.last1#</cfoutput></cfif>"></td>
                        <td><input type="text" name="suffix1" size="10" value="<cfif IsDefined("form.suffix1")><cfoutput>#form.suffix1#</cfoutput></cfif>"></td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td><input type="text" name="first2" value="<cfif IsDefined("form.first2")><cfoutput>#form.first2#</cfoutput></cfif>"></td>
                        <td><input type="text" name="middle2" value="<cfif IsDefined("form.middle2")><cfoutput>#form.middle2#</cfoutput></cfif>"></td>
                        <td><input type="text" name="last2" value="<cfif IsDefined("form.last2")><cfoutput>#form.last2#</cfoutput></cfif>"></td>
                        <td><input type="text" name="suffix2" size="10" value="<cfif IsDefined("form.suffix2")><cfoutput>#form.suffix2#</cfoutput></cfif>"></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>Business</td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3"><input type="text" name="business1" size="50" value="<cfif IsDefined("form.business1")><cfoutput>#form.business1#</cfoutput></cfif>"></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td><b>Property</b></td>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td>Number</td>
                        <td>Direction</td>
                        <td>Street</td>
                        <td>Ave, St, etc</td>
                        <td>Condo/Unit#</td>
                    </tr>
                    <tr>
                        <td><input type="text" name="house_number" value="<cfif IsDefined("form.house_number")><cfoutput>#form.house_number#</cfoutput></cfif>"></td>
                        <td>
                            <select name="direction">
                                <option value="" <cfif IsDefined("form.direction") and form.direction eq "">selected="selected"</cfif>></option>
                                <option value="N" <cfif IsDefined("form.direction") and form.direction eq "N">selected="selected"</cfif>>N</option>
                                <option value="NE" <cfif IsDefined("form.direction") and form.direction eq "NE">selected="selected"</cfif>>NE</option>
                                <option value="E" <cfif IsDefined("form.direction") and form.direction eq "E">selected="selected"</cfif>>E</option>
                                <option value="SE" <cfif IsDefined("form.direction") and form.direction eq "SE">selected="selected"</cfif>>SE</option>
                                <option value="S" <cfif IsDefined("form.direction") and form.direction eq "S">selected="selected"</cfif>>S</option>
                                <option value="SW" <cfif IsDefined("form.direction") and form.direction eq "SW">selected="selected"</cfif>>SW</option>
                                <option value="W" <cfif IsDefined("form.direction") and form.direction eq "W">selected="selected"</cfif>>W</option>
                                <option value="NW" <cfif IsDefined("form.direction") and form.direction eq "NW">selected="selected"</cfif>>NW</option>
                            </select>
                        </td>
                        <td><input type="text" name="street_name" value="<cfif IsDefined("form.street_name")><cfoutput>#form.street_name#</cfoutput></cfif>"></td>
                        <td><input type="text" name="street_type" size="10" value="<cfif IsDefined("form.street_type")><cfoutput>#form.street_type#</cfoutput></cfif>"></td>
                        <td><input type="text" name="condo" size="10" value="<cfif IsDefined("form.condo")><cfoutput>#form.condo#</cfoutput></cfif>"></td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td>Zip</td>
                        <td>City</td>
                        <td>State</td>
                        <td>County</td>
                        <td>Parcel# (if available)</td>
                    </tr>
                    <tr>
                        <td><input type="text" id="zip" name="zip" size="11" onchange="window.processZip(this);" value="<cfif IsDefined("form.zip")><cfoutput>#form.zip#</cfoutput></cfif>"></td>
                        <td><input type="text" id="city" name="city" value="<cfif IsDefined("form.city")><cfoutput>#form.city#</cfoutput></cfif>"></td>

                        <td>
                            <select id="state_id" name="state_id">
                                <option value=""></option>
                                <cfquery name="stec_mysql_states" datasource="STLinux1MySQL">
                                    SELECT
                                        state_id,
                                        abbreviation
                                    FROM
                                        states
                                    WHERE
                                        active = 'Y'
                                </cfquery>
                                <cfif stec_mysql_states.recordcount>
                                    <cfoutput query="stec_mysql_states">
                                        <option value="#stec_mysql_states.state_id#" <cfif IsDefined('form.state_id') and form.state_id eq "#stec_mysql_states.state_id#">selected="selected"</cfif>>#stec_mysql_states.abbreviation#</option>
                                    </cfoutput>
                                </cfif>

                            </select>
                        </td>

                        <td><input type="text" id="county" name="county" value="<cfif IsDefined("form.county")><cfoutput>#form.county#</cfoutput></cfif>"></td>
                        <td><input type="text" name="parcel" value="<cfif IsDefined("form.parcel")><cfoutput>#form.parcel#</cfoutput></cfif>"></td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td>Loan Officer</td>
                        <td>
                            <cfif client.tw_admin eq "A">
                                <cfquery name="stec_mysql" datasource="STLinux1MySQL">
                                    SELECT
                                        tax_search_loan_officer_id,
                                        name,
                                        pick_userid
                                    FROM tax_search_loan_officers
                                    WHERE
                                        active = 'Y' AND
                                        customer_code IN (<cfqueryparam value="#tw_custcodes#" cfsqltype="cf_sql_varchar" list="yes">)
                                </cfquery>
                            <cfelse>                            
                                <cfquery name="stec_mysql" datasource="STLinux1MySQL">
                                    SELECT
                                        tax_search_loan_officer_id,
                                        name,
                                        pick_userid
                                    FROM tax_search_loan_officers
                                    WHERE
                                        active = 'Y' AND
                                        customer_code IN (<cfqueryparam value="#tw_custcodes#" cfsqltype="cf_sql_varchar" list="yes">) AND
                                        pick_userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.userid#">
                                </cfquery>
                            </cfif>
                            
                            <cfif stec_mysql.recordcount>
                                <select name="loan_officer_id">
                                    <cfoutput query="stec_mysql">

                                        <cfif "" eq stec_mysql.pick_userid>
                                            <cfset fullname = stec_mysql.name>
                                        <cfelse>
                                            <cfset fullname = stec_mysql.pick_userid>

                                            <CFOBJECT type="COM" action="CREATE" class="D3ADO.Recordset" name="COMObject">
                                            <CFSET COMParams = "w3HostName=SEARCHTEC&w3Exec=OMSW3&sessionid=#client.sessionid#&FUNCTION=GET_UID_NAME&userid=#stec_mysql.pick_userid#">
                                            <CFSET temp = COMOBJECT.D3Open(#COMParams#)>
                                            <CFSET fldcount = COMObject.RecordCount>

                                            <cfif fldcount gt 0>

                                                <CFSET temp2 = COMObject.Fields>
                                                <CFSET temp3 = temp2.Item("FULLNAME")>
                                                <CFSET fullname = temp3.Value>
                                            </cfif>
                                        </cfif>

                                        <option value="#stec_mysql.tax_search_loan_officer_id#" <cfif IsDefined('form.loan_officer_id') and form.loan_officer_id eq "#stec_mysql.tax_search_loan_officer_id#">selected="selected"</cfif>>#fullname#</option>
                                    </cfoutput>
                                </select>
                            </cfif>
                        </td>
                        <td>
                            Loan Identifier
                        </td>
                        <td>
                            <input type="text" name="loan_identifier" value="<cfif IsDefined("form.loan_identifier")><cfoutput>#form.loan_identifier#</cfoutput></cfif>">
                        </td>
                    </tr>
                    <tr>
                        <td>Branch</td>
                        <td><input type="text" name="branch" value="<cfif IsDefined("form.branch")><cfoutput>#form.branch#</cfoutput></cfif>">
                    </tr>
                    <tr>
                        <td>Frequency</td>
                        <td>&nbsp;</td>
                        <td>Cycle (Quarters)</td>
                    </tr>
                    <tr>
                        <td>
                            <select name="frequency_id" id="frequency_id" onchange="window.changeCycleOptions(this);">
                                <option value="">Do not Auto-run</option>
                                <option value="1" <cfif IsDefined('form.frequency_id') and 1 eq form.frequency_id>selected="selected"</cfif>>Annually</option>
                                <option value="2" <cfif IsDefined('form.frequency_id') and 2 eq form.frequency_id>selected="selected"</cfif>>Bi-Annually</option>
                                <option value="3" <cfif IsDefined('form.frequency_id') and 3 eq form.frequency_id>selected="selected"</cfif>>Quarterly</option>
                            </select>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                            <select name="cycle_id" id="cycle_id">
                                <cfif IsDefined('form.frequency_id') and 1 eq form.frequency_id>
                                    <option value="1" <cfif IsDefined('form.cycle_id') and 1 eq form.cycle_id>selected="selected"</cfif>>1st</option>
                                    <option value="2" <cfif IsDefined('form.cycle_id') and 2 eq form.cycle_id>selected="selected"</cfif>>2nd</option>
                                    <option value="3" <cfif IsDefined('form.cycle_id') and 3 eq form.cycle_id>selected="selected"</cfif>>3rd</option>
                                    <option value="4" <cfif IsDefined('form.cycle_id') and 4 eq form.cycle_id>selected="selected"</cfif>>4th</option>
                                <cfelse>
                                    <cfif IsDefined('form.frequency_id') and 2 eq form.frequency_id>
                                        <option value="5" <cfif IsDefined('form.cycle_id') and 5 eq form.cycle_id>selected="selected"</cfif>>1st and 3rd</option>
                                        <option value="6" <cfif IsDefined('form.cycle_id') and 6 eq form.cycle_id>selected="selected"</cfif>>2nd and 4th</option>
                                    <cfelse>
                                        <cfif IsDefined('form.frequency_id') and 3 eq form.frequency_id>
                                            <option value="7">Every Quarter</option>
                                        <cfelse>
                                            <option value=""></option>
                                        </cfif>
                                    </cfif>
                                </cfif>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: right;"><input type="submit" name="add_loan" value="[Add Loan]"></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
            </td>
        </tr>
    </table>
</cfif>
<!---
<cfoutput>
    <pre>
    #get_new_loan_tracking.sql#
    #new_loan_tracking.sql#
    </pre>
</cfoutput> --->