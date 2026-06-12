<title>公司別維護作業</title>
<!---模組增作業---> 

<cfinclude template="/EMG/menu.cfm">

<!---查詢模組資料--->
<cfquery name="DSCMB" datasource="PKOOL">
	SELECT *
	FROM DSCMB
	WHERE MB001='#URL.MB001#'
</cfquery>


<cfoutput>
<center><h4>公司別維護作業</h4></center>

<cfloop query="DSCMB">

<cfform action="DSCMB_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">
<cfinput type ="hidden" name="OLD_MB001" value="#MB001#">
<table align="center" border="1" bordercolor="000000">

  <tr><td colspan="4"><cfinput type="submit" name="submit" value="更新" class="btn btn-primary btn-sm"></td></tr>
  
  <tr bgcolor="99CCCC">
	  <td align="center">公司代號</td>
	  <td><cfinput type="text" name="MB001"  size="10" value="#MB001#" required="yes"  maxlength="10" message="公司代號不可空白"></td>
  </tr>
  
  <tr>
	  <td align="center">公司名稱</td>
	  <td><cfinput type="text" name="MB002"  size="30" value="#MB002#" required="yes"  maxlength="30" message="公司名稱不可空白"></td>
  </tr> 
   
  <tr>
	  <td align="center">資料庫名稱</td>
	  <td><cfinput type="text" name="MB003"  size="30" value="#MB003#"   maxlength="30" message="資料庫名稱不可空白"></td>
  </tr> 

 
  
  
      
                  
</table>
</cfform> 

</cfloop>
</cfoutput>

<center><a href="DSCMB.cfm" class="btn btn-dark btn-sm">回上一頁</a></center>


