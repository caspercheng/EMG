<cfinclude template="/EAGLE/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "BIM201" >
<cfset program_name = "公佈欄資料維護作業" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EAGLE/permission.cfm">

<cfoutput>
<center><h4>公佈欄維護作業</h4></center>
</cfoutput>

<!---查詢系統別資料--->
<cfquery name="BIMKA" datasource="EAGLE">
	SELECT *
	FROM BIMKA
</cfquery>

<cfoutput>
	
<table border="1" align="center">
    <tr>
	   <td colspan="10"><cfif #新增權限# eq "Y"><a href="BIMKA_INSERT.cfm">新增</a></cfif></td>
    </tr>	

    <tr bgcolor="666666" style="color:FFF">
        <td>序號</td>
        <td>日期</td>
        <td>標題</td>
        <td>內容</td>
        <td>修改</td>
        <td>刪除</td>		
    </tr>	
    
    <cfloop query="BIMKA">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr bgcolor="#bgcolor#">
        <td>#KA001#</td>
        <td>#KA002#</td>
        <td>#KA003#</td>
        <td width="350">#KA004#</td>
	<td><cfif #修改權限# eq "Y"><a href="BIMKA_UPDATE.cfm?KA001=#KA001#">修改</a></cfif></td>
	<td><cfif #刪除權限# eq "Y"><a href="BIMKA_DELETE_SQL.cfm?KA001=#KA001#">刪除</a></cfif></td>
    </tr>
    </cfloop>
    
</table>

</cfoutput>
<cfinclude template="/EAGLE/footer.cfm">
