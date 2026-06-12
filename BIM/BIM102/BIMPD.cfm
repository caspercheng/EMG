<title>模組資料維護作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "BIM102" >
<cfset program_name = "模組資料維護作業" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfoutput>
<center><h4>模組資料維護作業</h4></center>
</cfoutput>

<!---查詢系統別資料--->
<cfquery name="BIMPD" datasource="PKOOL">
	SELECT *
	FROM BIMPD
</cfquery>


<cfoutput>
	
<table border="1" align="center">
    <TR>
	   <td colspan="10"><cfif #新增權限# eq "Y"><a href="BIMPD_INSERT.cfm" class="btn btn-primary btn-sm m-1">新增</a></cfif></td>
    </tr>	

    <TR bgcolor="666666" style="color:FFF">
        <td width="75" align="center">模組代號</td>
        <td width="75" align="center">模組名稱</td>
        <td width="225" align="center">英文名稱</td>
        <td align="center">修改</td>
    </tr>	
    
    <cfloop query="BIMPD">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr bgcolor="#bgcolor#">
        <td align="center">#PD001#</td>
        <td align="center">#PD002#</td>
        <td>#PD003#</td>
		<td align="center"><cfif #修改權限# eq "Y"><a href="BIMPD_UPDATE.cfm?PD001=#PD001#" class="btn btn-success btn-sm m-1">修改</a></cfif></td>
    </tr>
    </cfloop>
    
</table>

</cfoutput>
