<!---檔案新增作業---> 

<cfinclude template="/EMG/menu.cfm">

<!---查詢模組資料--->
<cfquery name="BIMPD" datasource="PKOOL">
	SELECT *
	FROM BIMPD
</cfquery>

<cfoutput>
<center><h4>檔案新增作業</h4></center>

<cfform action="BIMPE_INSERT_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">
 
<tr><td colspan="4"><cfinput type="submit" name="submit" value="新增" class="btn btn-primary btn-sm m-1"></td></tr>
 
  <tr bgcolor="99CCCC">
	  <td>檔案代號</td>
	  <td><cfinput type="text" name="PE001"  size="10" value="" maxlength="10" ></td>
  </tr>
  
  <tr>
	  <td>檔案名稱</td>
	  <td><cfinput type="text" name="PE002"  size="30" value="" required="yes"  maxlength="30" message="檔案名稱不可空白"></td>
  </tr> 
   
  <tr>
	  <td>檔案英文名稱</td>
	  <td>
	  <cfselect name="PE003">
	   <cfloop query="BIMPD">
	   <option value="#PD001#">#PD002#</option>
	   </cfloop>
	  </cfselect>
	  </td>
  </tr> 

  <tr>
	  <td>類型</td>
	  <td>
	  <cfselect name="PE004">
	   <option value="I">I:建檔</option>
	   <option value="B">B:批次</option>
	   <option value="R">R:報表/憑證</option>
	   <option value="Q">Q:查詢</option>
	  </cfselect>
	  </td>
  </tr> 

   <tr>
	  <td>網址路徑</td>
	  <td><cfinput type="text" name="PE005"  size="50" value="" maxlength="100" ></td>
  </tr> 

</table>
</cfform> 

<center><h4><a href="BIMPE.cfm" class="btn btn-dark btn-sm m-1">回上一頁</a></h4></center>

</cfoutput>


