<title>作業權限查詢</title>
<cfinclude template="/EMG/menu.cfm">


<center><h4>作業權限查詢</h4></center>

<!---查詢人員資料--->
<cfquery name="BIMPB" datasource="PKOOL">
	SELECT *
	FROM BIMPB
	LEFT JOIN BIMPF ON PB001=PF001 AND PF002='#URL.PE001#'
	WHERE PF001 IS NULL
</cfquery>

<!---查詢作業資料--->
<cfquery name="BIMPE" datasource="PKOOL">
	SELECT *
	FROM BIMPE
	WHERE PE001='#URL.PE001#'
</cfquery>

<!---查詢資料--->
<cfquery name="BIMPF" datasource="PKOOL">
	SELECT *
	FROM BIMPB
	LEFT JOIN BIMPF ON PF001=PB001
	LEFT JOIN BIMPE ON PE001=PF002
	WHERE PE001='#URL.PE001#'
</cfquery>

<cfoutput>

<table border="1" align="center">
    <TR bgcolor="666666" style="color:FFF">
        <td align="center">作業代號</td>
        <td align="center">作業名稱</td>
    </tr>	
    
    <cfloop query="BIMPE">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr  bgcolor="#bgcolor#">
        <td>#PE001#</td>
        <td>#PE002#</td>
    </tr>
    </cfloop>
    
</table>

<P>
 
 <table border="1" align="center">    
   <cfform action="BIMPF_INSERT_SQL.cfm">
    <tr bgcolor="99CCCC">
	  <cfinput type="hidden" name="PF002"  size="10" value="#URL.PE001#" >
      <td>人員
		       <input name="PF001" list="custom" placeholder="人員">
			   <datalist id="custom"> 
		  <cfloop query="BIMPB"><option value="#PB001#">#PB001#-#PB002#</option></cfloop>
			   </datalist>
	  </td>
	  <td>查詢<cfinput type="Checkbox" name="PF003" checked="yes" style="zoom: 1.5"> </td>
	  <td>修改<cfinput type="Checkbox" name="PF004" checked="yes" style="zoom: 1.5"> </td>
	  <td>新增<cfinput type="Checkbox" name="PF005" checked="yes" style="zoom: 1.5"> </td>
	  <td>刪除<cfinput type="Checkbox" name="PF006" checked="yes" style="zoom: 1.5"> </td>
	  <td>售價<cfinput type="Checkbox" name="PF007" checked="yes" style="zoom: 1.5"> </td>
	  <td><cfinput type="submit" name="submit" value="新增" class="btn btn-primary btn-sm m-1"></td>
     </tr>
    </cfform>
</table>

<BR/>

<table border="1" align="center">

    <TR><td colspan="20">人員權限資料</td></tr>	
    <TR bgcolor="666666" style="color:FFF">
        <td align="center">人員代號</td>
        <td align="center">人員名稱</td>
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
	

	<!---查公司別權限--->
	<cfquery name="BIMPH" datasource="PKOOL">
		SELECT *
		FROM BIMPH
		JOIN DSCMB ON MB003=PH003
		WHERE PH001='#PF001#' AND PH002='#PF002#'
    </cfquery>

    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr bgcolor="#bgcolor#">
        <td align="center">#PB001#</td>
        <td>#PB002#</td>
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
        <td><a href="BIMPH.cfm?PF001=#PF001#&PF002=#PF002#" class="btn btn-info btn-sm m-1">公司別設定</a></td>
        <td><a href="BIMPF_DELETE_SQL.cfm?PF001=#PF001#&PF002=#PF002#" class="btn btn-secondary btn-sm m-1">刪除</a></td>
    </tr>
	 
	 </cfform>
	
    </cfloop>
    
</table>

</cfoutput>

<center><h4><a href="BIMPE.cfm" class="btn btn-dark btn-sm m-1">回上一頁</a></h4></center>

<cfinclude template="/EMG/footer.cfm">
