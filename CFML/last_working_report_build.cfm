<cfdump var="#url#">

 <cfif IsDefined('url.start_date')>
    <cfif url.start_date eq "">
        <cfset url.start_date = '2010-01-01'>
    </cfif>
    <cfif url.end_date eq "">
        <cfset url.end_date = #DateFormat(now(), 'yyyy-mm-dd')#>
    </cfif>
</cfif>

<cfinclude template="_recording_header.cfm">
<cfif not IsDefined('form.limit_by')>
    <cfset form.limit_by = "0">
</cfif>
<cfif client.custtype eq "I">
    <cfset cust_codes = client.custcode>
<cfelse>
    <cfset cust_codes = client.custlist>
</cfif>
<style>
    a.pager:link {color: white;}
    a.pager:visited {color: white;}
    a.pager:hover {color: white;}
    a.pager:active {color: white;}
</style>
<table style="width: 100%; background-color: #504B4B;" cellspacing="0">
    <tr>
        <td>
            <form action="" method="get">
            <table>
                <tr>
                    <td style="font-size: 18px; color: #FFFFFF;">Status</td>
                    <td style="font-size: 18px; color: #FFFFFF;">Sort</td>
                  <td style="font-size: 18px; color: #FFFFFF;"> Start Date </td>
                   <td style="font-size: 18px; color: #FFFFFF;"> End Date </td>
                </tr>
                <tr>
                    <td>
                        <select name="status_selection">
                            <option value="" <cfif isDefined('url.status_selection')><cfif '' eq url.status_selection>selected="selected"</cfif></cfif>>All</option>
                            <option value="Open" <cfif isDefined('url.status_selection')><cfif 'Open' eq url.status_selection>selected="selected"</cfif></cfif>>Open</option>
                            <option value="Completed" <cfif isDefined('url.status_selection')><cfif 'Completed' eq url.status_selection>selected="selected"</cfif></cfif>>Completed</option>
                        </select>
                    </td>
                    <td>
                        <select name="sort_selection">
                            <option value="" <cfif isDefined('url.sort_selection')><cfif '' eq url.sort_selection>selected="selected"</cfif></cfif>>Select</option>
                            <option value="Borrower" <cfif isDefined('url.sort_selection')><cfif 'Borrower' eq url.sort_selection>selected="selected"</cfif></cfif>>Borrower</option>
                            <option value="Address" <cfif isDefined('url.sort_selection')><cfif 'Address' eq url.sort_selection>selected="selected"</cfif></cfif>>Address</option>
                        </select>
                    </td>
                     <td>
            <input class="input date-start" name="start_date" placeholder="  Select a date" title="You can filter by date, this is the starting point for a date to search by. You can also leave this blank if you want." ></td>
            <td>
            <input class="input date-end" name="end_date" placeholder="  Select a date" title="You can filter by date, this is the ending point for a date to search by. You can also leave this blank if you want."></td>
        <td>
                    <td><input type="submit" name="submit" value="Filter" /></td>
                </tr>
            </table>
            </form>

<cfif IsDefined('url.status_selection')>

    <cfset num_rows = 15>
    <cfif not IsDefined('url.page_offset')>
        <cfset url.page_offset = 0>
    </cfif>

    <CFOBJECT type="COM" action="CREATE" class="D3ADO.Recordset" name="COMObject">
    <CFSET COMParams = "w3HostName=SEARCHTEC&w3Exec=OMSW3&sessionid=#client.sessionid#&FUNCTION=RECORDING_REPORT&family=&page_offset=#url.page_offset#&num_rows=#num_rows#&custcode=#cust_codes#&order_status=#url.status_selection#&sort_by=#url.sort_selection#&start_date=#url.start_date#&end_date=#url.end_date#">

    <cfset temp = COMOBJECT.D3Open(#COMParams#)>
    <CFSET fldcount = COMObject.RecordCount>

    <CFSET temp2 = COMObject.Fields>
    <CFSET temp3 = temp2.Item("ROW_CNT")>
    <CFSET row_cnt = temp3.Value>
    
    <cfset num_pages = fix(row_cnt / num_rows)>
    <cfif 0 neq (row_cnt MOD num_rows)>
        <cfset num_pages = num_pages +1>
    </cfif>

    <cfif row_cnt eq 0>
        <font color="white">No Results Found.</font>
    <cfelse>

        <cfoutput>
            <table style="width: 100%;">
                <tr>
                    <td>
                        <a href="export_recordings.php?custcode=#cust_codes#&family=&status_selection=#URLEncodedFormat(url.status_selection)#&sort_selection=#URLEncodedFormat(url.sort_selection)#"><span style="color: white;"><font color="FF0612"><font size="+1"><i></i></font></span><img src="/images/excel.png" border="0" alt=""></a>
                    </td>
                </tr>
            </table>
            <table style="width: 100%; background-color: ##888888;">
                <tr style="color: white; font-weight: bold;">
                    <td>
                        <cfif url.page_offset eq 0>
                            <<
                        <cfelse>
                            <a class="pager" href="recording_reports.cfm?status_selection=#URLEncodedFormat(url.status_selection)#&sort_selection=#URLEncodedFormat(url.sort_selection)#&page_offset=0"><<</a>
                        </cfif>
                    </td>
                    <td>
                        <cfif url.page_offset eq 0>
                            <
                        <cfelse>
                            <a class="pager" href="recording_reports.cfm?status_selection=#URLEncodedFormat(url.status_selection)#&sort_selection=#URLEncodedFormat(url.sort_selection)#&page_offset=#(url.page_offset-1)#"><</a>
                        </cfif>
                    </td>
                    <td align="center">Page #(url.page_offset+1)# / #num_pages#</td>
                    <td align="right">
                        <cfif (url.page_offset+1) lt num_pages>
                            <a class="pager" href="recording_reports.cfm?status_selection=#URLEncodedFormat(url.status_selection)#&sort_selection=#URLEncodedFormat(url.sort_selection)#&page_offset=#(url.page_offset+1)#">></a>
                        <cfelse>
                            >
                        </cfif>
                    </td>
                    <td align="right">
                        <cfif (url.page_offset+1) lt num_pages>
                            <a class="pager" href="recording_reports.cfm?status_selection=#URLEncodedFormat(url.status_selection)#&sort_selection=#URLEncodedFormat(url.sort_selection)#&page_offset=#num_pages-1#">>></a>
                        <cfelse>
                            >>
                        </cfif>
                    </td>
                </tr>
            </table>
            <table style="width: 100%; background-color: ##FFFFFF;">
                <tr>
                    <td>Order##</td>
                    <td>Borrower</td>
                    <td>Address</td>
                    <td>County</td>
                    <td>Doc&nbsp;Type</td>
                    <td>Submitted&nbsp;&nbsp;</td>
                    <td>Comments</td>
                    <td>Tracking Status</td>
                    <td>Comp</td>
                    <td>Pdf</td>
                </tr>

        <cfset bg_color = 'CCCCCC'>
        <cfloop from="1" to="#fldcount#" index="fldloop">

            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("ORDER_IDS")>
            <CFSET order_id = temp3.Value>

            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("BORROWERS")>
            <CFSET borrower = temp3.Value>

            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("ADDRESSES")>
            <CFSET address = temp3.Value>

            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("COUNTIES")>
            <CFSET county = temp3.Value>

            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("DOC_TYPES")>
            <CFSET doc_type = temp3.Value>

            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("COMMENTS")>
            <CFSET comments = temp3.Value>

            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("COMP_BDS")>
            <CFSET comprehensive_bd_order_id = temp3.Value>

            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("COMP_BD_ORDER_DATES")>
            <CFSET comprehensive_bd_order_date = temp3.Value>

            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("STATUSES")>
            <CFSET status = temp3.Value>

            <CFSET temp2 = COMObject.Fields>
            <CFSET temp3 = temp2.Item("ORDER_DATES")>
            <CFSET order_date = temp3.Value>

            <cfset order_date_year = DateFormat(order_date, 'yyyy')>
            <cfset order_date_month = DateFormat(order_date, 'mm')>
            <cfset order_date_day = DateFormat(order_date, 'dd')>

            <cfif 'CCCCCC' eq bg_color>
                <cfset bg_color = 'FFFFFF'>
            <cfelse>
                <cfset bg_color = 'CCCCCC'>
            </cfif>
                <tr style="background-color: ###bg_color#; color: ##336799; font-weight: bold;">
                    <td>
                    
                        <!--- <a href="edit_recording_details.cfm?order_id=#order_id#&status_selection=#URLEncodedFormat(url.status_selection)#&sort_selection=#URLEncodedFormat(url.sort_selection)#&page_offset=#URLEncodedFormat(url.page_offset)#" title="Click to edit">#order_id#</a> --->
                        <a href="/secure/status2.cfm?order_id=#order_id#" target="new">#order_id#</a>
                    </td>
                    <td>#Replace(borrower,chr(253),'<br />','all')#</td>
                    <td>#Replace(address,chr(253),'<br />','all')#</td>
                    <td>#county#</td>
                    <td>#doc_type#</td>
                    <td>#order_date#</td>
                    <td style="color: ##FF0000; text-align: center;"><cfif '' neq comments>*</cfif></td>
                    <td>#Replace(status,chr(253),'<br />','all')#</td>
                    <td>
                        <cfif "" neq comprehensive_bd_order_id>
                            <cfif Find('-', comprehensive_bd_order_id)>
                                #comprehensive_bd_order_id#
                            <cfelse>
                                <cfif FileExists("\\\\fileserver\\pdf\\#comprehensive_bd_order_id#.pdf")>
                                    <a href="/virtual_pdf_reports/#comprehensive_bd_order_id#.pdf" title="#comprehensive_bd_order_id#" target="new"><img src="/images/pdfbl.png" border="0" /></a>
                                <cfelse>
                                    <cfset comp_bd_year = Right(comprehensive_bd_order_date,2)>
                                    <cfset comp_bd_month = Left(comprehensive_bd_order_date,2)>
                                    <cfset comp_bd_day = Mid(comprehensive_bd_order_date,4,2)>
                                    <cfif FileExists("\\\\fileserver\\pdf_arc\\20#comp_bd_year#\\#comp_bd_month#\\#comp_bd_day#\\#comprehensive_bd_order_id#.pdf")>
                                        <a href="/virtual_pdf_report_archive/20#comp_bd_year#/#comp_bd_month#/#comp_bd_day#/#comprehensive_bd_order_id#.pdf" title="#comprehensive_bd_order_id#" target="new"><img src="/images/pdfbl.png" border="0" /></a>                                    
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cfif>
                    </td>
                    <td>
                        <cfset myfilter = "#order_id#*.pdf">
                        <cfdirectory 
                           directory="\\\\fileserver\\e-recorded\\" 
                           name="myDirectory" 
                           sort="name ASC, size DESC"
                           filter="#myfilter#">
                           
                        <cfloop query="myDirectory">
                            <cfif FileExists("\\\\fileserver\\e-recorded\\#myDirectory.Name#")>
                                <a href="/virtual_e-recorded_documents/#myDirectory.Name#" title="#myDirectory.Name#" target="new"><img src="/images/pdf_icon.gif" border="0" /></a>
                            </cfif>
                        </cfloop>
                        <cfset myfilter = "#order_id#*.pdf">
                        <cfdirectory 
                           directory="\\\\fileserver\\recording\\simplifile\\" 
                           name="myDirectory" 
                           sort="name ASC, size DESC"
                           filter="#myfilter#">
                           
                        <cfloop query="myDirectory">
                            <cfif FileExists("\\\\fileserver\\recording\\simplifile\\#myDirectory.Name#")>
                                <a href="/virtual_recording_documents/#myDirectory.Name#" title="#myDirectory.Name#" target="new"><img src="/images/pdf_icon.gif" border="0" /></a>
                            </cfif>
                        </cfloop>
                        <cfset myfilter = "#order_id#*.pdf">
                        <cfdirectory 
                           directory="\\\\fileserver\\recording\\zip_pdfs\\" 
                           name="myDirectory" 
                           sort="name ASC, size DESC"
                           filter="#myfilter#">
                           
                        <cfloop query="myDirectory">
                            <cfif FileExists("\\\\fileserver\\recording\\zip_pdfs\\#myDirectory.Name#")>
                                <a href="/virtual_recording_zip_pdfs/#myDirectory.Name#" title="#myDirectory.Name#" target="new"><img src="/images/pdf_icon.gif" border="0" /></a>
                            </cfif>
                        </cfloop>
                    </td>
                </tr>
            <cfset tempx = COMObject.MoveNext()>
        </cfloop>
            </table>            
        </cfoutput>
    </cfif>
</cfif>

            <br />
        </td>
    </tr>
</table>
