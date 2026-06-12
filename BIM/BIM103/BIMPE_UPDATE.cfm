<!---網頁程式名稱維護作業---> 
<title>網頁程式維護修改</title>
<cfinclude template="/EMG/menu.cfm">

<!---查詢文具用品資料--->
<cfquery name="BIMPE" datasource="PKOOL">
	SELECT *
	FROM BIMPE
	JOIN BIMPD ON PE003=PD001
	WHERE PE001='#URL.PE001#'
</cfquery>

<!---查詢模組資料--->
<cfquery name="BIMPD" datasource="PKOOL">
	SELECT *
	FROM BIMPD
</cfquery>

<cfoutput>
<center><h4>網頁程式維護作業：修改</h4></center>

<cfloop query="BIMPE">

<cfform action="BIMPE_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">

<tr><td colspan="4"><cfinput type="submit" name="submit" value="更新" class="btn btn-primary btn-sm m-1"></td></tr>
    
  <tr bgcolor="99CCCC">
	  <td>程式代號</td>
	  <td><cfinput type="text" name="PE001"  size="10" value="#PE001#" maxlength="10" ></td>
  </tr>
  
  <tr>
	  <td>程式名稱</td>
	  <td><cfinput type="text" name="PE002"  size="30" value="#PE002#" required="yes"  maxlength="30" message="檔案名稱不可空白"></td>
  </tr> 
   
  <tr>
	  <td>模組名稱</td>
	  <td>
	  <cfselect name="PE003">
	   <option value="#PE003#">#PD002#</option>
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
	   <option value="#PE004#">#PE004#</option>
	   <option value="I">I:建檔</option>
	   <option value="B">B:批次</option>
	   <option value="R">R:報表/憑證</option>
	   <option value="Q">Q:查詢</option>
	  </cfselect>
	  </td>
  </tr> 

   <tr>
	  <td>網址路徑</td>
	  <td><cfinput type="text" name="PE005"  size="50" value="#PE005#" maxlength="100" ></td>
  </tr> 

    
</table>
</cfform> 

</cfloop>

<center><h4><a href="BIMPE.cfm" class="btn btn-dark btn-sm m-1">回上一頁</a></h4></center>

</cfoutput>


