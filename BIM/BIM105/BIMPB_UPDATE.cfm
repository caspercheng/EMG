<!---員工資料更新作業---> 
<title>員工資料更新作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---查詢員工資料--->
<cfquery name="COPMA" datasource="EMG">
	SELECT *
	FROM COPMA
	WHERE 1=1
</cfquery>

<!---查詢員工資料--->
<cfquery name="BIMPD" datasource="PKOOL">
	SELECT *
	FROM BIMPB
	LEFT JOIN BIMPC ON PB005=PC001
	WHERE PB001='#TRIM(URL.PB001)#'
</cfquery>

<!---查詢部門資料--->
<cfquery name="BIMPC" datasource="PKOOL">
	SELECT *
	FROM BIMPC
	ORDER BY PC001
</cfquery>

<cfquery name="BIMPB" datasource="PKOOL">
	SELECT *
	FROM BIMPB
	WHERE PB007='N'
</cfquery>

<cfset list1=ValueList(BIMPB.PB002)>


<cfoutput>
<h4 align="center">員工資料更新作業</h4>

<cfloop query="BIMPD">

<cfform action="BIMPB_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">
<cfinput type="hidden" name="old_PB001" value="#PB001#">
<table align="center" border="1" bordercolor="000000">
 
  <tr>
     <td colspan="4">
	   <cfinput type="submit" name="submit" value="更新"  class="btn btn-primary m-1">  
	   <cfinput type="submit" name="submit" value="停用"  class="btn btn-warning m-1">
	   <cfinput type="submit" name="submit" value="復職"  class="btn btn-success m-1">
	 </td>
  </tr>
  
  <tr>
	  <td align="center" bgcolor="666666" style="color:FFF">工號</td>
	  <td><cfinput type="text" name="PB001"  size="10" value="#PB001#" readonly="YES" maxlength="10" ></td>
  </tr>
  
  <tr>
	  <td align="center" bgcolor="666666" style="color:FFF">姓名</td>
	  <td><cfinput type="text" name="PB002"  size="10" value="#PB002#" required="yes"  maxlength="10" message="姓名不可空白"></td>
  </tr> 
   

  <tr>
	  <td align="center" bgcolor="666666" style="color:FFF">密碼</td>
	  <td><cfinput type="password" name="PB004"  size="10" value="#PB004#"   maxlength="10" message="密碼不可空白"></td>
  </tr> 

  <tr>
	  <td align="center" bgcolor="666666" style="color:FFF">部門</td>
	  <td>
	   <select name="PB005">
	      <option value="#PB005#">#PC002#</option>
		  <cfloop query="BIMPC">
	      <option value="#PC001#">#PC002#</option>
		  </cfloop>
	   </select>
	  </td>
  </tr> 

  <tr>
	  <td align="center" bgcolor="666666" style="color:FFF">E-Mail</td>
	  <td><cfinput type="text" name="PB006"  size="40" value="#PB006#"   maxlength="40"></td>
  </tr> 

   <tr>
	  <td align="center" bgcolor="666666" style="color:FFF">客戶代號</td>
	  <td>
		       <input name="PB009" list="custom" value=#PB009#>
			   <datalist id="custom"> 
					<cfloop query="COPMA"><option value="#RTRIM(MA001)#">#MA002#</option></cfloop>
			   </datalist>
	  
	  </td>
  </tr> 
 
</table>
</cfform> 

</cfloop>

<center><a href="BIMPB.cfm" class="btn btn-dark">回上一頁</a></center>

</cfoutput>


