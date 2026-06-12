<title>人員登入資訊查詢作業</title>

<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "BIM302" >
<cfset program_name = "人員登入資訊" >
<cfset program_type = "I" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.KA001_1")><cfset #FORM.KA001_1#=""></cfif>
<cfif NOT IsDefined("FORM.KA001_2")><cfset #FORM.KA001_2#=""></cfif>
<cfif NOT IsDefined("FORM.KA003")><cfset #FORM.KA003#=""></cfif>
<cfif NOT IsDefined("FORM.KA004")><cfset #FORM.KA004#=""></cfif>

<center><h4>人員登入資訊查詢作業</h4></center>

<!---資料查詢介面--->
<cfform action="BIMKA.cfm" method="post">
	<table align="center" bgcolor="9999CC">
	 <tr>
	  <td>登入日期</td>
	  <td><input type="date" name="KA001_1" >～</td>
	  <td><input type="date" name="KA001_2" ></td>
	  <td>工號</td> <td><cfinput type="text" name="KA003" size="10" maxlength="20"  value=""></td>	 
	  <td>職稱</td> <td><cfinput type="text" name="KA004" size="10" maxlength="20"  value=""></td>
	  <td colspan="1" align="center"><input type="submit" name="submit" value="查詢"></td>
        </tr>
	</table>
</cfform>


<!---查詢部門組織資料--->
<cfquery name="BIMKA" datasource="PKOOL">
	SELECT TOP 500 *
	FROM BIMKA
	JOIN BIMPB ON KA003=PB001
	WHERE 1=1
	<cfif FORM.KA001_1 IS NOT ""> AND KA001 >= '#FORM.KA001_1#'</cfif>
	<cfif FORM.KA001_2 IS NOT ""> AND KA001 <= '#FORM.KA001_2#'</cfif>
	<cfif FORM.KA003 IS NOT ""> AND KA003 LIKE '#FORM.KA003#%'</cfif>
	<cfif FORM.KA004 IS NOT ""> AND KA004 LIKE '#FORM.KA004#%'</cfif>
	
	ORDER BY KA001 DESC,KA002 DESC
</cfquery>

<!---查詢部門組織資料--->
<cfquery name="BIMKA_SUM" datasource="PKOOL">
	SELECT KA003,PB002,PB006,COUNT(KA001) AS COUNT
	FROM BIMKA
	JOIN BIMPB ON KA003=PB001
	WHERE 1=1
	<cfif FORM.KA001_1 IS NOT ""> AND KA001 >= '#FORM.KA001_1#'</cfif>
	<cfif FORM.KA001_2 IS NOT ""> AND KA001 <= '#FORM.KA001_2#'</cfif>
	<cfif FORM.KA003 IS NOT ""> AND KA003 LIKE '#FORM.KA003#%'</cfif>
	<cfif FORM.KA004 IS NOT ""> AND KA004 LIKE '#FORM.KA004#%'</cfif>
	
	GROUP BY KA003,PB002,PB006
	ORDER BY COUNT(KA001) DESC
</cfquery>

<!---查詢計數歸零--->
<cfset current_row=0>

<cfoutput>

<table border="1" align="center">
 
    <tr bgcolor="666666" style="color:FFF">
         <td align="center">工號</td>
         <td align="center">姓名</td>
         <td align="center">登入次數</td>
    </tr>	
    
    <cfloop query="BIMKA_SUM">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr bgcolor="#bgcolor#">
        <td width="100" align="center">#KA003#</td>
        <td align="center">#PB002#</td>
        <td width="100" align="center">#COUNT#</td>
    </tr>
    </cfloop>
    
</table>

<BR/>
	
<div style="height:80%">
<table id="myTable01" class="fancyTable" >
<thead>
 
    <tr bgcolor="666666" style="color:FFF">
         <td align="center">項次</td>
         <td align="center">登入日期</td>
         <td align="center">登入時間</td>
         <td align="center">工號</td>
         <td align="center">姓名</td>
         <td align="center">E-Mail</td>
         <td align="center">IP</td>
         <td align="center">登入主機</td>
    </tr>	

     </thead>

<tbody>
  
    <cfloop query="BIMKA">
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    <tr bgcolor="#bgcolor#">
        <td align="center">#currentRow#</td>
        <td align="center">#KA001#</td>
        <td align="center">#KA002#</td>
        <td align="center">#KA003#</td>
        <td align="center">#KA004#</td>
        <td align="center">#PB006#</td>
        <td align="center">#KA005#</td>
        <td align="center">#KA006#</td>
    </tr>

<!---查詢計數--->
<cfif #currentRow# NEQ "">
<cfset current_row=current_row + 1>
</cfif>

    </cfloop>
    
</tbody>

<!---查詢無資料提示--->
<cfif current_row EQ "0">
<h4><center><span style="color:FF3030;">本次查詢無資料，請更新查詢條件。</span></center></h4>
</cfif>

</table>
</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">
