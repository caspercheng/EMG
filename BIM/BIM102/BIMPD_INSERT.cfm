<title>模組新增</title>
<!---模組新增作業---> 

<cfinclude template="/EMG/menu.cfm">



<cfoutput>
<center><h4>模組新增作業</h4></center>

<cfform action="BIMPD_INSERT_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">

  <tr ><td colspan="4"><cfinput type="submit" name="submit" value="新增"></td></tr>
  
  <tr bgcolor="99CCCC">
	  <td align="center">模組代號</td>
	  <td><cfinput type="text" name="PD001"  size="10" value="" maxlength="10" ></td>
  </tr>
  
  <tr>
	  <td align="center">模組名稱</td>
	  <td><cfinput type="text" name="PD002"  size="30" value="" required="yes"  maxlength="30" message="系統名稱不可空白"></td>
  </tr> 
   
  <tr>
	  <td align="center">模組英文名稱</td>
	  <td><cfinput type="text" name="PD003"  size="30" value=""   maxlength="30" message="英文名稱不可空白"></td>
  </tr> 


 
  
  
      
                  
</table>
</cfform> 

</cfoutput>

<center><a href="BIMPD.cfm" class="btn btn-dark btn-sm m-1">回上一頁</a></center>



