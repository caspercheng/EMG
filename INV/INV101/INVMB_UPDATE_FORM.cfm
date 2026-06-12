<cfinclude template="/EMG/menu.cfm">


<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
    SELECT  *
    FROM INVMB
    LEFT JOIN INVMA ON MA001='2' AND MA002=MB006
	WHERE 1=1
	AND MB001='#URL.MB001#'
</cfquery>

<cfquery datasource="#SESSION.COMPANY#" name="INVMC">
    SELECT  *
    FROM INVMC
    LEFT JOIN (SELECT MC001 AS CODE,MC002 AS NAME FROM CMSMC) AS CMSMC ON MC002=CODE
	WHERE 1=1
	AND MC001='#URL.MB001#'
</cfquery>

<!---查詢製程資料--->
<cfquery datasource="#SESSION.COMPANY#" name="BOMMF">
    SELECT  *
    FROM BOMMF
	JOIN CMSMW ON MW001=MF004
	WHERE 1=1 AND MF001='#URL.MB001#'
	ORDER BY MF003
</cfquery>

<!---查詢採購分類--->
<cfquery datasource="#SESSION.COMPANY#" name="INVMA">
    SELECT  *
    FROM INVMA
	WHERE 1=1
	AND MA001='2'
</cfquery>


<h4><center>品號資料更新作業</center></h4>

<!---使用者輸入條件--->
<cfoutput>
<cfloop query="INVMB">
	
<cfform action="INVMB_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">

<table border="1" align="center" >

	<tr>	
		<td colspan="2" align="center"><input type="submit" name="submit" value="更新" class="btn btn-primary"></td>
	</tr>

	<tr>
		<td  bgcolor="666666" style="color:FFF">品號</td>
		<td><input name="MB001" readonly='yes' value="#MB001#"></td>
	</tr>
	
	<tr>
		<td  bgcolor="666666" style="color:FFF">品名</td>
		<td><input name="MB002" size="40" value="#MB002#" readonly></td>
	</tr>

	<tr>
		<td  bgcolor="666666" style="color:FFF">規格</td>
		<td><input name="MB003" size="40" value="#MB003#" readonly></td>
	</tr>

	<tr>
		<td  bgcolor="666666" style="color:FFF">單位</td>
		<td><input name="MB004" size="5" value="#MB004#" readonly></td>
	</tr>		
	
	<tr>
		<td  bgcolor="666666" style="color:FFF">採購分類</td>
		<td>
			<cfselect name="MB006">
			<option value="#MB006#">#MA003#</option>
			</cfselect>
		</td>
	</tr>		

	<tr>
		<td  bgcolor="666666" style="color:FFF">前置天數</td>
		<td><cfinput name="MB036" size="5" value="#MB036#" range="0,181" message="前置天數輸人錯誤！"></td>
	</tr>		

	<tr>
		<td  bgcolor="666666" style="color:FFF">最低補量</td>
		<td><cfinput name="MB039" size="5" value="#NUMBERFORMAT(MB039,"9999999")#" range="0,999999" message="最低補量輸人錯誤！"></td>
	</tr>		
	

  <tr bgcolor="FFFFCC">
	  <td  bgcolor="666666" style="color:FFF">2D圖面PDF檔</td>
      <td><cfif fileExists("\\192.168.0.9\AGP\CF_files\INVMB\#trim(MB001)#.pdf")>
			 <a href="PDF_OPEN.cfm?MB001=#MB001#" target="_blank">開啟</a>
			 <a href="PDF_DELETE.cfm?MB001=#MB001#">刪除檔案</a>
			</cfif>
            <input type="file" name="fileName1" size="50"  ></td>
  </tr>

  <tr bgcolor="FFFFCC">
	  <td  bgcolor="666666" style="color:FFF">品檢圖</td>
      <td><cfif fileExists("\\192.168.0.9\AGP\CF_files\INVMB\#trim(MB001)#_check.pdf")>
			 <a href="PDF_OPEN3.cfm?MB001=#MB001#" target="_blank">開啟</a>
			 <a href="PDF_DELETE.cfm?MB001=#trim(MB001)#_check">刪除檔案</a>
			</cfif>
            <input type="file" name="fileName3" size="50"  ></td>
  </tr>

  <tr bgcolor="FFFFCC">
	  <td  bgcolor="666666" style="color:FFF">零件圖示</td>
      <td>
			<cfif fileExists("\\192.168.0.9\AGP\CF_files\INVMB_PHOTO\#trim(MB001)#.jpg")>
			 <a href="PHOTO_OPEN.cfm?MB001=#MB001#" target="_blank">開啟</a>
             <a href="PHOTO_DELETE.cfm?MB001=#MB001#">刪除檔案</a>
			</cfif>
      <input type="file" name="fileName2" size="50"  ></td>
  </tr>
  
</table>

</cfform>
</cfloop>	
<P>

<table align="center" border="1">

<TR bgcolor="666666" style="color:FFF">
	<TH>庫別代號</TH>
	<TH>庫別名稱</TH>
	<TH>儲存位置</TH>
	<TH>儲位更新</TH>
	<TH>更新</TH>
</TR>
   <cfloop query="INVMC">
   <cfform action="INVMC_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">    
   
   <cfinput name="MC001" type="hidden" value="#MC001#">
   <cfinput name="MC002" type="hidden" value="#MC002#">
   
   <tr>
        <td>#CODE#</td>
		<td>#NAME#</td>
		<td>#MC003#</td>
		<td><cfinput name="MC003" size="15" type="text" value="#MC003#"></td>
		<td><input type="submit" name="submit" value="更新" class="btn btn-primary"></td>
 </tr>
 </cfform>
 </cfloop>
 </table>

<P>

<table align="center" border="1">

<TR bgcolor="666666" style="color:FFF">
	<TH>製程代號</TH>
	<TH>製程代號</TH>
	<TH>製程品名</TH>
	<TH>加工單位</TH>
	<TH>上傳說明</TH>
	<TH>製程圖檔PDF</TH>
	<TH>更新</TH>
</TR>
   <cfloop query="BOMMF">
   <cfform action="BOMMF_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">    
   
   <cfinput name="MF001" type="hidden" value="#MF001#">
   <cfinput name="MF004" type="hidden" value="#MF004#">
   
   <tr>
        <td>#MF003#</td>
        <td>#MF004#</td>
		<td>#MW002#</td>
		<td>#MF007#</td>
		<td>#MF031#</td>
        <td>
		   <cfif fileExists("\\192.168.0.9\AGP\CF_files\BOMMF\#trim(MB001)#_#MF004#.pdf")>
			 <a href="PDF_OPEN2.cfm?MF001=#trim(MF001)#&MF004=#trim(MF004)#" target="_blank">開啟</a>
			 <a href="PDF_DELETE2.cfm?MF001=#trim(MF001)#&MF004=#trim(MF004)#">刪除檔案</a>
			</cfif>
			<input type="file" name="fileName1" size="50"  >
		</td>
		<td><input type="submit" name="submit" value="更新" class="btn btn-primary"></td>
 </tr>
 </cfform>
 </cfloop>
 </table>
 
<center><h4><a href="INVMB.cfm" class="btn btn-dark">回上一頁</a></h4></center>

</cfoutput>
 
<cfinclude template="/EMG/footer.cfm">

