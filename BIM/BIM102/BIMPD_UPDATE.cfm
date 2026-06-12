<title>模組維護作業</title>
<!---模組增作業---> 

<cfinclude template="/EMG/menu.cfm">

<!---查詢模組資料--->
<cfquery name="BIMPD" datasource="PKOOL">
	SELECT *
	FROM BIMPD
	WHERE PD001='#URL.PD001#'
</cfquery>


<cfoutput>
<center><h4>模組維護作業</h4></center>

<cfloop query="BIMPD">

<cfform action="BIMPD_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">

  <tr><td colspan="4"><cfinput type="submit" name="submit" value="更新"></td></tr>
  
  <tr bgcolor="99CCCC">
	  <td>模組代號</td>
	  <td><cfinput type="text" name="PD001"  size="10" value="#PD001#" readonly="YES" maxlength="10" ></td>
  </tr>
  
  <tr>
	  <td>模組名稱</td>
	  <td><cfinput type="text" name="PD002"  size="30" value="#PD002#" required="yes"  maxlength="30" message="系統名稱不可空白"></td>
  </tr> 
   
  <tr>
	  <td>模組英文名稱</td>
	  <td><cfinput type="text" name="PD003"  size="30" value="#PD003#"   maxlength="30" message="英文名稱不可空白"></td>
  </tr> 
 
  
  
      
                  
</table>
</cfform> 

</cfloop>
</cfoutput>

<center><a href="BIMPD.cfm" class="btn btn-dark btn-sm m-1">回上一頁</a></center>


