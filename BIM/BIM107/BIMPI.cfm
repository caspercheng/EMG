<title>Mail程式維護作業</title>

<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "BIM107" >
<cfset program_name = "Mail程式維護作業" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<!---查詢資料--->
<cfquery name="BIMPI" datasource="PKOOL">
	SELECT *
	FROM BIMPI
</cfquery>

<cfoutput>
<center><h4>Mail程式維護作業</h4></center>
	
<cfif #新增權限# eq "Y"><a href="BIMPI_INSERT.cfm">新增</a></cfif>
	
<div style="height:80%">
<table id="myTable01" class="fancyTable" >
<thead>

    <tr bgcolor="666666" style="color:FFF">
        <td>Mail程式代號</td>
        <td>程式名稱</td>
        <td>網址路徑</td>
        <td>說明</td>
        <td>受通知人員設定</td>
        <td>修改</td>
    </tr>	

  </thead>

<tbody>
    
    <cfloop query="BIMPI">
	
	<cfquery name="BIMPJ" datasource="PKOOL">
		SELECT *
		FROM BIMPJ
		JOIN DSCMB ON MB003=PJ002
		WHERE PJ001='#PI001#' 
    </cfquery>
	
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    
    <tr bgcolor="#bgcolor#">
        <td align="center">#PI001#</td>
        <td align="center">#PI002#</td>
        <td>#PI003#</td>
        <td align="center">#PI004#</td>
        <td align="center"><a href="BIMPK.cfm?PI001=#PI001#">受通知人員設定</a></td>
	<td align="center"><cfif #修改權限# eq "Y"><a href="BIMPI_UPDATE.cfm?PI001=#PI001#">修改</a></cfif></td>
    </tr>
    </cfloop>
    
</tbody>
</table>
</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">
