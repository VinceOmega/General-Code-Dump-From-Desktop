<!---vars for url vars --->
<cfparam name="url.start_date" default="">
<cfparam name="url.start_end" default="">
<cfparam name="fqText" default="">
<cfparam name="cText" default="">

<!--- alt classes for var --->
<cfset s = 0>
<cfset class= "">

<!--- vars for pagination ---> 
<cfif IsDefined('url.start')>
<cfset perPage = "20">
<cfparam name="url.start" default="1">
<cfparam name="perPage" default="20">
<cfset i = 0>
<cfset i = url.start>
</cfif>

<!--- Generate Header--->
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
</cfif>

<!--- MySQL queries begins here --->

<cfquery name="setec_old_loan_results" datasource="STLinux1MySQL" result="meta_tracking">
Select
  tsold.*,
  states.name
From
  tax_search_old_loan_data tsold LEFT JOIN
  states ON tsold.state_id = states.state_id
WHERE
tsold.tax_search_loan_id = <cfqueryparam value="#url.loan_id#" cfsqltype="cf_sql_bigint">

	<cfif isDefined("url.start_date")>
 		<cfif url.start_date eq "">
			<cfset url.start_date = '2010-01-01'>
		</cfif>
		<cfif url.end_date eq "">
			<cfset url.end_date = DateFormat(now(), 'yyyy-mm-dd')>
		</cfif>
AND
(tsold.timeofevent >= <cfqueryparam value="#Trim(url.start_date)#" cfsqltype="cf_sql_date">
AND 
tsold.timeofevent < <cfqueryparam value="#dateAdd('d', 1, Trim(url.end_date))#" cfsqltype="cf_sql_date">)

 	</cfif>
</cfquery>

<!--- MySQL queries end here --->

<!---User Input Section--->

<div class="btn-shelf">
<cfform method="get">
	<cfinput type="hidden" value="#url.loan_id#" name="loan_id">
	<cfinput class="input date-start" name="start_date" placeholder="  Select a date" title="You can filter by date, this is the starting point for a date to search by. You can also leave this blank if you want." ><cfinput class="input date-end" name="end_date" placeholder="  Select a date" title="You can filter by date, this is the ending point for a date to search by. You can also leave this blank if you want.">
		<cfinput type="submit" class="btn-small" name="submit" value="filter">
</cfform>
		<a href="tax_watch_loan_tracker.cfm" class="btn-small">Back to Tracker</a>
</div>
<hr>


<!--- Content --->
	<table class="main_body">
		<tr class="tracking_header">

			<th>
			Frequency
			</th>
			
			<th>
			Cycle
			</th>
			
			<th>
			State
			</th>
			
			<th>
			Branch
			</th>
			
			<th>
			Borrower
			</th>
			
			<th>
			Address
			</th>
			
			<th>
			City
			</th>
			
			<th>
			Zip
			</th>
			
			<th>
			County
			</th>
			
			<th>
			Parcel
			</th>
			
			<th>
			Block
			</th>
			
			<th>
			Lot
			</th>
			
			<th>
			Time and Date
			</th>
			
			<th>
			Notes
			</th>
			
	
		</tr>
<cfif StructKeyExists(url, "loan_id")>	
	<cfoutput query="setec_old_loan_results">
<cfif s MOD 2 eq 0>
<cfset class= "white">
<cfelse>
<cfset class= "gray">
</cfif>
<cfset s = s+1>
		<tr class="info_row #class#">
		<cfswitch expression= "#frequency_id#">
			<cfcase value = 1>
				<cfset fqText = "Annually">
			</cfcase>
			
			<cfcase value = 2>
				<cfset fqText = "Bi-Annually">
			</cfcase>
			
			<cfcase value = 3>
				<cfset fqText = "Quarterly">
			</cfcase>
		</cfswitch>
		
		<cfswitch expression= "#cycle_id#">
			<cfcase value = 1>
				<cfset cText = "1st">
			</cfcase>
			
			<cfcase value = 2>
				<cfset cText = "2nd">
			</cfcase>
			
			<cfcase value = 3>
				<cfset cText = "3nd">
			</cfcase>
			
			<cfcase value = 4>
				<cfset cText = "4th">
			</cfcase>
			
			<cfcase value = 5>
				<cfset cText = "1st and 3rd">
			</cfcase>
			
			<cfcase value = 6>
				<cfset cText = "2nd and 4th">
			</cfcase>
		</cfswitch>
		

			<td>
			#fqText#
			</td>
			
			<td>
			#cText#
			</td>
			
			<td>
			#name#
			</td>
			
			<td>
			#branch#
			</td>
			
			<td>
			#borrower#
			</td>
			
			<td>
			#address#
			</td>
			
			<td>
			#city#
			</td>
			
			<td>
			#zip#
			</td>
			
			<td>
			#county#
			</td>
			
			<td>
			#parcel#
			</td>
			
			<td>
			#block#
			</td>
			
			<td>
			#lot#
			</td>
			
			<td>
			#timeofevent#
			</td>
			
			<td>
			#notes#
			</td>
			
		
		</tr>
	</cfoutput>
	
</cfif>
	</table>

<!---
<cfoutput>
<pre>
#meta_tracking.sql#
</pre>
</cfoutput>
--->
<!---Content End --->