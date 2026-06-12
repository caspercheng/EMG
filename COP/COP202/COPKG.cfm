<title>多階成本核價表</title>
<cfinclude template="/EMG/menu.cfm">

<cfif NOT IsDefined("FORM.PC002")><cfset #FORM.PC002#=""></cfif>
<cfif NOT IsDefined("FORM.KE009")><cfset #FORM.KE009#=""></cfif>
<cfif NOT IsDefined("FORM.KE010")><cfset #FORM.KE010#=""></cfif>
<cfif NOT IsDefined("FORM.KE015")><cfset #FORM.KE015#=""></cfif>
<cfif NOT IsDefined("FORM.KE002")><cfset #FORM.KE002#=""></cfif>
<cfif NOT IsDefined("FORM.KE003")><cfset #FORM.KE003#=""></cfif>
<cfif NOT IsDefined("FORM.KE004")><cfset #FORM.KE004#=""></cfif>
<cfif NOT IsDefined("FORM.KE005")><cfset #FORM.KE005#=""></cfif>
<cfif NOT IsDefined("FORM.KE006")><cfset #FORM.KE006#=""></cfif>
<cfif NOT IsDefined("FORM.KE016")><cfset #FORM.KE016#=""></cfif>

<!---設定此程式代號--->
<cfset program_id = "COP202" >
<cfset program_name = "多階成本核價表" >
<cfset program_type = "B" >

<cfoutput>

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<h4 align="center">成本核價表</h4>



<!---查詢資料--->
<cfquery name="COPKG" datasource="#SESSION.COMPANY#">
	SELECT  *
	FROM COPKG
	JOIN INVMB ON KG002=MB001
	WHERE 1=1
		ORDER BY KG001 DESC
</cfquery>


<a href="COPKG_INSERT0.cfm" class="btn btn-primary m-1">新增</a>
<!---<cfif #價格權限# eq "Y">
<a href="COPKE_EXCEL.cfm?PC001=#FORM.PC001#&PC002=#FORM.PC002#" class="btn btn-success m-1">產生EXCEL</a>
</cfif>
--->

<div style="height:85%">
<table id="myTable01" class="fancyTable" >
<thead>


    <TR bgcolor="666666" style="color:FFF">
        <th align="center">單號</th>
        <th align="center">品號</th>
        <th align="center">基準日期</th>
        <th align="center">核價前金額</th>
        <th align="center">核價後金額</th>
        <th align="center">價格浮動幅度</th>
        <th align="center">備註</th>
        <th align="center">維護</th>
        <th align="center">刪除</th>
    </tr>	

  </thead>
<tbody>

    <cfloop query="COPKG">
	<cfquery name="COPKH" datasource="#SESSION.COMPANY#">
		SELECT  *
		FROM COPKH
		WHERE 1=1
			AND KH001='#KG001#'
	   ORDER BY KH002 DESC 
	</cfquery>
	
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr bgcolor="#bgcolor#">
        <td align="center"><a href="COPKH_detail.cfm?KH001=#KG001#" target="_blank">#KG001#</a></td>
        <td align="center">#KG002#</td>
        <td align="center" ><cfif #KG003# NEQ "1900-01-01">#KG003#</cfif></td>
        <td align="center">#NUMBERFORMAT(KG004,"999,999,999.99")#</td>
        <td align="center">#NUMBERFORMAT(KG005,"999,999,999.99")#</td>
        <td align="center">#NUMBERFORMAT(KG006*100,"9.99")#%</td>
		<td align="center" >#KG007#</td>
		<td align="center">
		<cfif #修改權限# eq "Y">
		<a href="COPKH_UPDATE.cfm?KG001=#KG001#" class="btn btn-success btn-sm m-1" target="_blank">維護</a>
		</cfif>
		</td>
		
		<td align="center">
		<cfif #刪除權限# eq "Y">
		<a href="COPKG_DELETE_SQL.cfm?KG001=#KG001#" onclick = "if (! confirm('是否確認全數刪除?')) { return false; }" class="btn btn-warning btn-sm m-1">刪除</a>
		</cfif>
		</td>
		
    </tr>
    </cfloop>
    
</tbody>
</table>
</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">
