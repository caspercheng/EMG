<!---模組增作業---> 

<title>基本資料維護作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---查詢模組資料--->
<cfquery name="BIMPA" datasource="PKOOL">
	SELECT top 1 *
	FROM BIMPA
</cfquery>

<cfoutput>
<center><h4>基本資料維護作業：廠內生產排程表參數設定</h4></center>

<cfloop query="BIMPA">

<cfform action="BIMPA_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">

  <cfinput type="hidden" name="PA001" value="#PA001#">
  
  <tr bgcolor="666666"><td colspan="4"><cfinput type="submit" name="submit" value="更新"></td></tr>
  
  <tr >
	  <td>生產入庫 超過 預計產量(<strong style="background-color:66CCFF">藍色</strong>)</td>
	  <td><cfinput type="text" name="PA002"  size="5" value="#NUMBERFORMAT(PA002*100,"9999.99")#" required="yes" range="0.01,999">%</td>
  </tr>
  
  <tr>
	  <td>生產入庫 少於 預計產量(<strong style="background-color:FFCCFF">紅色</strong>)</td>
	  <td><cfinput type="text" name="PA003"  size="5" value="#NUMBERFORMAT(PA003*100,"9999.99")#" required="yes" ange="0.01,999">%</td>
  </tr> 
   
   
                  
</table>
</cfform> 

</cfloop>
</cfoutput>


<cfinclude template="/EMG/footer.cfm">
