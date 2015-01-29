<!--- Header is generated above this point --->

<!--- <cfoutput>
#tw_custcodes#
</cfoutput> --->


<!---vars for url vars --->
<cfparam name="url.searchbar" default="">
<cfparam name="url.start_date" default="">
<cfparam name="url.start_end" default="">

<!---
URL
<cfdump var="#url#">
FORM
<cfdump var="#form#">
--->

<cfset s = 0>
<cfset class= "">
<cfif IsDefined('url.cnt')>
<cfset cnt = url.cnt>
<cfelse>
<cfset cnt = 0>
</cfif>

<cfset rowcnt = 0>

<cfset startpos = cnt + 1>


<!--- vars for pagination ---> 
<cfif IsDefined('url.start')>
<cfset perPage = "20">
<cfparam name="url.start" default="1">
<cfparam name="perPage" default="20">
<cfset i = 0>
<cfset i = url.start>
</cfif>





<cfif "I" eq client.custtype or "A" eq client.tw_admin or "L" eq client.tw_admin>
<!---Header Begin --->
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
	
<!---Header End --->
	

<!--- MySQL queries begins here --->
<cfif IsDefined('url.start')>	
<cfquery name="stec_mysql_loan_tracking_qry" result="meta_tracking" datasource="STLinux1MySQL">
Select
  tslo.customer_code,
  tslo.name,
  tsl.loan_identifier,
  tst.command,
  tsl.tax_search_loan_id As id,
  tsl.created,
  tsl.last_modified,
  tst.pick_userid
From
  tax_search_loans tsl Left Join
  tax_search_track tst On tsl.tax_search_loan_id = tst.id Left Join
  tax_search_loan_officers tslo On tsl.tax_search_loan_officer_id =
    tslo.tax_search_loan_officer_id
Where
  tslo.customer_code In (<cfqueryparam value="#tw_custcodes#" cfsqltype="cf_sql_varchar" list="yes">)
  AND (Not tst.command Is Null AND
  Not tst.command =  'Update Tax Search Ordered'
  )
 

 
 <cfif IsDefined('url.start_date')>
 	<cfif url.start_date eq "">
		<cfset url.start_date = '2010-01-01'>
	</cfif>
	<cfif url.end_date eq "">
		<cfset url.end_date = #DateFormat(now(), 'yyyy-mm-dd')#>
	</cfif>
AND
 tsl.last_modified >= <cfqueryparam value="#Trim(url.start_date)#" cfsqltype="cf_sql_date">
AND 
tsl.last_modified < <cfqueryparam value="#dateAdd('d', 1, Trim(url.end_date))#" cfsqltype="cf_sql_date">

 </cfif>
 

 
 <cfif IsDefined('url.searchbar')>
	<cfif url.searchbar neq "">
AND 
 (tsl.loan_identifier Like  <cfqueryparam value="%#Trim(url.searchbar)#%" cfsqltype="cf_sql_varchar"> Or
    tslo.name Like  <cfqueryparam value="%#Trim(url.searchbar)#%" cfsqltype="cf_sql_varchar"> Or
    tst.pick_userid Like  <cfqueryparam value="%#Trim(url.searchbar)#%" cfsqltype="cf_sql_varchar">)

	</cfif>
 </cfif>

 
 
	</cfquery>
</cfif>
<!--- MySQL queries end here --->


<!--- Content begins here --->	
    <table style="width: 100%; background-color: #003466; color: #FFFFFF;" cellspacing="0" class="main_body">
  	
	<tr>
		<cfform method="get" action="tax_watch_loan_tracker.cfm">
		<cfinput type="hidden" name="start" value="1">
		<td>	Search Bar
			<cfinput class="input searchbar" name="searchbar" placeholder="  Enter text here" title="You can use the search bar to search the tracker for matches on loan identifier, loan officers, user id or last modified by field. You can also leave this blank if you want."></td>
				<td>Date Range-Start Date 
			<cfinput class="input date-start" name="start_date" placeholder="  Select a date" title="You can filter by date, this is the starting point for a date to search by. You can also leave this blank if you want." ></td>
			<td>Date Range-End Date
			<cfinput class="input date-end" name="end_date" placeholder="  Select a date" title="You can filter by date, this is the ending point for a date to search by. You can also leave this blank if you want."></td>
		<td>
			<td><cfinput type="submit" class="btn-small" name="submit" value="search"></td>
		</cfform>
	</tr>
		
        </tr>
		<tr class="tracking_header">

			<th colspan="5">
			Tracking Report
			</th>
			
			<th colspan="4">
		<cfif IsDefined('url.start')>
			<cfoutput>
			Total: #meta_tracking.recordcount#
			<cfset total = #meta_tracking.recordcount#>
			</cfoutput>
		</cfif>
			</th>
			<hr>

		</tr>
		<tr class="tracking_header-sub">
			<td title="Loan Identifiers are the ids of the loans that exist in the tax watch.">
			Loan Identifier
			</td>
			<td title="The date that this entry was created. This is automatically recorded by the system">
			Created
			</td>
			<td title="The date the the loan was edited. This is automatically recorded by the system">
			Last Modified
			</td>
			<td title="The user that edited the loan. This is automatically recorded by the system">
			Last Modified By
			</td>
			<td title="The loan officer of this loan">
			Loan Officer
			</td>
			<td title="The action that was performed on the loan, editing its contents.">
			Action
			</td>
			<td title="Links to a report that shows all the old data at certain timeperiods.">
			Old Loan Data
			</td>

			<td>
			<td title="Links to a report that shows when data was changed and what it was changed to">
			Diff Checker.
			</td>


			
		</tr>
<cfif isDefined('url.start')>		
		<cfoutput query="stec_mysql_loan_tracking_qry" startrow="#url.start#" maxRows="#perPage#">
<cfset totalRecords = stec_mysql_loan_tracking_qry.RecordCount>
<cfset startRow = 1>
<cfset endRow = min(startRow + perPage-1, totalRecords)>
<cfif endRow gt totalRecords>
	<cfset endRow = totalRecords>
</cfif>

<!--- alternates the color between rows using s as a counter --->
<cfif s MOD 2 eq 0>
<cfset class= "white">
<cfelse>
<cfset class= "gray">
</cfif>
<cfset s = s+1>
	
		<tr class="info_row #class#">
		<cfif #id# neq "">
			<td>
			<a href="https://www.searchtec.com/secure/onguard/tax_loan_details.cfm?tax_search_loan_id=#id#" alt="link to loan">#loan_identifier#</a>
			</td>
		<cfelse>
			<td>
			#loan_identifier#
			</td>
		</cfif>
			
			<td>
			#created#
			</td>
			
			
			<td>
			#last_modified#
			</td>
				
			<td>
			<cfif #pick_userid# eq "">
			N/A
			<cfelse>
			#pick_userid#
			</cfif>
			</td>
			
			<td>
			#name#
			</td>
			
			<td>
			#command#
			</td>
			
			<td>
			<a href="tax_watch_old_loan_details.cfm?loan_id=#id#"><img alt="link to old data"src="../../images/plus.jpg"</a> 
			</td>

			<td colspan="2">
			<a href="tax_watch_diff.cfm?loan_id=#id#"><img alt="link to immediate changes in loan"src="../../images/plus.jpg"</a> 
			</td>


			

			<cfset rowcnt = rowcnt + 1>
			<cfset cnt = cnt + 1>
			<cfif cnt gt total>
					<cfset cnt = total>
				</cfif>
			<cfset endpos = cnt>

		</tr>
		
		</cfoutput>
			<cfif total neq 0>

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
			</cfif>


			<cfif stec_mysql_loan_tracking_qry.recordcount gte 20>
	

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
	<td title="Goes to the first page of search results."><a href="tax_watch_loan_tracker.cfm?start=#Val(begin)#&searchbar=#url.searchbar#&start_date=#url.start_date#&end_date=#url.end_date#&cnt=#Val(0)#" class="btn-small">Start</a></td>
	<td title="Goes to the last page of search results."><a href="tax_watch_loan_tracker.cfm?start=#Val(prev)#&searchbar=#url.searchbar#&start_date=#url.start_date#&end_date=#url.end_date#&cnt=#Val(cntprev)#" class="btn-small">Prev</a></td>
	<td title="Jumps back 300 entries in the search."><a href="tax_watch_loan_tracker.cfm?start=#Val(threeohohless)#&searchbar=#url.searchbar#&start_date=#url.start_date#&end_date=#url.end_date#&cnt=#Val(cntless)#" class="btn-small">300-</a></td>
	<cfif next lt totalRecords>
	<td title="Jumps ahead 300 entries in the search."><a href="tax_watch_loan_tracker.cfm?start=#Val(threeohohmore)#&searchbar=#url.searchbar#&start_date=#url.start_date#&end_date=#url.end_date#&cnt=#Val(cntmore)#" class="btn-small">300+</a></td>
	<td title="Goes to the next page of search results."><a href="tax_watch_loan_tracker.cfm?start=#Val(next)#&searchbar=#url.searchbar#&start_date=#url.start_date#&end_date=#url.end_date#&cnt=#Val(cnt)#" class="btn-small">Next</a></td>
	<td title="Goes to the last page of serach results."><a href="tax_watch_loan_tracker.cfm?start=#Val(last)#&searchbar=#url.searchbar#&start_date=#url.start_date#&end_date=#url.end_date#&cnt=#Val(last)#" class="btn-small">Last</a></td>
</tr>
 </cfif>
</cfoutput>	
</cfif>

		<tr>
			<td>
				<hr>
				<cfoutput>
			
			<cfif isDefined('start')>
			<a class="print-report" title="Print an excel sheet of the full report" href="tax_watch_manager_report.php?&custcodes=#tw_custcodes#&searchbar=#url.searchbar#&start_date=#url.start_date#&end_date=#url.end_date#" alt="excel_tracking_report" class="img-report"><img alt="excel_icon" src="../../images/excel.png"></a>
			<cfelse>
			<a class="print-report" title="Print an excel sheet of the full report" "href=tax_watch_manager_report.php?&custcodes=#tw_custcodes#&searchbar=#url.searchbar#&start_date=#url.start_date#&end_date=#url.end_date#" alt="excel_tracking_report" class="img-report"><img alt="excel_icon" src="../../images/excel.png"></a>
			</cfif>
			</cfoutput>
			</td>
		</tr>
</cfif>
    </table>
</cfif>
<!--- Content Ends here --->


<!---
<cfoutput>
<pre>
#meta_tracking.sql#
</pre>
</cfoutput>
--->
<!--- Footer is appended here --->