<!--- vars for url vars --->
<cfparam name="url.start_date" default="">
<cfparam name="url.end_date" default="">
<cfparam name="url.start" default = "">
<cfparam name="fqText" default="">
<cfparam name="cText" default="">

<!--- alt classes for var --->
<cfset s = 0>
<cfset class= "">

<!--- <cfif IsDefined('url.cnt')>
<cfset cnt = url.cnt>
<cfelse>
<cfset cnt = 0>
</cfif>

<cfset rowcnt = 0>

<cfset startpos = cnt + 1>


<!--- vars for pagination ---> 
<cfif isDefined('url.start')>
<cfset perPage = "20">
<cfparam name="url.start" default="1">
<cfparam name="perPage" default="20">
<cfset i = 0>
<cfset i = url.start>
</cfif>
 --->
<!--- Debug vars--->
<cfdump var="#url#">
<!--- <cfif isDefined('#setec_diff#')>
<cfdump var="#setec_diff#">
</cfif>--->
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
<cfif StructKeyExists(url, 'loan_id')>
<cfquery name="setec_diff" datasource="STLinux1MySQL" result="meta_tracking">
Select
  tdiff.*
From
  tax_search_diff_table tdiff 
WHERE
tdiff.tax_search_loan_id = <cfqueryparam value="#url.loan_id#" cfsqltype="cf_sql_int">

	<cfif isDefined("url.start_date")>
 		<cfif url.start_date eq "">
			<cfset url.start_date = '2010-01-01'>
		</cfif>
		<cfif url.end_date eq "">
			<cfset url.end_date = DateFormat(now(), 'yyyy-mm-dd')>
		</cfif>
AND
(tdiff.timeofedit >= <cfqueryparam value="#Trim(url.start_date)#" cfsqltype="cf_sql_date">
AND 
tdiff.timeofedit < <cfqueryparam value="#dateAdd('d', 1, Trim(url.end_date))#" cfsqltype="cf_sql_date">)

 	</cfif>

<cfif StructKeyExists(url, 'data_type')>
	<cfif url.data_type NEQ "">
AND

tdiff.field_name = <cfqueryparam value="#trim(url.data_type)#" cfsqltype="cf_sql_varchar">
	</cfif>

</cfif>


</cfquery>

</cfif>

<!--- MySQL queries end here --->

<!---User Input Section--->

<div class="btn-shelf">
<cfform method="get">
	<cfinput type="hidden" value="#url.loan_id#" name="loan_id">
	<cfinput class="input date-start" name="start_date" placeholder="  Select a date" title="You can filter by date, this is the starting point for a date to search by. You can also leave this blank if you want." ><cfinput class="input date-end" name="end_date" placeholder="  Select a date" title="You can filter by date, this is the ending point for a date to search by. You can also leave this blank if you want.">
	<cfselect class="input data-type"  name="data_type" placeholder="  Select a field to search by" title="You can filter by field name (i.e. search by city, branch, etc...), the value 'All' returns all field types.">
	<option value="">All</option>
	<option value="branch">Branch</option>
	<option value="address">Street Address</option>
	<option value="city">City</option>
	<option value="state">State</option>
	<option value="zip">Zip</option>
	<option value="county">County</option>
	<option value="parcel">Parcel</option>
	<option value="block">Block</option>
	<option value="lot">Lot</option>
	<option value="frequency">Frequency</option>
	<option value="cycle">Cycle</option>
	<option value="notes">Notes</option>
	</cfselect>
		<cfinput type="submit" class="btn-small" name="submit" value="filter">
</cfform>
		<a href="tax_watch_loan_tracker.cfm" class="btn-small">Back to Tracker</a>
</div>
<hr>


<!--- Content --->
	<table class="main_body">
		<tr class="tracking_header">

	
			
			<th>
			Field
			</th>
			
			<th>
			Old Value
			</th>
			
			<th>
			New Value
			</th>
			
			<th>
			Time
			</th>
			
			<th>
			Date
			</th>
			
		</tr>
<cfif isDefined('url.loan_id')>	
<cfoutput query="setec_diff" startrow="#url.start#" maxRows="#perPage#">
<!--- 	<cfset totalRecords = setec_diff.RecordCount>
<cfset startRow = 1>
<cfset endRow = min(startRow + perPage-1, totalRecords)>
<cfif endRow gt totalRecords>
	<cfset endRow = totalRecords>
</cfif>  --->


<cfif s MOD 2 eq 0>
<cfset class= "white">
<cfelse>
<cfset class= "gray">
</cfif>

<cfset s = s+1>
		<tr class="info_row #class#">
			<cfswitch expression= "#field_name#">
			<cfcase value = 'frequency'>
				<cfswitch expression= "#old_value#">
			<cfcase value = 1>
				<cfset oldFqText = "Annually">
			</cfcase>
			
			<cfcase value = 2>
				<cfset oldFqText = "Bi-Annually">
			</cfcase>
			
			<cfcase value = 3>
				<cfset oldFqText = "Quarterly">
			</cfcase>
				</cfswitch>
					<cfswitch expression= "#new_value#">
			<cfcase value = 1>
				<cfset newFqText = "Annually">
			</cfcase>
			
			<cfcase value = 2>
				<cfset newFqText = "Bi-Annually">
			</cfcase>
			
			<cfcase value = 3>
				<cfset newFqText = "Quarterly">
			</cfcase>
				</cfswitch>

			</cfcase>
			
			<cfcase value = 'cycle'>
				<cfswitch expression= "#old_value#">
			<cfcase value = 1>
				<cfset olfCText = "1st">
			</cfcase>
			
			<cfcase value = 2>
				<cfset oldCText = "2nd">
			</cfcase>
			
			<cfcase value = 3>
				<cfset oldCText = "3nd">
			</cfcase>
			
			<cfcase value = 4>
				<cfset oldCText = "4th">
			</cfcase>
			
			<cfcase value = 5>
				<cfset oldCText = "1st and 3rd">
			</cfcase>
			
			<cfcase value = 6>
				<cfset oldCText = "2nd and 4th">
			</cfcase>
			</cfswitch>

				<cfswitch expression= "#new_value#">
			<cfcase value = 1>
				<cfset newCText = "1st">
			</cfcase>
			
			<cfcase value = 2>
				<cfset newCText = "2nd">
			</cfcase>
			
			<cfcase value = 3>
				<cfset newCText = "3nd">
			</cfcase>
			
			<cfcase value = 4>
				<cfset newCText = "4th">
			</cfcase>
			
			<cfcase value = 5>
				<cfset newCText = "1st and 3rd">
			</cfcase>
			
			<cfcase value = 6>
				<cfset newCText = "2nd and 4th">
			</cfcase>
		</cfswitch>
		
			</cfcase>
			
		</cfswitch>
		
		

			<td>
			#field_name#
			</td>
			
			<td>
			<cfif #field_name# EQ 'frequency'>
			#oldFqText#

			<cfelseif #field_name# EQ 'cycle'>
			#oldCText#

			<cfelse>
			#old_value#

			</cfif>
			</td>
			
			<td>
			<cfif #field_name# EQ 'frequency'>
			#newFqText#

			<cfelseif #field_name# EQ 'cycle'>
			#newCText#

			<cfelse>
			#new_value#

			</cfif>
			</td>
			
			
			<td>
			#timeFormat(timeofedit, "h:m:ss")#
			</td>
			
			<td>
			#dateFormat(timeofedit, "m/d/yyyy")#
			</td>
			
			<!--- <cfset rowcnt = rowcnt + 1>
			<cfset cnt = cnt + 1>
			<cfif cnt gt total>
					<cfset cnt = total>
				</cfif>
			<cfset endpos = cnt> --->
			
		</tr>
	</cfoutput>
	
<!--- <cfif total neq 0>

<cfif endpos gt total>
	<cfset endpos = total>
</cfif>

<!--- Keeps startpos lower than endpos --->
		<cfif startpos gte endpos>
				<cfif endpos eq total>
					<cfset startpos = endpos>
				<cfelse>
					<cfloop condition="startpos gte endpos">
							<cfset startpos - 1>
					</cfloop>
			</cfif>
		</cfif>

<!--- --->
	<cfoutput>

		<tr class="count">
			<td colspan="7" title="Counts the current position of the search against the total amount of records">#startpos#-#endpos#/#total#</td>
		</tr>
	
	</cfoutput>
			</cfif> --->

<!--- 
			<cfif setec_diff.recordcount gte 20>
	

<cfset cntmore = cnt + 300>
<cfset cntless = cnt - 300>

<cfset begin = 1>
<cfset prev = i - perPage>
<cfset next = i + perPage>
<cfset last = totalRecords>
<cfset threeohohless = i - 300>
<cfset threeohohmore = i + 300>
<cfset cntprev = cnt - perPage>
	<cfif StructKeyExists(url, "cnt")>
		<cfset cntprev = url.cnt - perPage>
	</cfif> 

<cfif prev lte 0>
	<cfset prev = 1>

</cfif>

<cfif threeohohless lte 0>
	<cfset threeohohless = 1>
	<cfset cntless = 0>
</cfif>

<cfif next gt endRow>
<cfset next = next - 1>
</cfif>
<cfif threeohohmore gt endRow>
	<cfset threeohohmore = threeohohmore - 299>
	<cfset cntmore = totalRecords - rowcnt>
</cfif>



<cfoutput>

<tr>
	<td title="Goes to the first page of search results."><a href="tax_watch_loan_tracker.cfm?start=#Val(begin)#&start_date=#url.start_date#&end_date=#url.end_date#&cnt=#Val(0)#" class="btn-small">Start</a></td>
	<td title="Goes to the last page of search results."><a href="tax_watch_loan_tracker.cfm?start=#Val(prev)#&start_date=#url.start_date#&end_date=#url.end_date#&cnt=#Val(cntprev)#" class="btn-small">Prev</a></td>
	<td title="Goes to the next page of search results."><a href="tax_watch_loan_tracker.cfm?start=#Val(next)#&start_date=#url.start_date#&end_date=#url.end_date#&cnt=#Val(cnt)#" class="btn-small">Next</a></td>
	<td title="Goes to the last page of serach results."><a href="tax_watch_loan_tracker.cfm?start=#Val(last)#&start_date=#url.start_date#&end_date=#url.end_date#&cnt=#Val(last)#" class="btn-small">Last</a></td>
</tr>

</cfoutput>	
</cfif>
 --->

</cfif>
	</table>


<cfoutput>
<pre>
#meta_tracking.sql#
</pre>
</cfoutput>

<!---Content End --->