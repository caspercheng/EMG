<title>公司新增</title>
<!---模組新增作業---> 

<cfinclude template="/EMG/menu.cfm">



<cfoutput>
<center><h4>公司新增作業</h4></center>

<cfform action="DSCMB_INSERT_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">

  <tr ><td colspan="4"><cfinput type="submit" name="submit" value="新增"  class="btn btn-primary btn-sm"></td></tr>
  
  <tr bgcolor="99CCCC">
	  <td align="center">公司代號</td>
	  <td><cfinput type="text" name="MB001"  size="10" value="" required="yes"  maxlength="10" message="公司代號不可空白"></td>
  </tr>
  
  <tr>
	  <td align="center">公司名稱</td>
	  <td><cfinput type="text" name="MB002"  size="30" value="" required="yes"  maxlength="30" message="公司名稱不可空白"></td>
  </tr> 
   
  <tr>
	  <td align="center">資料庫名稱</td>
	  <td><cfinput type="text" name="MB003"  size="30" value=""   maxlength="30" message="資料庫名稱不可空白"></td>
  </tr> 


 
  
  
      
                  
</table>
</cfform> 

</cfoutput>

<center><a href="DSCMB.cfm" class="btn btn-dark btn-sm">回上一頁</a></center>



