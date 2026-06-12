
<cfinclude template="/EMG/menu.cfm">


<cfquery name="BIMPC" datasource="PKOOL">
	SELECT PC001,PC002,PC003,PC004,PC005,
	BIMPB1.PB002 AS BIMPB1_PB002,
	BIMPB2.PB002 AS BIMPB2_PB002,
	BIMPB3.PB002 AS BIMPB3_PB002
	FROM BIMPC
	LEFT JOIN BIMPB  as BIMPB1 ON BIMPB1.PB001=PC003
	LEFT JOIN BIMPB  as BIMPB2 ON BIMPB2.PB001=PC004
	LEFT JOIN BIMPB  as BIMPB3 ON BIMPB3.PB001=PC005
	WHERE PC001='#URL.PC001#'
</cfquery>


<cfoutput>
<center><h4>部門組織維護作業</h4></center>

<cfloop query="BIMPC">

<cfform action="BIMPC_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">
<table align="center" border="1" bordercolor="000000">
  <cfinput type="Hidden" name="PC001"   value="#PC001#">
  
  <tr><td colspan="4"><cfinput type="submit" name="submit" value="更新"></td></tr>
  
  <tr >
	  <td>部門代號</td>
	  <td>#PC001#</td>
  </tr>
  
  <tr>
	  <td>部門名稱</td>
	  <td>#PC002#</td>
  </tr> 
   
  <tr bgcolor="99CCCC">
	  <td>部門主管工號</td>
	  <td><cfinput type="text" name="PC003"  size="10" value="#PC003#"   maxlength="30" message="部門主管不可空白">#BIMPB1_PB002#</td>
  </tr> 
 
                    
</table>
</cfform> 

</cfloop>
</cfoutput>

<center><a href="BIMPC.cfm" class="btn btn-dark">回上一頁</a></center>
<cfinclude template="/EMG/footer.cfm">

