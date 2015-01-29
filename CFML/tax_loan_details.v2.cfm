<cfoutput>
    <cfdump var="#form#">

</cfoutput>

<cfset count = 0>

<!---Defining a cffunction to call later on --->

<!--- <cfcomponent> --->


<cffunction name = "sendToDiffQry">
    <cfargument name="loanid" type="any" required="yes" default="0"/>
    <cfargument name="oldValue" type="any" required="yes" default="none"/>
    <cfargument name="newValue" type="any" required="yes" default="none"/>
    <cfargument name="fieldName" type="string" required="yes" default="none"/>

    <!--- <cftransaction> --->

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(loanid))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(oldValue)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(newValue)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(fieldName)#" cfsqltype="cf_sql_varchar">,
             now()
                ) 
            </cfquery> 
            
        <!--- </cftransaction> --->


<cfoutput>
<!--- <cfdump var="#query.diffInsert#">  --->
<pre>
#diff.sql#"
</pre>
</cfoutput>

<cfreturn 1>
</cffunction>

<!--- </cfcomponent> --->
<!---End --->

<cfparam name="user_ip" default="">

<cfoutput>
<cfif '' eq client.tw_custcodes or 'I' eq client.custtype>
    <cfset tw_custcodes = client.custcode>
<cfelse>
    <cfset tw_custcodes = Replace(client.tw_custcodes,' ',',','all')>
</cfif>

<cfif not StructKeyExists(url, "tax_search_loan_id")>
    Invalid Tax Search Loan Id.
    <cfabort>
</cfif>

<!--- get the fields and state abbreviation for the current tax search loan --->
<cfquery name="currentTaxSearchLoanQry" datasource="STLinux1MySQL">
    SELECT
        tsl.*,
        tslo.name,
        tslo.pick_userid,
        states.abbreviation as state_abbreviation
    FROM tax_search_loans tsl
    LEFT JOIN tax_search_loan_officers tslo
    ON tsl.tax_search_loan_officer_id = tslo.tax_search_loan_officer_id
    LEFT JOIN states
    ON tsl.state_id = states.state_id
    WHERE
        tax_search_loan_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#">
</cfquery>

<!--- Make a copy of the query data --->
<cfset cloneQry = Duplicate(currentTaxSearchLoanQry)>  
<!--- <cfdump var="#cloneQry#"> --->


<cfif 0 eq currentTaxSearchLoanQry.recordCount>
    Invalid Tax Search Loan Id.
    <cfabort>
</cfif>

<!--- get a query of the Loan Officers for the current Customer Code(s) --->
<cfquery name="LoanOfficersQry" datasource="STLinux1MySQL">
SELECT
    tax_search_loan_officer_id,
    name,
    pick_userid
FROM
    tax_search_loan_officers
WHERE
    active = 'Y' AND
    customer_code IN (<cfqueryparam value="#tw_custcodes#" cfsqltype="cf_sql_varchar" list="yes">)
</cfquery>

<!--- create an Array of Loan Officer Ids and their Names --->
<cfset loan_officer_ids = ArrayNew(1)>
<cfset loan_officer_names = ArrayNew(1)>

<cfloop query="LoanOfficersQry">
    
    <cfset ArrayAppend(loan_officer_ids, LoanOfficersQry.tax_search_loan_officer_id)>
    
    <cfif LoanOfficersQry.name neq ''>
        <cfset ArrayAppend(loan_officer_names, LoanOfficersQry.name)>
    <cfelse>
        <cfset ArrayAppend(loan_officer_names, LoanOfficersQry.pick_userid)>
    </cfif>
</cfloop>

<!--- if the count of this query is zero then the user is not allowed to edit (unless they are an admin or an internal user) --->
<cfquery name="userIsAllowedToEditQry" datasource="STLinux1MySQL">
    SELECT
        tax_search_loan_officer_id
    FROM
        tax_search_loan_officers
    WHERE
        pick_userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.userid#">
</cfquery>

<!--- If the user clicked Order Update, this is where the update is ordered --->
<cfif "I" eq client.custtype or "A" eq client.tw_admin or 0 neq userIsAllowedToEditQry.recordCount>
    <cfif StructKeyExists(form, "order_update")>
        <!--- Puts an entry in the log that the current user ordered an updated tax search --->
        <cfquery name="trackQry" datasource="STLinux1MySQL">
            INSERT INTO
                tax_search_track
            SET
                created = 0,
                last_modified = now(),
                created_by = 0,
                last_modified_by = 0,
                pick_userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.userid#">,
                command = 'Update Tax Search Ordered',
                table_name = 'tax_search_loans',
                id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#">,
                user_ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
        </cfquery>
        <!--- Inserts the ordered update into the tax_searches table --->
        <cfquery name="insertQry" datasource="STLinux1MySQL">
            INSERT INTO
                tax_searches
            SET
                created = now(),
                created_by = 0,
                last_modified = now(),
                last_modified_by = 0,
                tax_search_loan_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#">,
                current_tax_search_status_id = 1,
                search_date = now()
        </cfquery>
        <b>Update tax search ordered.</b><br />
    </cfif>
</cfif>

<!--- If the user set the Frequency / Cycle, this is where it is set in the database --->
<cfif "I" eq client.custtype or "A" eq client.tw_admin or 0 neq userIsAllowedToEditQry.recordCount>
    <cfif StructKeyExists(form, "set_cycles")>
        <!--- Puts an entry in the log that the current user set the frequency and cycle for this tax search loan --->
        <cfquery name="trackQry" datasource="STLinux1MySQL">
            INSERT INTO
                tax_search_track
            SET
                created = 0,
                last_modified = now(),
                created_by = 0,
                last_modified_by = 0,
                pick_userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.userid#">,
                command = 'Updated Frequency/Cycle',
                table_name = 'tax_search_loans',
                id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#">,
                user_ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
        </cfquery>
        <!--- Updates the tax_search_loans table to set the frequency and cycle fields for the current tax_search_loan_id --->
        <cfquery name="updateQry" datasource="STLinux1MySQL">
            UPDATE
                tax_search_loans
            SET
                last_modified = now(),
                last_modified_by = 0,
                frequency_id = <cfif "" eq form.frequency_id>null<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#form.frequency_id#"></cfif>,
                cycle_id = <cfif StructKeyExists(form, "cycle_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.cycle_id#"><cfelse>null</cfif>
            WHERE
                tax_search_loan_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#">
        </cfquery>
        <b>Auto-run Frequency and Cycle set.</b><br />
        
    <cftransaction>     
        <cfquery name="saveOldLoanInfo3" datasource="STLinux1MySQL">
        INSERT into tax_search_old_loan_data
        (
            tax_search_loan_id,
            frequency_id,
            cycle_id,
            state_id,
            branch,
            borrower,
            address,
            city,
            zip,
            county,
            parcel,
            block,
            lot,
            timeofevent,
            notes
        )
        VALUES
        (
        <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(Val(form.old_frequency_id3))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(Val(form.old_cycle_id3))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(Val(form.old_state_id3))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(form.old_branch3)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_street_address3)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_borrower3)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_city3)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_zip3)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_county3)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_parcel3)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_block3)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_lot3)#" cfsqltype="cf_sql_varchar">,
        Now(),
        <cfqueryparam value="#trim(form.old_notes3)#" cfsqltype="cf_sql_varchar">
        )
        
        </cfquery>
</cftransaction>

    </cfif>
</cfif>
<!--- If the user made any changes to the tax search loan, those changes are saved here --->
<cfif "I" eq client.custtype or "A" eq client.tw_admin or 0 neq userIsAllowedToEditQry.recordCount>
    <cfif StructKeyExists(form, "save_changes")>
        <!--- Puts an entry in the log that the current user change the fields for this tax search loan --->
        <cfquery name="trackQry" datasource="STLinux1MySQL">
            INSERT INTO
                tax_search_track
            SET
                created = 0,
                last_modified = now(),
                created_by = 0,
                last_modified_by = 0,
                pick_userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.userid#">,
                command = 'Updated Loan Watch Record',
                table_name = 'tax_search_loans',
                id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#">,
                user_ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
        </cfquery>
        <!--- Updates the tax_search_loans table to set the fields from the edit form that have been changed  for the current tax_search_loan_id --->
        <cfquery name="updateQry" datasource="STLinux1MySQL">
            UPDATE
                tax_search_loans
            SET
                last_modified = now(),
                last_modified_by = 0,
                loan_identifier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.loan_identifier#">,
                tax_search_loan_officer_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.loan_officer_id#">,
                branch = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.branch#">,
                borrower = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.borrower#">,
                address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.address#">,
                city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">,
                state_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.state_id#">,
                zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.zip#">,
                county = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.county#">,
                parcel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parcel#">,
                block = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.block#">,
                lot = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.lot#">
            WHERE
                tax_search_loan_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#">
        </cfquery>
<cftransaction>     
        <cfquery name="saveOldLoanInfo" datasource="STLinux1MySQL">
        INSERT into tax_search_old_loan_data
        (
            tax_search_loan_id,
            frequency_id,
            cycle_id,
            state_id,
            branch,
            borrower,
            address,
            city,
            zip,
            county,
            parcel,
            block,
            lot,
            timeofevent,
            notes
        )
        VALUES
        (
        <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(Val(form.old_frequency_id))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(Val(form.old_cycle_id))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(Val(form.old_state_id))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(form.old_branch)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_street_address)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_borrower)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_city)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_zip)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_county)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_parcel)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_block)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_lot)#" cfsqltype="cf_sql_varchar">,
        Now(),
        <cfqueryparam value="#trim(form.old_notes)#" cfsqltype="cf_sql_varchar">
        )
        
        </cfquery>
</cftransaction> 

<!---Diff checker for loans. Logic that compares old date to data being sumbitted, if there is a change then that change is logged--->
<!--- 
<cfset oldData = NewStruct()>
<cfset newData = NewStruct()> --->

<!--- <cfset count = count + 1> --->


<cfset cmp = compare('form.old_frequency_id', 'form.frequency_id')>

<cfif StructKeyExists(form ,'frequency_id')>
          <cfif cmp neq 0>

        <!--- <cfset
        sendToDiffQry(url.tax_search_loan_id, form.old_frequency_id, form.frequency_id, 'frequency')> --->

        <cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(form._old_freqency_id)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.frequency_id)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(frequency)#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>
        
        <cfoutput> 
<cfdump var="#diff.sql#">
        </cfoutput>

            </cfif>
</cfif>

<cfif StructKeyExists(form, 'cycle_id')>
  <cfif form.old_cycle_id NEQ form.cycle_id>

         <!---         <cfset
        sendToDiffQry(url.tax_search_loan_id, form.old_cycle_id, form.cycle_id, 'cycle')> --->

        <cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(form.old_cycle_id)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.cycle_id)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(cycle)#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>

        <cfoutput>
    <cfdump var="#diff.sql#">
        </cfoutput>

            </cfif>
</cfif>


         <cfif StructKeyExists(form, 'state_id') AND form.old_state_id NEQ form.state_id >

            

         <!---     <cfset
        sendToDiffQry(url.tax_search_loan_id, form.old_state_id, form.state_id, 'state')> --->

<cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(form.old_state_id)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.state_id)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(state)#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>
        <cfoutput>
        <cfdump var="#diff.sql#">
        </cfoutput>

            </cfif>

    <cfif StructKeyExists(form, 'branch')> 
    <cfif form.old_branch NEQ form.branch>

     <!---    <cfset
        sendToDiffQry(url.tax_search_loan_id, form.old_branch, form.branch,     'branch')> --->

        <cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(form.old_branch)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.branch)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(branch)#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>

             <cfoutput>
        <cfdump var="#diff.sql#">
        </cfoutput>

            </cfif>
    </cfif>

    <cfif StructKeyExists(form, 'address')>
           <cfif form.old_street_address NEQ form.address>

               <!---   <cfset
        sendToDiffQry(url.tax_search_loan_id, form.old_street_address, form.address, 'address')> --->

        <cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(form.old_street_address)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.address)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(address)#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>

             <cfoutput>
        <cfdump var="#diff.sql#">
        </cfoutput>

            </cfif>
    </cfif>
    
    <cfif StructKeyExists(form, 'city')>
          <cfif form.old_city NEQ form.city>

        <cfoutput>
        Confirmed
        </cfoutput>

                 <cfset
        sendToDiffQry(url.tax_search_loan_id, form.old_city, form.city, 'city')> 

<!--- <cftransaction> --->

           <!--- <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
              (
                 tax_search_loan_id,
                 old_value,
                  new_value,
                 field_name,
                 timeofedit
                 )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
             <cfqueryparam value="#trim(form.old_city)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.city)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(city)#" cfsqltype="cf_sql_varchar">,
             now()

                ) 
             </cfquery> 
            --->
<!---         </cftransaction> --->


            <!---  <cfoutput>
          <pre> 
        <cfdump var="#diff.sql#">
        </pre>
        </cfoutput> --->

            </cfif>
    </cfif>

    <cfif StructKeyExists(form, 'zip')>
         <cfif form.old_zip NEQ form.zip>


              
            <!---      <cfset
        sendToDiffQry(url.tax_search_loan_id, form.old_zip, form.zip, 'zip')> --->
<cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(form.old_zip)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.zip)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(zip)#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>

        <cfoutput>
        <cfdump var="#diff.sql#">
        </cfoutput>

            </cfif>
    </cfif>

    
        <cfif  StructKeyExists(form ,'county') AND form.old_county NEQ form.county >


       <!--- 
                 <cfset
                 sendToDiffQry(url.tax_search_loan_id, form.old_county, form.county, 'county')> --->

<cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(form.old_county)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.county)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(county)#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>
        <cfoutput>
        <cfdump var="#diff.sql#">
        </cfoutput>

        </cfif>

       
           <cfif StructKeyExists(form,'parcel') AND form.old_parcel NEQ form.parcel >


               <!---   <cfset
                 sendToDiffQry(url.tax_search_loan_id, form.old_parcel, form.parcel, 'parcel')> --->

<cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(form.old_parcel)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.parcel)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(parcel)#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>
        

             <cfoutput>
        <cfdump var="#diff.sql#">
        </cfoutput>

            </cfif>

         
        <cfif StructKeyExists(form,'block') AND form.old_block NEQ form.block >
         
       <!---           <cfset
        sendToDiffQry(url.tax_search_loan_id, form.old_block, form.block, 'block')> --->

        <cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(form.old_block)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.block)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(block)#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>
        

             <cfoutput>
        <cfdump var="#diff.sql#">
        </cfoutput>

        </cfif>

        
         <cfif StructKeyExists(form,'lot') AND form.old_lot NEQ form.lot >

         
              <!---    <cfset
                 sendToDiffQry(url.tax_search_loan_id, form.old_lot, form.lot, 'lot')> --->
<cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(form.old_lot)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.lot)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(lot)#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>
        

             <cfoutput>
        <cfdump var="#diff.sql#">
        </cfoutput>

        </cfif>

        <cfif StructKeyExists(form,'notes') AND form.old_notes NEQ form.notes >

           
                <!---  <cfset
                 sendToDiffQry(url.tax_search_loan_id, form.old_notes, form.notes, 'notes')> --->

<cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(form.old_notes)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(form.notes)#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(notes)#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>
        
             <cfoutput>
        <cfdump var="#diff.sql#">
        </cfoutput>

            </cfif>
 

 

<!--- <cfloop condition = "count GREATER THAN 0"> --->
<!--- <cftransaction>

            <cfquery name="diffInsert" datasource="STLinux1MySQL" result="diff">
             INSERT into tax_search_diff_table
                (
                tax_search_loan_id,
                 old_value,
                 new_value,
                 field_name,
                 timeofedit
                )
                VALUES
                (
                <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
            <cfqueryparam value="#trim(oldArray(count))#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(newArray(count))#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#trim(nameArray(count))#" cfsqltype="cf_sql_varchar">,
             Now()

                ) 
            </cfquery> 
            
        </cftransaction>

   <!---      <cfset count = count - 1> --->

     <cfoutput>
    <cfdump var="#diff.sql#">
        </cfoutput> --->

 <!--- </cfloop> --->
<!---End of diff checker --->       
        
        <b>Loan Watch Record Updated.</b><br />
    </cfif>
</cfif>



<!--- If the user made any changes to the notes for the current tax search loan, those changes are saved here --->
<!--- Please note that this is not tracked, I don't remember why --->
<cfif "I" eq client.custtype or "V" eq client.tw_admin or "R" eq client.tw_admin or "L" eq client.tw_admin or "A" eq client.tw_admin or 0 neq userIsAllowedToEditQry.recordCount>
    <cfif StructKeyExists(form, "save_notes")>
        <cfquery name="stec_mysql_update_notes" datasource="STLinux1MySQL">
            UPDATE
                tax_search_loans
            SET
                last_modified = now(),
                notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.notes#">
            WHERE
                tax_search_loan_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#">
        </cfquery>
        <b>Notes have been updated.</b>
        
            <!---Query for dumping old information into the old loan data table --->
      

        
        <cftransaction>     
        <cfquery name="saveOldLoanInfo2" datasource="STLinux1MySQL">
        INSERT into tax_search_old_loan_data
        (
            tax_search_loan_id,
            frequency_id,
            cycle_id,
            state_id,
            branch,
            borrower,
            address,
            city,
            zip,
            county,
            parcel,
            block,
            lot,
            timeofevent,
            notes
        )
        VALUES
        (
        <cfqueryparam value="#trim(Val(url.tax_search_loan_id))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(Val(form.old_frequency_id2))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(Val(form.old_cycle_id2))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(Val(form.old_state_id2))#" cfsqltype="cf_sql_bigint">,
        <cfqueryparam value="#trim(form.old_branch2)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_street_address2)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_borrower2)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_city2)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_zip2)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_county2)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_parcel2)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_block2)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#trim(form.old_lot2)#" cfsqltype="cf_sql_varchar">,
        Now() ,
        <cfqueryparam value="#trim(form.old_notes2)#" cfsqltype="cf_sql_varchar">
        )
        
        </cfquery>
</cftransaction>
    </cfif>
</cfif>
<!--- If the user removed the current tax search loan from the watch, it is removed here by changing a flag on the tax_search_loans table for the current tax_search_loan_id --->
<cfif "I" eq client.custtype or "A" eq client.tw_admin or 0 neq userIsAllowedToEditQry.recordCount>
    <cfif StructKeyExists(form, "remove_from_watch")>
        <!--- Puts an entry in the log that the current user removed this loan form the watch --->
        <cfquery name="trackQry" datasource="STLinux1MySQL">
            INSERT INTO
                tax_search_track
            SET
                created = 0,
                last_modified = now(),
                created_by = 0,
                last_modified_by = 0,
                pick_userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.userid#">,
                command = 'Remove from watch',
                table_name = 'tax_search_loans',
                id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#">,
                user_ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
        </cfquery>
        <!--- Updates the current tax_search_loan so it is removed form the watch --->
        <cfquery name="updateQry" datasource="STLinux1MySQL">
            UPDATE
                tax_search_loans
            SET
                last_modified = now(),
                active = 'N'
            WHERE
                tax_search_loan_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#">
        </cfquery>
        <b>Loan removed from Tax Watch.</b><br />
    </cfif>
</cfif>

<!--- If the user is editing the fields of the current tax search loan, this is where the form is displayed --->
<cfif "I" eq client.custtype or "A" eq client.tw_admin or 0 neq userIsAllowedToEditQry.recordCount>
    <cfif StructKeyExists(form, "edit")>
        <!--- This will be an array of state ids and abbreviations for the dropdown list of states on the form --->
        <cfquery name="statesQry" datasource="STLinux1MySQL">
        SELECT
            state_id,
            abbreviation
        FROM
            states
        WHERE
            active = 'Y'
        </cfquery>


        

<!--- MySQL ends here --->        

    
        
        <!--- crude way to create a multidimensional array in coldfusion mx 7 --->
        <cfset states = ArrayNew(2)>
        <cfset state_counter = 1>
        <cfloop query="statesQry">

            <cfset states[state_counter][1] = statesQry.state_id>
            <cfset states[state_counter][2] = statesQry.abbreviation>

            <cfset state_counter = state_counter +1>
        </cfloop>

        <!--- Display populated form fields for editing the tax search loan --->
   
        <form method="post">
        <!---Hidden fields to pass old values to old value table--->
         <cfloop query="cloneQry"> 
            <input type="hidden" name="old_loan_identifier" value="#loan_identifier#" >
            <input type="hidden" name="old_loan_officer_id" value="#tax_search_loan_officer_id#">
            <input type="hidden" name="old_branch" value="#branch#">
            <input type="hidden" name="old_borrower" value="#borrower#">
            <input type="hidden" name="old_street_address" value="#address#">
            <input type="hidden" name="old_city" value="#city#">
            <input type="hidden" name="old_state_id" value="#state_id#"> 
            <input type="hidden" name="old_zip" value="#zip#">
            <input type="hidden" name="old_county" value="#county#">
            <input type="hidden" name="old_parcel" value="#parcel#">
            <input type="hidden" name="old_block" value="#block#">
            <input type="hidden" name="old_lot" value="#lot#">
            <input type="hidden" name="old_notes" value="#notes#">
            <input type="hidden" name="old_frequency_id" value="#frequency_id#">
            <input type="hidden" name="old_cycle_id" value="#cycle_id#"> 

        </cfloop>
        
            
            <cfloop query="currentTaxSearchLoanQry">
            <table style="width: 100%;">
                <tr>
                    <td>Loan Identifier</td>
                    <td><input type="text" name="loan_identifier" value="#currentTaxSearchLoanQry.loan_identifier#"></td>
                </tr>
                <tr>
                    <td>Loan Officer</td>
                    <td>
                        <select name="loan_officer_id">
                            <cfset idx_cnt = ArrayLen(loan_officer_ids)>
                            <cfloop from="1" to="#idx_cnt#" index="idx_loan_officer_id">
                                <option value="#loan_officer_ids[idx_loan_officer_id]#"<cfif loan_officer_ids[idx_loan_officer_id] eq currentTaxSearchLoanQry.tax_search_loan_officer_id>selected="selected"</cfif>>#loan_officer_names[idx_loan_officer_id]#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Branch</td>
                    <td><input type="text" name="branch" value="#currentTaxSearchLoanQry.branch#"></td>
                </tr>
                <tr>
                    <td>Borrower</td>
                    <td><input type="text" name="borrower" value="#currentTaxSearchLoanQry.borrower#"></td>
                </tr>
                <tr>
                    <td>Street Address</td>
                    <td><input type="text" name="address" value="#currentTaxSearchLoanQry.address#"></td>
                </tr>
                <tr>
                    <td>City</td>
                    <td><input type="text" name="city" value="#currentTaxSearchLoanQry.city#"></td>
                </tr>
                <tr>
                    <td>State</td>
                    <td>
                        <select name="state_id">
                            <cfloop index="state_idx" from="1" to="#ArrayLen(states)#">
                                <option value="#states[state_idx][1]#"<cfif states[state_idx][1] eq currentTaxSearchLoanQry.state_id> selected="selected"</cfif>>#states[state_idx][2]#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Zip</td>
                    <td><input type="text" name="zip" value="#currentTaxSearchLoanQry.zip#"></td>
                </tr>
                <tr>
                    <td>County</td>
                    <td><input type="text" name="county" value="#currentTaxSearchLoanQry.county#"></td>
                </tr>
                <tr>
                    <td>Parcel</td>
                    <td><input type="text" name="parcel" value="#currentTaxSearchLoanQry.parcel#"></td>
                </tr>
                <tr>
                    <td>Block</td>
                    <td><input type="text" name="block" value="#currentTaxSearchLoanQry.block#"></td>
                </tr>
                <tr>
                    <td>Lot</td>
                    <td><input type="text" name="lot" value="#currentTaxSearchLoanQry.lot#"></td>
                </tr>
                <tr>
                    <td>
                        <input type="submit" name="save_changes" value="Save">
                    </td>
                    <td align="right">
                        <input type="submit" name="cancel" value="Cancel">
                    </td>
                <tr>
            </table>
        </form>
        </cfloop>
    </cfif>
</cfif>

<!--- This is where the tax search loan details will be displayed.  They are only displayed when you are not editing the tax search loan. --->
<cfif not StructKeyExists(form, "edit")>

    <!--- Get current delinquency status --->
    <cfquery name="mostRecentDelinquencyStatusQry" datasource="STLinux1MySQL">
        SELECT
            SUM(IF(tsr.delinquency_status = 'Current', 0, tsr.delinquency_status)) as delinquency_status
        FROM tax_search_loans tsl
        LEFT JOIN tax_searches ts
        ON tsl.tax_search_loan_id = ts.tax_search_loan_id
        LEFT JOIN tax_search_statuses tss
        ON ts.current_tax_search_status_id = tss.tax_search_status_id
        LEFT JOIN tax_search_results tsr
        ON ts.tax_search_id = tsr.tax_search_result_id
        WHERE
            tsl.tax_search_loan_id = <cfqueryparam value="#url.tax_search_loan_id#" cfsqltype="cf_sql_varchar"> AND
            tsl.active = 'Y' AND
            ts.active = 'Y' AND
            tss.active = 'Y' AND
            tss.name != 'Open'
        GROUP BY
            ts.tax_search_id
        ORDER BY
            ts.tax_search_id DESC
        LIMIT 1
    </cfquery>

    <!--- Display current loan information --->
    <table style="width: 100%;">
        <cfif "N" eq currentTaxSearchLoanQry.active>
            <tr>
                <td colspan="4">This Loan is no longer in the watch list.</td>
            </tr>
        </cfif>
        <tr valign="top">
            <td colspan="4"><cfif "" eq currentTaxSearchLoanQry.pick_userid>#currentTaxSearchLoanQry.name#<cfelse>#currentTaxSearchLoanQry.pick_userid#</cfif><cfif 0 neq mostRecentDelinquencyStatusQry.recordCount> - </cfif><cfif mostRecentDelinquencyStatusQry.delinquency_status neq ""><cfif mostRecentDelinquencyStatusQry.delinquency_status neq 0><span style="color: red">Delinquent</span><cfelse>Current</cfif> - </cfif>#currentTaxSearchLoanQry.borrower#</td>
        </tr>
        <tr valign="top" style="background-color: ##3E5775;">
            <td><font size="+1" color="White"><b>Address<br>Block & Lot / Parcel</b></td>
            <td><font size="+1" color="White"><b>Branch</b></td>
            <td><font size="+1" color="White"><b>Borrower</b></td>
            <td><font size="+1" color="White"><b>Loan Identifier</b></td></font>
        </tr>
        <tr valign="top" style="background-color: ##C8D4E3;">
            <td>#currentTaxSearchLoanQry.address# #currentTaxSearchLoanQry.city#, #currentTaxSearchLoanQry.state_abbreviation# #currentTaxSearchLoanQry.zip#; #currentTaxSearchLoanQry.county#<br>
            <cfif "" neq currentTaxSearchLoanQry.block>
                #currentTaxSearchLoanQry.block# & #currentTaxSearchLoanQry.lot#
            <cfelse>
                #currentTaxSearchLoanQry.parcel#
            </cfif>
            </td>
            <td>#currentTaxSearchLoanQry.branch#</td>
            <td>#currentTaxSearchLoanQry.borrower#</td>
            <td>#currentTaxSearchLoanQry.loan_identifier#</td>
        </tr>
        <cfif "I" eq client.custtype or "V" eq client.tw_admin or "A" eq client.tw_admin or "R" eq client.tw_admin or "L" eq client.tw_admin or 0 neq userIsAllowedToEditQry.recordCount>
            <cfif "V" neq client.tw_admin and "R" neq client.tw_admin and "L" neq client.tw_admin>
            <tr>
                <td>
                    <form method="post">
                        <input type="submit" name="edit" value="Edit">
                    </form>
                </td>
                <td></td>
                <td></td>
                <td align="right">
                    <form method="post">
                        <input type="submit" name="remove_from_watch" value="Remove From Watch">
                    </form>
                </td>
            </tr>
            </cfif>
            <tr>
                <td colspan="4" style="text-align: center;">Notes</td>
            </tr>
            <tr>
                <td colspan="4">
                    <form action="" method="post">
            
                     <cfloop query="cloneQry"> 
            <input type="hidden" name="old_loan_identifier2" value="#loan_identifier#" >
            <input type="hidden" name="old_loan_officer_id2" value="#tax_search_loan_officer_id#">
            <input type="hidden" name="old_branch2" value="#branch#">
            <input type="hidden" name="old_borrower2" value="#borrower#">
            <input type="hidden" name="old_street_address2" value="#address#">
            <input type="hidden" name="old_city2" value="#city#">
            <input type="hidden" name="old_state_id2" value="#state_id#"> 
            <input type="hidden" name="old_zip2" value="#zip#">
            <input type="hidden" name="old_county2" value="#county#">
            <input type="hidden" name="old_parcel2" value="#parcel#">
            <input type="hidden" name="old_block2" value="#block#">
            <input type="hidden" name="old_lot2" value="#lot#">
            <input type="hidden" name="old_notes2" value="#notes#">
            <input type="hidden" name="old_frequency_id2" value="#frequency_id#">
            <input type="hidden" name="old_cycle_id2" value="#cycle_id#"> 

                    </cfloop>
                    
                       <textarea name="notes" cols="80" rows="5">#currentTaxSearchLoanQry.notes#</textarea><br />
                        <input type="submit" name="save_notes" value="Save Notes">
                    </form>
                </td>
            </tr>
        <cfelse>
            <tr>
                <td colspan="4" style="text-align: center;">Notes</td>
            </tr>
            <tr>
                <td colspan="4">
                    #currentTaxSearchLoanQry.notes#
                </td>
            </tr>
        </cfif>
        <tr>
            <td colspan="4"><hr></td>
        </tr>
    </table>
    
    <!--- get most recent tax search or the one specified in the url --->
    <cfquery name="selectedTaxSearchQry" datasource="STLinux1MySQL">
        SELECT
            ts.tax_search_id,
            DATE_FORMAT(ts.search_date, "%c/%e/%Y") as search_date,
            tss.name as status_name
        FROM tax_search_loans tsl
        LEFT JOIN tax_searches ts
        ON tsl.tax_search_loan_id = ts.tax_search_loan_id
        LEFT JOIN tax_search_statuses tss
        ON ts.current_tax_search_status_id = tss.tax_search_status_id
        WHERE
            tsl.tax_search_loan_id = <cfqueryparam value="#url.tax_search_loan_id#" cfsqltype="cf_sql_varchar"> AND
            tsl.active = 'Y' AND
            ts.active = 'Y' AND
            tss.active = 'Y'
        <cfif StructKeyExists(url, "tax_search_id")>
            AND ts.tax_search_id = <cfqueryparam value="#url.tax_search_id#" cfsqltype="cf_sql_varchar">
        </cfif>
        ORDER BY
            ts.tax_search_id DESC
    </cfquery>
    <!--- <cfdump var="#selectedTaxSearchQry#"> --->

    <!--- get the tax search results for the specified tax search --->
    <cfif selectedTaxSearchQry.recordCount neq 0>
        <cfquery name="taxSearchResultsQry" datasource="STLinux1MySQL">
            SELECT tsr.*
            FROM tax_search_results tsr
            WHERE
                tsr.active = 'Y' AND
                tsr.tax_search_id = #selectedTaxSearchQry.tax_search_id#
            ORDER BY
                tsr.tax_search_result_id DESC
        </cfquery>
        <!--- <cfdump var="#taxSearchResultsQry#"> --->
    </cfif>
    
    <!--- get the history of tax_searches not including the currently selected tax_search_id --->
    <cfif selectedTaxSearchQry.recordCount neq 0>
        <cfquery name="taxSearchHistoryQry" datasource="STLinux1MySQL">
            SELECT
                ts.tax_search_id,
                DATE_FORMAT(ts.search_date, "%c/%e/%Y") as search_date
            FROM tax_search_loans tsl
            LEFT JOIN tax_searches ts
            ON tsl.tax_search_loan_id = ts.tax_search_loan_id
            LEFT JOIN tax_search_statuses tss
            ON ts.current_tax_search_status_id = tss.tax_search_status_id
            WHERE
                tsl.tax_search_loan_id = <cfqueryparam value="#url.tax_search_loan_id#" cfsqltype="cf_sql_varchar"> AND
                tsl.active = 'Y' AND
                ts.active = 'Y' AND
                tss.active = 'Y' AND
                ts.tax_search_id != #selectedTaxSearchQry.tax_search_id#
            ORDER BY
                ts.tax_search_id DESC
        </cfquery>
        <!--- <cfdump var="#taxSearchHistoryQry#"> --->
    </cfif>

<!--- Not finished - GCG 9/26/2012 approximately 1 am 
lines 495 - 710 are wrong still
--->
    
    <cfquery name="stec_mysql_tax_searches" datasource="STLinux1MySQL">
    SELECT
        tsl.active as watch_status,
        ts.tax_search_id,
        tss.name as status_name,
        DATE_FORMAT(ts.search_date, "%c/%e/%Y") as search_date,
        tsl.tax_search_loan_id,
        tsl.loan_identifier,
        tsl.address,
        tsl.city,
        states.abbreviation as state_abbreviation,
        tsl.zip,
        tsl.county,
        tsl.borrower,
        tsl.branch,
        tsl.block,
        tsl.lot,
        tsl.parcel,
        tsl.notes,
        tsl.frequency_id,
        tsl.cycle_id,
        tslo.name,
        tslo.pick_userid,
        SUM(tsr.delinquency_status) as total_delinquency_status
    FROM
        tax_searches ts
    LEFT JOIN
        tax_search_loans tsl
    ON
        (ts.tax_search_loan_id = tsl.tax_search_loan_id)
    LEFT JOIN
        states
    ON
        (tsl.state_id = states.state_id)
    LEFT JOIN
        tax_search_loan_officers tslo
    ON
        (tsl.tax_search_loan_officer_id = tslo.tax_search_loan_officer_id)
    LEFT JOIN
        tax_search_statuses tss
    ON
        (tss.tax_search_status_id = ts.current_tax_search_status_id)
    LEFT JOIN
        tax_search_results tsr
    ON
        (tsr.tax_search_id = ts.tax_search_id)
    WHERE
        tsl.tax_search_loan_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#"> AND
        ts.active = 'Y'
    GROUP BY
        ts.tax_search_id
    ORDER BY
        ts.tax_search_id DESC
    </cfquery>

    <cfset first_time_through = 1>

    <table width="100%">
        <tr>
            <td style="text-align: center;">
                <b><font size="+2">Tax Search Results</b>
            </td>
        </tr>
    </table>
    
    <cfif 0 eq stec_mysql_tax_searches.recordcount>
        No Tax Search has been Completed yet.
    <cfelse>
        <cfloop query="stec_mysql_tax_searches">
            <table style="width: 100%;">
                <tr>
                    <td colspan="2"><b>TAX SEARCH DATE:</b> <span style="color: blue;">#stec_mysql_tax_searches.search_date#</span><P></td>
                </tr>
            <cfif client.custtype eq "I">
                <tr>
                    <td colspan="4"><a href="add_tax_search_result.cfm?tax_search_loan_id=#url.tax_search_loan_id#&tax_search_id=#stec_mysql_tax_searches.tax_search_id#">Add Tax Search Result</a></td>
                </tr>
            </cfif>

            <cfif "Open" eq stec_mysql_tax_searches.status_name>
                <tr>
                    <td colspan="4"><!-- Order placed:  -->#stec_mysql_tax_searches.search_date# <!-- - Waiting for tax search results. --></td>
                </tr>
            <cfelse>

                <cfquery name="stec_mysql_tax_search_results" datasource="STLinux1MySQL">
                SELECT
                    tsr.tax_search_result_id,
                    tsr.address as result_address,
                    tsr.borrower as result_borrower,
                    tsr.block as result_block,
                    tsr.lot as result_lot,
                    tsr.parcel as result_parcel,
                    tsr.delinquency_status,
                    tsr.municipality,
                    tsr.quarter_data,
                    tsr.additional_info,
                    tsr.liens,
                    DATE_FORMAT(tsr.cover_date, "%c/%e/%Y") as cover_date,
                    DATE_FORMAT(tsr.created, "%c/%e/%Y") as completed_date
                FROM
                    tax_search_results tsr
                WHERE
                    tsr.active = 'Y' AND
                    tsr.tax_search_id =  <cfqueryparam cfsqltype="cf_sql_integer" value="#stec_mysql_tax_searches.tax_search_id#">
                ORDER BY
                    tsr.tax_search_result_id DESC
                </cfquery>

                <tr>
                    <td>
                <cfif 0 eq stec_mysql_tax_search_results.recordcount>
                    No Results Found for Closed Tax Search.
                <cfelse>

                    <table>
                        <tr valign="top" style="background-color: ##3E5775;">
                            <cfif client.custtype eq "I">
                                <td style="color: white; font-weight: bold;">Tools</td>
                            </cfif>
                            <td style="color: white; font-weight: bold;">Delinquency<br />Status</td>
                            <td style="color: white; font-weight: bold;">Cover&nbsp;Date</td>
                            <td style="color: white; font-weight: bold; width: 160px;">Address<br>Block & Lot / Parcel</td>
                            <td style="color: white; font-weight: bold;">Assessed&nbsp;Owner</td>
                            <td style="color: white; font-weight: bold;">Municipality</td>
                            <td style="color: white; font-weight: bold;">Pdf</td>
                        </tr>
                    <cfset i_counter = 0>
                    <cfloop query="stec_mysql_tax_search_results">

                        <tr valign="top" style="background-color: <cfif BitAnd(i_counter, 1) is 0>##FFFFFF<cfelse>##C8D4E3</cfif>;">
                            <cfif client.custtype eq "I">
                                <td>
                                    <a href="edit_tax_search_result.cfm?tax_search_result_id=#stec_mysql_tax_search_results.tax_search_result_id#">Edit</a>
                                    <a href="delete_tax_search_result.cfm?tax_search_loan_id=#url.tax_search_loan_id#&tax_search_result_id=#stec_mysql_tax_search_results.tax_search_result_id#">Delete</a>
                                </td>
                            </cfif>
                            <td>
                                <cfif 'Current' neq stec_mysql_tax_search_results.delinquency_status and '' neq stec_mysql_tax_search_results.delinquency_status>$</cfif>#stec_mysql_tax_search_results.delinquency_status#
                            </td>
                            <td>
                                #stec_mysql_tax_search_results.cover_date#
                            </td>
                            <td>#stec_mysql_tax_search_results.result_address#<br>
                                <cfif "" neq stec_mysql_tax_search_results.result_block>
                                    #stec_mysql_tax_search_results.result_block# & #stec_mysql_tax_search_results.result_lot#
                                <cfelse>
                                    #stec_mysql_tax_search_results.result_parcel#
                                </cfif>
                            </td>
                            <td>#stec_mysql_tax_search_results.result_borrower#</td>
                            <td>#stec_mysql_tax_search_results.municipality#</td>
                            <cfif 740 gt stec_mysql_tax_search_results.tax_search_result_id>
                                <td>
                                    <a href="/taxProjects/3.pdf" target="new"><img src="/images/pdf_icon.gif" title="view Pdf" border="0"></a>
                                </td>
                            <cfelse>
                                <td>
                                    <cfset myfilter = "#stec_mysql_tax_search_results.tax_search_result_id#*.pdf">
                                    <cfdirectory
                                       directory="\\\\fileserver\\tax_projects\\results\\"
                                       name="myDirectory"
                                       sort="name ASC, size DESC"
                                       filter="#myfilter#">

                                    <cfloop query="myDirectory">
                                        <a href="/taxProjects/results/#myDirectory.Name#" title="#myDirectory.Name#" target="new"><img src="/images/pdf_icon.gif" border="0" /></a>
                                    </cfloop>
<!--- this is temporary and should be commented after pdfs are correctly associated --->
                                    <cfset myfilter = "#currentTaxSearchLoanQry.loan_identifier#*.pdf">
                                    <cfdirectory
                                       directory="\\\\fileserver\\tax_projects\\results\\"
                                       name="myDirectory"
                                       sort="name ASC, size DESC"
                                       filter="#myfilter#">

                                    <cfloop query="myDirectory">
                                        <a href="/taxProjects/results/#myDirectory.Name#" title="#myDirectory.Name#" target="new"><img src="/images/pdf_icon.gif" border="0" /></a>
                                    </cfloop>
<!--- end of temporary code --->
                                </td>
                            </cfif>
                        </tr>
                        <cfif StructKeyExists(stec_mysql_tax_search_results, "quarter_data") and "" neq stec_mysql_tax_search_results.quarter_data>
                            <tr valign="top" style="background-color: <cfif BitAnd(i_counter, 1) is 0>##FFFFFF<cfelse>##C8D4E3</cfif>;">
                                <td colspan="7"><b>Quarters:</b> #stec_mysql_tax_search_results.quarter_data#<P></td>
                            </tr>
                        </cfif>
                        <cfif StructKeyExists(stec_mysql_tax_search_results, "additional_info") and "" neq stec_mysql_tax_search_results.additional_info>
                            <tr valign="top" style="background-color: <cfif BitAnd(i_counter, 1) is 0>##FFFFFF<cfelse>##C8D4E3</cfif>;">
                                <td colspan="7"><b>Additional Info:</b> #stec_mysql_tax_search_results.additional_info#</td>
                            </tr>
                        </cfif>
                        <cfif StructKeyExists(stec_mysql_tax_search_results, "liens") and "" neq stec_mysql_tax_search_results.liens>
                            <tr valign="top" style="background-color: <cfif BitAnd(i_counter, 1) is 0>##FFFFFF<cfelse>##C8D4E3</cfif>;">
                                <td><b>LIENS:</b></td>
                                <td colspan="6">#stec_mysql_tax_search_results.liens#</td>
                            </tr>
                        </cfif>
<!--- This is the tax watch history section
                        <div style="width: 100%; background-color: ##DDDDDD;">HISTORY<br />Prior Tax Searches<br />
                        <a href="/secure/onguard/tax_loan_details.cfm?tax_search_loan_id=#url.tax_search_loan_id#&tax_search_id=#stec_mysql_tax_search_results.tax_search_id#">#stec_mysql_tax_search_results.completed_date#</a><span style="width: 20px;">&nbsp;</span>
                        </div>
--->
                        <cfset i_counter = i_counter +1>
                    </cfloop>
                    </table>
                </cfif>
                </td>
            </tr>
            </cfif>
        </table>
        </cfloop>
    </cfif>

<!--- Frequency / Cycle Form --->
    <cfif "I" eq client.custtype or "A" eq client.tw_admin or 0 neq userIsAllowedToEditQry.recordCount>
        <script language="javascript">
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
        <hr>
        <form method="post">
         <cfloop query="cloneQry"> 
            <input type="hidden" name="old_loan_identifier3" value="#loan_identifier#" >
            <input type="hidden" name="old_loan_officer_id3" value="#tax_search_loan_officer_id#">
            <input type="hidden" name="old_branch3" value="#branch#">
            <input type="hidden" name="old_borrower3" value="#borrower#">
            <input type="hidden" name="old_street_address3" value="#address#">
            <input type="hidden" name="old_city3" value="#city#">
            <input type="hidden" name="old_state_id3" value="#state_id#"> 
            <input type="hidden" name="old_zip3" value="#zip#">
            <input type="hidden" name="old_county3" value="#county#">
            <input type="hidden" name="old_parcel3" value="#parcel#">
            <input type="hidden" name="old_block3" value="#block#">
            <input type="hidden" name="old_lot3" value="#lot#">
            <input type="hidden" name="old_notes3" value="#notes#">
            <input type="hidden" name="old_frequency_id3" value="#frequency_id#">
            <input type="hidden" name="old_cycle_id3" value="#cycle_id#"> 

                    </cfloop>
                    
       <table>
            <tr>
             <td colspan="3" style="text-align: LEFT;"><b><font size="+1">Auto Run</font></b></td>
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
                        <option value="1" <cfif 1 eq currentTaxSearchLoanQry.frequency_id>selected="selected"</cfif>>Annually</option>
                        <option value="2" <cfif 2 eq currentTaxSearchLoanQry.frequency_id>selected="selected"</cfif>>Bi-Annually</option>
                        <option value="3" <cfif 3 eq currentTaxSearchLoanQry.frequency_id>selected="selected"</cfif>>Quarterly</option>
                    </select>
                </td>
                <td>&nbsp;</td>
                <td>
                    <select name="cycle_id" id="cycle_id">
                        <cfif 1 eq currentTaxSearchLoanQry.frequency_id>
                            <option value="1" <cfif 1 eq currentTaxSearchLoanQry.cycle_id>selected="selected"</cfif>>1st</option>
                            <option value="2" <cfif 2 eq currentTaxSearchLoanQry.cycle_id>selected="selected"</cfif>>2nd</option>
                            <option value="3" <cfif 3 eq currentTaxSearchLoanQry.cycle_id>selected="selected"</cfif>>3rd</option>
                            <option value="4" <cfif 4 eq currentTaxSearchLoanQry.cycle_id>selected="selected"</cfif>>4th</option>
                        <cfelse>
                            <cfif 2 eq currentTaxSearchLoanQry.frequency_id>
                                <option value="5" <cfif 5 eq currentTaxSearchLoanQry.cycle_id>selected="selected"</cfif>>1st and 3rd</option>
                                <option value="6" <cfif 6 eq currentTaxSearchLoanQry.cycle_id>selected="selected"</cfif>>2nd and 4th</option>
                            <cfelse>
                                <cfif 3 eq currentTaxSearchLoanQry.frequency_id>
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
                <td colspan="3">
                    <input type="submit" name="set_cycles" value="Set Frequency/Cycle">
                </td>
            </tr>
        </table>
        </form>
<!--- Order update button --->
        <table>
            <tr>
                <td colspan="3">&nbsp;</td>
            </tr>
            <tr>
                <!--- only allow the Order Update button if there is not an open tax search --->
                <cfquery name="isThereAnOpenTaxSearchQry" datasource="STLinux1MySQL">
                SELECT
                    ts.tax_search_id
                FROM tax_searches ts
                LEFT JOIN tax_search_loans tsl
                ON ts.tax_search_loan_id = tsl.tax_search_loan_id
                LEFT JOIN tax_search_statuses tss
                ON tss.tax_search_status_id = ts.current_tax_search_status_id
                WHERE
                    tsl.tax_search_loan_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.tax_search_loan_id#"> AND
                    tss.name = 'Open'
                GROUP BY
                    ts.tax_search_id
                ORDER BY
                    ts.tax_search_id DESC
                LIMIT 1
                </cfquery>

                <cfif isThereAnOpenTaxSearchQry.recordCount eq 0>
                    <td colspan="3"><form method="post"><input type="hidden" name="order_update" value="yes"><input type="image" src="/images/upd.gif"></form></td>
                <cfelse>
                    <td colspan="3"><img src="/images/updgrey.gif"></td>
                </cfif>
            </tr>
        </table>
    </cfif>
</cfif>
</cfoutput>