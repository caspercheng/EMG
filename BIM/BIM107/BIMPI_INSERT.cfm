<title>Mail程式新增</title>
<!---Mail程式新增作業---> 

<cfinclude template="/EMG/menu.cfm">


<cfoutput>
<center><h4>Mail程式新增作業</h4></center>

<cfform action="BIMPI_INSERT_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">
 
<tr><td colspan="4"><cfinput type="submit" name="submit" value="新增"></td></tr>
 
  <tr bgcolor="99CCCC">
	  <td>Mail程式代號</td>
	  <td><cfinput type="text" name="PI001"  size="10" value="" maxlength="10" ></td>
  </tr>
  
  <tr>
	  <td>程式名稱</td>
	  <td><cfinput type="text" name="PI002"  size="30" value="" required="yes"  maxlength="30" message="程式名稱"></td>
  </tr> 
   

   <tr>
	  <td>網址路徑</td>
	  <td><cfinput type="text" name="PI003"  size="50" value="" maxlength="100" ></td>
  </tr> 

   <tr>
	  <td>說明</td>
	  <td><cfinput type="text" name="PI004"  size="50" value="" maxlength="100" ></td>
  </tr> 

</table>
</cfform> 

<center><h4><a href="BIMPI.cfm" class="btn btn-dark">回上一頁</a></h4></center>

</cfoutput>


