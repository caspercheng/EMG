<title>網頁程式維護作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "BIM103" >
<cfset program_name = "網頁程式維護作業" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">


<cfoutput>
<center><h4>網頁程式維護作業</h4></center>
</cfoutput>

<!---查詢系統別資料--->
<cfquery name="BIMPE" datasource="PKOOL">
	SELECT *
	FROM BIMPE
	JOIN BIMPD ON PE003=PD001
</cfquery>


<cfoutput>
	
<cfif #新增權限# eq "Y"><a href="BIMPE_INSERT.cfm" class="btn btn-primary btn-sm m-1">新增</a></cfif>
	
<div style="height:80%">
<table id="myTable01" class="fancyTable" >
<thead>

    <TR bgcolor="666666" style="color:FFF">
        <th>模組名稱</th>
        <th>程式代號</th>
        <th>程式名稱</th>
        <th>類型</th>
        <th>網址路徑</th>
        <th>權限明細</th>
        <th>修改</th>
        <th>刪除</th>
    </tr>	

  </thead>

<tbody>
    
    <cfloop query="BIMPE">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<cfif #PE004# EQ "I"><cfset class ="I:建檔"></cfif>
	<cfif #PE004# EQ "B"><cfset class ="B:批次"></cfif>
	<cfif #PE004# EQ "R"><cfset class ="R:報表/憑證"></cfif>
	<cfif #PE004# EQ "Q"><cfset class ="Q:查詢"></cfif>
    
    <tr bgcolor="#bgcolor#">
        <td align="center">#PD002#</td>
        <td align="center">#PE001#</td>
        <td align="center">#PE002#</td>
        <td align="center">#class#</td>
        <td>#PE005#</td>
        <td align="center"><a href="BIMPF.cfm?PE001=#PE001#" class="btn btn-info btn-sm m-1">權限明細</a></td>
	   	<td align="center"><cfif #修改權限# eq "Y"><a href="BIMPE_UPDATE.cfm?PE001=#PE001#" class="btn btn-success btn-sm m-1">修改</a></cfif></td>
	   	<td align="center"><cfif #刪除權限# eq "Y"><a href="BIMPE_DELETE_SQL.cfm?PE001=#PE001#" class="btn btn-secondary btn-sm m-1">刪除</a></cfif></td>
    </tr>
    </cfloop>
    
</tbody>
</table>
</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">
