<!---公佈欄資料新增作業---> 

<cfinclude template="/EAGLE/menu.cfm">

<cfquery datasource="EAGLE" name="BIMKA">
    SELECT  *	    
    FROM BIMKA
	WHERE 1=1  AND KA001='#URL.KA001#'
</cfquery>
	
<cfoutput>
<center><h4>公佈欄資料更新作業</h4></center>

<cfloop query="BIMKA">
	
<cfform action="BIMKA_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">
     <cfinput type="Hidden" name="KA001"   value="#KA001#">
  <tr ><td colspan="4"><cfinput type="submit" name="submit" value="更新"></td></tr>

	  <tr>
	  <td>日期</td>
	　<td><cfinput type="datefield"  pattern="YYYY-MM-DD" mask="yyyy-mm-dd" name="KA002" size="10"  value="#KA002#"  monthnames="一月,二月,三月,四月,五月,六月,七月,八月,九月,十月,十一月,十二月" firstdayofweek="1" maxlength="10" ></td>
  </tr> 

  <tr>
	  <td>標題</td>
	  <td><cfinput type="text" name="KA003"  size="40" value="#KA003#" required="yes"  maxlength="80" message="標題不可空白"></td>
  </tr> 
   
  <tr>
	  <td>內容</td>
	  <td><textarea name="KA004" cols="60" rows="15">#KA004#</textarea></td>
  </tr> 

</table>
</cfform> 

</cfloop>
</cfoutput>

<center><a href="BIMKA.cfm" class="btn btn-dark">回上一頁</a></center>

<cfinclude template="/EAGLE/footer.cfm">


