<title>部門權限維護</title>
<cfinclude template="/EMG/menu.cfm">

<center><h4>部門權限維護作業</h4></center>

<!---查詢專案資料--->
<cfquery name="BIMPC" datasource="PKOOL">
	SELECT *
	FROM BIMPC
	WHERE PC001='#URL.PC001#'
</cfquery>

<!---查詢專案資料--->
<cfquery name="BIMPE" datasource="PKOOL">
	SELECT *
	FROM BIMPE
	LEFT JOIN BIMPG ON PE001=PG002 AND PG001='#URL.PC001#'
	WHERE PG001 IS NULL
</cfquery>

<!---查詢專案成員資料--->
<cfquery name="BIMPG" datasource="PKOOL">
	SELECT *
	FROM BIMPG
	JOIN BIMPE ON PE001=PG002
	WHERE PG001='#URL.PC001#'
</cfquery>

<!---查詢專案資料--->
<cfquery name="BIMPC_ALL" datasource="PKOOL">
	SELECT *
	FROM BIMPC
	WHERE PC001 <> '#URL.PC001#'
</cfquery>

<cfoutput>

<table border="1" align="center">
    <tr bgcolor="666666" style="color:FFF">
        <td>部門代號</td>
        <td>部門名稱</td>
    </tr>	
    
    <cfloop query="BIMPC">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr  bgcolor="#bgcolor#">
        <td>#PC001#</td>
        <td>#PC002#</td>
    </tr>
    </cfloop>
    
</table>

<P>

<table border="1" align="center">    
   <cfform action="BIMPG_DepCopy_INSERT_SQL.cfm">
    <tr bgcolor="99CCCC">
	  <cfinput type="hidden" name="PG001"  size="10" value="#URL.PC001#" >
      <td>部門<select name="PC001"><cfloop query="BIMPC_ALL"><option value="#PC001#">#PC002#</option></cfloop></select></td>
	  <td><cfinput type="submit" name="submit" value="部門權限複製"></td>
     </tr>
    </cfform>
	</table>


<table border="1" align="center">    
   <cfform action="BIMPG_INSERT_SQL.cfm">
    <tr bgcolor="99CCCC">
	  <cfinput type="hidden" name="PG001"  size="10" value="#URL.PC001#" >
      <td>程式<select name="PG002"><cfloop query="BIMPE"><option value="#PE001#">#PE002#</option></cfloop></select></td>
	  <td>查詢<cfinput type="Checkbox" name="PG003" checked="yes" > </td>
	  <td>修改<cfinput type="Checkbox" name="PG004" checked="yes"> </td>
	  <td>新增<cfinput type="Checkbox" name="PG005" checked="yes"> </td>
	  <td>刪除<cfinput type="Checkbox" name="PG006" checked="yes"> </td>
	  <td><cfinput type="submit" name="submit" value="新增"></td>
     </tr>
    </cfform>
	</table>
    
<table border="1" align="center">

    <TR><td colspan="20">部門權限資料</td></tr>	
    <TR bgcolor="666666" style="color:FFF">
        <td>程式代號</td>
        <td>程式名稱</td>
        <td>查詢</td>
        <td>修改</td>
        <td>新增</td>
        <td>刪除</td>
        <td>刪除</td>
    </tr>	
    
    <cfloop query="BIMPG">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr  bgcolor="#bgcolor#">
        <td>#PE001#</td>
        <td>#PE002#</td>
		<td align="center"><cfif #PG003# eq "Y">V</cfif></td>
        <td align="center"><cfif #PG004# eq "Y">V</cfif></td>
        <td align="center"><cfif #PG005# eq "Y">V</cfif></td>
        <td align="center"><cfif #PG006# eq "Y">V</cfif></td>
        <td><a href="BIMPG_DELETE_SQL.cfm?PG001=#PG001#&PG002=#PG002#">刪除</a></td>
    </tr>
    </cfloop>
    
</table>

</cfoutput>

<center><h4><a href="BIMPC.cfm" class="btn btn-dark">回上一頁</a></h4></center>
