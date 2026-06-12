<!---公佈欄資料新增作業---> 

<cfinclude template="/EAGLE/menu.cfm">

<cfoutput>
<center><h4>公佈欄資料新增作業</h4></center>

<cfform action="BIMKA_INSERT_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">

  <tr ><td colspan="4"><cfinput type="submit" name="submit" value="新增"></td></tr>

	  <tr>
	  <td>日期</td>
	　<td><cfinput type="datefield"  pattern="YYYY-MM-DD" mask="yyyy-mm-dd" name="KA002" size="10"  value="#Dateformat(now(),"yyyy-mm-dd")#"  monthnames="一月,二月,三月,四月,五月,六月,七月,八月,九月,十月,十一月,十二月" firstdayofweek="1" maxlength="10" ></td>
  </tr> 

  <tr>
	  <td>標題</td>
	  <td><cfinput type="text" name="KA003"  size="40" value="" required="yes"  maxlength="80" message="標題不可空白"></td>
  </tr> 
   
  <tr>
	  <td>內容</td>
	  <td><textarea name="KA004" cols="60" rows="15"></textarea></td>
  </tr> 

</table>
</cfform> 

</cfoutput>

<center><a href="BIMKA.cfm" class="btn btn-dark">回上一頁</a></center>

<cfinclude template="/EAGLE/footer.cfm">


