<title>受通知人員設定</title>
<cfinclude template="/EMG/menu.cfm">

<center><h4>受通知人員設定(依公司別)</h4></center>

<!---查詢人員資料--->
<cfquery name="BIMPB" datasource="PKOOL">
	SELECT *
	FROM BIMPB
	WHERE 1=1 
	    AND PB006 <> ''
		AND PB001 NOT IN 
	(SELECT PK002
	FROM BIMPK
	WHERE PK001='#URL.PI001#')
</cfquery>

<!---查詢人員資料--->
<cfquery name="BIMPI" datasource="PKOOL">
	SELECT *
	FROM BIMPI
	WHERE PI001='#URL.PI001#'
</cfquery>


<!---查詢網頁程式資料--->
<cfquery name="BIMPK" datasource="PKOOL">
	SELECT *
	FROM BIMPK
	JOIN BIMPB ON PB001=PK002
	WHERE PK001='#URL.PI001#'
</cfquery>


<cfoutput>

<table border="1" align="center">
    <tr bgcolor="666666" style="color:FFF">
        <td align="center">程式代號</td>
        <td align="center">程式名稱</td>
    </tr>	
    
    <cfloop query="BIMPI">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr bgcolor="#bgcolor#">
        <td align="center">#PI001#</td>
        <td>#PI002#</td>
    </tr>
    </cfloop>
    
</table>

<P>

<table border="1" align="center">    
   <cfform action="BIMPK_INSERT_SQL.cfm">
    <tr bgcolor="99CCCC">
	  <cfinput type="hidden" name="PK001"  size="10" value="#URL.PI001#" >
      <td>人員工號<select name="PK002"><cfloop query="BIMPB"><option value="#TRIM(PB001)#">#TRIM(PB001)#_#PB002#</option></cfloop></select></td>
	  <td><cfinput type="submit" name="submit" value="新增"></td>
     </tr>
    </cfform>
</table>

<BR/>
 
<table border="1" align="center">

    <TR><td colspan="20">受通知人員資料</td></tr>	
    <TR bgcolor="666666" style="color:FFF">
        <td align="center">項次</td>
        <td align="center">工號</td>
        <td align="center">職稱</td>
        <td align="center">E-Mail</td>
        <td align="center">設定</td>
    </tr>	
  
    <cfloop query="BIMPK">
	
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr bgcolor="#bgcolor#">
        <td align="center">#CurrentRow#</td>
        <td align="center">#PB001#</td>
        <td align="center">#PB002#</td>
        <td align="center">#PB006#</td>
        <td><a href="BIMPK_DELETE_SQL.cfm?PK001=#PK001#&PK002=#PK002#">刪除</a></td>
    </tr>
	
    </cfloop>
    
</table>

</cfoutput>

<center><h4><a href="BIMPI.cfm" class="btn btn-dark">回上一頁</a></h4></center>
