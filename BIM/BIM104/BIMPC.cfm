<title>部門維護</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "BIM104" >
<cfset program_name = "部門維護" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfoutput>

<h4 align="center">部門維護</h4>

<!---查詢部門組織資料--->
<cfquery name="BIMPC" datasource="PKOOL">
	SELECT PC001,PC002,BIMPB1.PB002 AS BIMPB1_PB002
	,BIMPB2.PB002 AS BIMPB2_PB002,BIMPB3.PB002 AS BIMPB3_PB002
	FROM BIMPC
	LEFT JOIN BIMPB  as BIMPB1 ON BIMPB1.PB001=PC003
	LEFT JOIN BIMPB  as BIMPB2 ON BIMPB2.PB001=PC004
	LEFT JOIN BIMPB  as BIMPB3 ON BIMPB3.PB001=PC005
	ORDER BY PC001
</cfquery>

<a href="CMSMEtoBIMPC.cfm" class="btn btn-primary m-1">部門資料同步</a>
<table border="1" align="center">

    <tr bgcolor="666666" style="color:FFF">
        <td>部門代號</td>
        <td>部門名稱</td>
        <td>部門主管</td>
        <td>修改</td>
        <td>部門權限設定</td>
    </tr>	
    
    <cfloop query="BIMPC">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr bgcolor="#bgcolor#">
        <td align="center">#PC001#</td>
        <td align="center">#PC002#</td>
        <td align="center">#BIMPB1_PB002#</td>
		<td><cfif #修改權限# eq "Y"><a href="BIMPC_UPDATE.cfm?PC001=#PC001#">修改</a></cfif></td>
		<td align="center"><cfif #修改權限# eq "Y"><a href="BIMPG.cfm?PC001=#PC001#">權限設定</a></cfif></td>
    </tr>
    </cfloop>
    
</table>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">
