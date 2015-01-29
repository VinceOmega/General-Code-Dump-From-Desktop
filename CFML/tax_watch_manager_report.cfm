<cfsavecontent variable="qry_report">
<cfquery name="stec_mysql_loan_tracking_qry" datasource="STLinux1MySQL">
	SELECT
    tax_search_track_id as track_id,
    tax_search_track.created,
    tax_search_track.created_by,
    tax_search_track.last_modified,
    tax_search_track.last_modified_by,
    tax_search_track.active,
    tax_search_track.pick_userid,
    tax_search_track.command,
    tax_search_track.table_name as name,
    tax_search_track.id,
    tax_search_track.user_ip as ip
  FROM
    tax_search_track
    LEFT JOIN tax_search_loan_officers ON tax_search_track.pick_userid = tax_search_loan_officers.pick_userid
  WHERE
    tax_search_loan_officers.customer_code IN ('SSI')
	</cfquery>
	
	<cfcontent type="application/msexcel">
	<table>
		<tr>
			
			<th colspan="11" align="center">
			Tracking Report
			</th>
			<hr>
		</tr>
		<tr>
			<td>
			Tracking ID
			</td>
			<td>
			Created
			</td>
			<td>
			Created By
			</td>
			<td>
			Last Modified
			</td>
			<td>
			Last Modified By
			</td>
			<td>
			Active
			</td>
			<td>
			Name
			</td>
			<td>
			Action
			</td>
			<td>
			Modified On
			</td>
			<td>
			Id
			</td>
			<td>
			IP
			</td>
		</tr>
		
		<cfoutput query="stec_mysql_loan_tracking_qry">
		<tr>
			<td>
			#track_id#
			</td>
			
			<td>
			#created#
			</td>
			
			<td>
			#created_by#
			</td>
			
			<td>
			#last_modified#
			</td>
			
			
			<td>
			#last_modified_by#
			</td>
			
			<td>
			#active#
			</td>
			
			<td>
			#pick_userid#
			</td>
			
			<td>
			#command#
			</td>
			
			<td>
			#name#
			</td>
			
			<td>
			#id#
			</td>
			
			<td>
			#ip#
			</td>
		</tr>
		</cfoutput>
</table>
</cfsavecontent>

<cfset cust = '#url.cust_code#'>
<cfset date = '#Now()#'>
<cfset name = cust & date>

<cfset filename = expandPath('./#name#.xls')>
<cfif FileExists(#filename#)>
	<cffile action="delete" file="#filename#">
</cfif>
<cffile action="WRITE" mode="777" file="#filename#" output="#qry_report#">
