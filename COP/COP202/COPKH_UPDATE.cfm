<title>多階成本核價表</title>

<cfinclude template="/EMG/menu.cfm">


<!---查詢資料--->
<cfquery name="COPKG" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKG
	LEFT JOIN INVMB ON MB001=KG002	
	WHERE 1=1
      AND KG001= '#TRIM(URL.KG001)#'
</cfquery>

<!---查詢資料--->
<cfquery name="COPKH" datasource="#SESSION.COMPANY#">
	SELECT *,A.MA002 A_MA002,B.MA002 B_MA002
	FROM COPKH
	JOIN INVMB ON KH004=MB001
	LEFT JOIN PURMA A ON A.MA001=KH009
	LEFT JOIN PURMA B ON B.MA001=KH013
	WHERE 1=1
      AND KH001= '#TRIM(URL.KG001)#'
</cfquery>

<cfoutput>

<h4 align="center">多階成本核價表</h4>

<cfloop query="COPKG">

<div style="text-align:center">單號：#KG001#</div>


<cfform action="COPKG_UPDATE_SQL.cfm" enctype="multipart/form-data"  method="post">
<cfinput type="hidden" name="KG001" value="#KG001#">
<cfinput type="hidden" name="KG003" value="#KG003#">
<table align="center" border="1" bordercolor="000000">

  <tr ><td colspan="4">
  			<cfinput type="submit" name="submit" value="更新核價" class="btn btn-success m-1">
<!---  			<cfinput type="submit" name="submit" value="更新" class="btn btn-primary m-1">
--->		
			</td>
	</tr>
  
  <tr>
		<td bgcolor="666666" style="color:FFF">品號：</td>
		<td>#KG002#
		</td>
		<td bgcolor="666666" style="color:FFF">基準日</td>
		<td>#KG003#
		</td>  	
	</tr>
  
  <tr>
	  <td bgcolor="666666" style="color:FFF">核價前總金額</td>
	  <td>
	  <cfinput type="text" name="KG004"  size="8" value="#NUMBERFORMAT(KG004,"999,999,999")#" style="text-align:right">
	  </td>
	  <td bgcolor="666666" style="color:FFF">核價後總金額</td>
	  <td>
	  <cfinput type="text" name="KG005"  size="8" value="#NUMBERFORMAT(KG005,"999,999,999")#" style="text-align:right">
	  </td>
	 </tr>
	 <TR>
	  <td bgcolor="666666" style="color:FFF">整筆價核浮動幅度</td>
	  <td><cfinput type="text" name="KG006"  size="8" value="#numberformat(KG006*100,"999.99")#%"  style="text-align:right"> </td>
	</tr>
	<TR>
	  <td bgcolor="666666" style="color:FFF">備註</td>
	  <td colspan="3"> <cfinput type="text" name="KG007"  size="40" value="#KG007#" maxlength="40" ></td>
  </tr>   
</table>
</cfform> 

</cfloop>
<hr style="border-color:CCCCCC; width:80%">



<table align="center"  border="1" >
	<tr bgcolor="666666" style="color:FFF" align="center">
		<td>階次</td>
		<td>元件品號</td>
		<td>品名/規格</td>
		<td>庫存單位</td>
		<td>標準用量</td>
		<td>核價前材料費</td>
		<td>核價前加工費</td>
		<td>核價前總金額</td>
		<td>核價前廠商</td>
		<td>核價後材料費</td>
		<td>核價後加工費</td>
		<td>核價後總金額</td>
		<td>核價後廠商</td>
		<td>異動金額</td>
		<td>價格浮動幅度</td>
		<td>新核價單號</td>
<!---		<td align="center">更新</td>
		<td align="center">取消</td>
--->	</tr>

<cfloop query="COPKH" > 	
<cfform action="COPKH_UPDATE_SQL.cfm" method="post">
<cfinput type="hidden" name="KH001"  value="#KH001#">
<cfinput type="hidden" name="KH002"   value="#KH002#">
	 
    <tr>
		<td>#KH003#</td>
		<td>#KH004#</td>
		<td>#MB002#<BR>#MB003 #</td>
		<td>#KH019#</td>
		<td align="right">#KH005#</td>
		<td align="right">#NUMBERFORMAT(KH006,"999,999,999.99")#</td>
		<td align="right">#NUMBERFORMAT(KH007,"999,999,999.99")#</td>
		<td align="right">#NUMBERFORMAT(KH008,"999,999,999.99")#</td>
		<td>#A_MA002#</td>
		<td align="right">#NUMBERFORMAT(KH010,"999,999,999.99")#</td>
		<td align="right">#NUMBERFORMAT(KH011,"999,999,999.99")#</td>
		<td align="right">#NUMBERFORMAT(KH012,"999,999,999.99")#</td>
		<td>#B_MA002#</td>
		<td align="right">#KH014#</td>		
		<td align="right"><cfif #KH015# NEQ 0>#NUMBERFORMAT(KH015*100,"999,999,999.99")#%</cfif></td>
		<td>#KH016#-#KH017#-#KH018#</td>
<!---		<td><cfinput type="submit" name="submit" value="更新" class="btn btn-primary m-1"></td>
		<td align="center">
		<a href="COPKH_DELETE_SQL.cfm?KH001=#KH001#&KH002=#KH002#" class="btn btn-warning btn-sm m-1" onclick = "if (! confirm('是否確認要取消此筆?')) { return false; }">取消</a>
		</td>
--->	</tr>
</cfform>
</cfloop>	
</table>
</cfoutput>
<BR />
<center><input type="button" value="結束-關閉視窗" onClick="top.window.close()" class="btn btn-outline-warning"></center>

<cfinclude template="/EMG/footer.cfm">

