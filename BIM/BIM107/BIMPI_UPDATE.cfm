<!---Mail程式更新作業---> 
<title>Mail程式更新</title>
<cfinclude template="/EMG/menu.cfm">

<!---查詢模組資料--->
<cfquery name="BIMPI" datasource="PKOOL">
	SELECT *
	FROM BIMPI
	WHERE PI001= '#URL.PI001#'
</cfquery>

<cfoutput>
<center><h4>Mail程式更新作業</h4></center>

<cfloop query="BIMPI">

<cfform action="BIMPI_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">
 
<tr bgcolor="666666"><td colspan="4"><cfinput type="submit" name="submit" value="更新"></td></tr>
 
  <tr>
	  <td>Mail程式代號</td>
	  <td><cfinput type="text" name="PI001"  size="10" value="#PI001#" readonly="yes" maxlength="10" ></td>
  </tr>
  
  <tr>
	  <td>程式名稱</td>
	  <td><cfinput type="text" name="PI002"  size="30" value="#PI002#" required="yes"  maxlength="30" message="程式名稱"></td>
  </tr> 
   

   <tr>
	  <td>網址路徑</td>
	  <td><cfinput type="text" name="PI003"  size="50" value="#PI003#" maxlength="100" ></td>
  </tr> 

   <tr>
	  <td>說明</td>
	  <td><cfinput type="text" name="PI004"  size="50" value="#PI004#" maxlength="100" ></td>
  </tr> 

</table>
</cfform> 

</cfloop>

<center><h4><a href="BIMPI.cfm" class="btn btn-dark">回上一頁</a></h4></center>

</cfoutput>


