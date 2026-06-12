<title>員工資料更新</title>
<cfinclude template="/EMG/menu.cfm">

<!---查詢員工資料--->
<cfquery name="BIMPD" datasource="PKOOL">
	SELECT *
	FROM BIMPB
	LEFT JOIN BIMPC ON PB005=PC001
	WHERE PB001='#SESSION.CODE#'
</cfquery>

<cfoutput>

<h4 align="center">員工資料更新</h4>

<cfloop query="BIMPD">

<cfform action="BIMPB_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">
 
  <tr><td colspan="2"><cfinput type="submit" name="submit" value="更新" class="btn btn-primary m-1 btn-sm"></td></tr>
  
  <tr>
	  <td bgcolor="666666" style="color:FFF">工號</td>
	  <td><cfinput type="text" name="PB001"  size="10" value="#PB001#" readonly="YES" maxlength="10" ></td>
  </tr>
  
  <tr>
	  <td bgcolor="666666" style="color:FFF">姓名</td>
	  <td><cfinput type="text" name="PB002"  size="10" value="#PB002#" readonly="YES"  maxlength="10" message="姓名不可空白"></td>
  </tr> 

  <tr>
	  <td bgcolor="666666" style="color:FFF">密碼</td>
	  <td><cfinput type="password" name="PB004"  size="10" value="#PB004#"   maxlength="10" message="密碼不可空白"></td>
  </tr> 

  <tr>
	  <td bgcolor="666666" style="color:FFF">E-Mail</td>
	  <td><cfinput type="text" name="PB006"  size="40" value="#PB006#"   maxlength="40"></td>
  </tr> 
         
</table>
</cfform> 

</cfloop>

</cfoutput>


