<!---2019.6.16 設權限時，順帶增加元順利該公司別權限--->

<title>個人權限維護</title>
<cfinclude template="/EMG/menu.cfm">

<center><h4>個人權限維護作業</h4></center>

<!---查詢人員資料--->
<cfquery name="BIMPB" datasource="PKOOL">
	SELECT *
	FROM BIMPB
	WHERE PB001='#URL.PB001#'
</cfquery>

<!---查詢來源人員資料--->
<cfquery name="BIMPB2" datasource="PKOOL">
	SELECT *
	FROM BIMPB
	WHERE PB001 <> '#URL.PB001#'
</cfquery>

<!---查詢網頁程式資料--->
<cfquery name="BIMPE" datasource="PKOOL">
	SELECT *
	FROM BIMPE
	JOIN BIMPD ON PE003=PD001
	LEFT JOIN BIMPF ON PE001=PF002 AND PF001='#URL.PB001#'
	WHERE PF001 IS NULL
</cfquery>

<!---查詢資料--->
<cfquery name="BIMPF" datasource="PKOOL">
	SELECT *
	FROM BIMPF
	JOIN BIMPE ON PE001=PF002
	WHERE PF001='#URL.PB001#'
</cfquery>

<cfoutput>

<table border="1" align="center">
    <tr bgcolor="666666" style="color:FFF">
        <td align="center">人員工號</td>
        <td align="center">人員職稱</td>
    </tr>	
    
    <cfloop query="BIMPB">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr  bgcolor="#bgcolor#">
        <td>#PB001#</td>
        <td>#PB002#</td>
    </tr>
    </cfloop>
    
</table>

<br/>


<cfform action="BIMPF_INSERT_SQL2.cfm">

<table border="1" align="center">    
    <tr bgcolor="99CCCC">
	  <cfinput type="hidden" name="PF001"  size="10" value="#URL.PB001#" >
      <td>來源人員<select name="PB001"><cfloop query="BIMPB2"><option value="#PB001#">#PB001#-#PB002#</option></cfloop></select></td>
	  <td><cfinput type="submit" name="submit"  class="btn btn-primary m-1" value="人員權限複製" onclick = "if (! confirm('是否確認要複製權限，原權限會被刪除?')) { return false; }" ></td>
     </tr>
    
</table>
</cfform>


<table border="1" align="center">    
   <cfform action="BIMPF_INSERT_SQL.cfm">
    <tr bgcolor="99CCCC">
	  <cfinput type="hidden" name="PF001"  size="10" value="#URL.PB001#" >
      <td>程式<select name="PF002"><cfloop query="BIMPE"><option value="#PE001#">#PD002#-#PE002#</option></cfloop></select></td>
	  <td>查詢<cfinput type="Checkbox" name="PF003" checked="yes" style="zoom: 1.5"> </td>
	  <td>修改<cfinput type="Checkbox" name="PF004" checked="yes" style="zoom: 1.5"> </td>
	  <td>新增<cfinput type="Checkbox" name="PF005" checked="yes" style="zoom: 1.5"> </td>
	  <td>刪除<cfinput type="Checkbox" name="PF006" checked="yes" style="zoom: 1.5"> </td>
	  <td>售價<cfinput type="Checkbox" name="PF007" checked="yes" style="zoom: 1.5"> </td>
	  <td><cfinput type="submit" name="submit" value="新增"></td>
     </tr>
    </cfform>
</table>

<BR/>
 
<table border="1" align="center">

    <TR><td colspan="20">人員權限資料</td></tr>	
    <TR bgcolor="666666" style="color:FFF">
        <td align="center">程式代號</td>
        <td align="center">程式名稱</td>
        <td align="center">查詢</td>
        <td align="center">修改</td>
        <td align="center">新增</td>
        <td align="center">刪除</td>
        <td align="center">售價</td>
        <td align="center">權限修改</td>
        <td align="center">公司別</td>
        <td align="center">公司別設定</td>
        <td align="center">刪除</td>
    </tr>	
  
    <cfloop query="BIMPF">
	
	<cfform action="BIMPF_UPDATE_SQL.cfm">
    <cfinput type="hidden" name="PF001"  value="#PF001#" >
    <cfinput type="hidden" name="PF002"  value="#PF002#" >
	
	<cfquery name="BIMPH" datasource="PKOOL">
		SELECT *
		FROM BIMPH
		JOIN DSCMB ON MB003=PH003
		WHERE PH001='#PF001#' AND PH002='#PF002#'
    </cfquery>


    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr bgcolor="#bgcolor#">
        <td align="center">#PE001#</td>
        <td>#PE002#</td>
	<td align="center"><cfif #PF003# eq "Y">V</cfif></td>
        <td align="center"><cfif #PF004# eq "Y">V</cfif></td>
        <td align="center"><cfif #PF005# eq "Y">V</cfif></td>
        <td align="center"><cfif #PF006# eq "Y">V</cfif></td>
        <td align="center"><cfif #PF007# eq "Y">V</cfif></td>
        <td>
		   查詢<cfif #PF003# EQ "Y"><cfinput type="Checkbox" name="PF003" checked="yes" style="zoom: 1.5"><cfelse><cfinput type="Checkbox" name="PF003" checked="no" style="zoom: 1.5"></cfif>
		   修改<cfif #PF004# EQ "Y"><cfinput type="Checkbox" name="PF004" checked="yes" style="zoom: 1.5"><cfelse><cfinput type="Checkbox" name="PF004" checked="no" style="zoom: 1.5"></cfif>
		   新增<cfif #PF005# EQ "Y"><cfinput type="Checkbox" name="PF005" checked="yes" style="zoom: 1.5"><cfelse><cfinput type="Checkbox" name="PF005" checked="no" style="zoom: 1.5"></cfif>
		   刪除<cfif #PF006# EQ "Y"><cfinput type="Checkbox" name="PF006" checked="yes" style="zoom: 1.5"><cfelse><cfinput type="Checkbox" name="PF006" checked="no" style="zoom: 1.5"></cfif>
		   售價<cfif #PF007# EQ "Y"><cfinput type="Checkbox" name="PF007" checked="yes" style="zoom: 1.5"><cfelse><cfinput type="Checkbox" name="PF007" checked="no" style="zoom: 1.5"></cfif>
		   <cfinput type="submit" name="submit" value="更新">
		</td>
		<td><cfloop query="BIMPH">#MB002#,</cfloop></td>
        <td><a href="BIMPH.cfm?PF001=#PF001#&PF002=#PF002#">公司別設定</a></td>
        <td><a href="BIMPF_DELETE_SQL.cfm?PF001=#PF001#&PF002=#PF002#">刪除</a></td>
    </tr>
	
	</cfform>
	
    </cfloop>
    
</table>

</cfoutput>

<center><a href="BIMPB.cfm" class="btn btn-dark m-1">回上一頁</a></center>

<cfinclude template="/EMG/footer.cfm">
