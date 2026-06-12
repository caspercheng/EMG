<!---依前端勾選條件，查詢採購單內容--->

<cfquery name="COPTA" datasource="#SESSION.COMPANY#" >
	SELECT *
	FROM COPTA
	JOIN COPMA ON MA001=TA004
	LEFT JOIN CMSMV ON TA005=MV001
    LEFT JOIN CMSNA ON NA002=MA055 AND NA001='2'
	WHERE  1=1
	AND TA001 = '#URL.TA001#'
	AND TA002 = '#URL.TA002#'
</cfquery>
 
<cfquery name="COPTB" datasource="#SESSION.COMPANY#" >
	SELECT *
	FROM COPTB
    LEFT JOIN INVMB ON TB004=MB001
	WHERE  1=1
	AND TB001 = '#URL.TA001#'
	AND TB002 = '#URL.TA002#'
</cfquery>
 
<cfoutput>

<cfset i=9>
<cfset page= Ceiling(COPTB.recordcount/i)>

<!---標籤列印程式碼--->
<cfdocument pagetype="A4" format="pdf"  margintop="2.8" marginleft="0.2" marginright="0.2"> 

<cfloop from="1" to="#page#" index="a" >

<cfset start = #numberformat((a-1)*i+1,"999")#>
<cfset end = #numberformat(start+i-1,"999")#>

<cfdocumentsection>

<!---表頭--->
<cfdocumentitem type="header">

<table>
  <tr>
  <td width="90"><!---<img src="logo.jpg" width="90">---></td>
  <td><div style="font:'微軟正黑體';font-size:24px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 微笑元素
            <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;報價單</div></td>
  <td></td>
  </tr>
  <tr><td colspan="2" width="800">
  <center><div style="font:'微軟正黑體';font-size:14px" style="border-bottom:1px 000000 solid;">
  統一編號:53960554  &nbsp;&nbsp; 地址:40465 台中市太原路二段66號7樓  &nbsp;&nbsp; 電話:+886 4 2206 1119  &nbsp;&nbsp; 
  </div></center>
  </td>
  </tr>
</table>

<cfloop query="COPTA" >
<table style="font:'微軟正黑體';font-size:14px"   >
	<tr>
	<td bgcolor="F0F0F0">客戶名稱：</td><td width="250">#MA001# #MA003#</td>
	<td  bgcolor="F0F0F0">報價日期：</td><td>#MID(TA003,1,4)#-#MID(TA003,5,2)#-#MID(TA003,7,2)#</td>
	</tr>
	
	<tr>
	<td bgcolor="F0F0F0">聯絡人：</td><td>#MA005#</td>   
	<td  bgcolor="F0F0F0">單號：</td><td>#TA001#-#TA002#</td>
	</tr>
	
	<tr>
	<td  bgcolor="F0F0F0">電話：</td><td>#MA006#</td>   
	<td  bgcolor="F0F0F0">幣別：</td><td>#TA007#</td>
	</tr>
	
	<tr>
	<td  bgcolor="F0F0F0">傳真：</td><td>#MA008#</td>   
	<td  bgcolor="F0F0F0">付款條件：</td><td>#NA003#</td>
	</tr>
	
	<tr>
	<td  bgcolor="F0F0F0">業務人員：</td><td>#MV002#&nbsp;#MV015#</td>   
	<td  bgcolor="F0F0F0">地址：</td><td>#MA023#</td>
	</tr>
	
	<tr>
	<td  bgcolor="F0F0F0">備註：</td><td colspan="3">#TA021#</td>
	</tr>
	
</table>

</cfloop>

</cfdocumentitem>


<table  style="font:'微軟正黑體';font-size:14px" style="border-top:1px 000000 solid;border-bottom:1px 000000 solid;">
	<tr bgcolor="F0F0F0">
		<td>序號</td>
		<td>品號</td>
		<td>品名/規格</td>
		<td align="center">數量</td>
		<td align="center">單位</td>
		<td align="center">單價</td>
		<td align="center">金額</td>
		<td>備註</td>
	</tr>

<!---單身--->
<cfloop query="COPTB"  startrow="#start#" endrow="#end#"> 	

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="FFFFFF"></cfif>

    <tr>
		<td width="30">#TB003#</td>
		<td width="90">#TB004#</td>
		<td width="200">#TB005#<BR/>#TB006#</td>
		<td  align="center" width="60">#NUMBERFORMAT(TB007,"9,999,999")#</td>
		<td  align="center" width="40">#TB008#</td>
		<td align="center" width="50">#NUMBERFORMAT(TB009,"999,999.99")#</td>
		<td align="right" width="60">#NUMBERFORMAT(TB010,"9,999,999")#</td>
		<td width="200">#TB012#</td>
	</tr>
     <tr >
		<td colspan="10" >----------------------------------------------------------------------------------------------------------</td>
	</tr>

</cfloop>	

<cfif #a# neq #page#>
     <tr >
		<td colspan="10"  align="center">接續下一頁</td>
	</tr>

</cfif>

<!---單尾--->	
<cfif #a# eq #page#>

</table>
		
<p/>
<!---     
	<div style="font:'微軟正黑體';font-size:16px">
      1.請簽名回傳並確認交期。<br/>
	  2.收貨時間：上午11：00前，下午4：00前，逾期不收料。<br/>
	  3.交期與素材數量，請確認。<br/>
	  4.首件合格才可生產。
	</div>

    <cfloop query="PURTC">
	<div style="font:'微軟正黑體';font-size:16px">核准：</div>
    <cfif #TC014# EQ "Y"> <img src="sign.jpg" width="300"></cfif>
    </cfloop> 
    --->

	<div style="font:'微軟正黑體';font-size:16px">
      主管核准：                                                                                                               
	  <br/><br/>
      經辦人員：
	 </div>
      
 </cfif>
 

<!---於畫面下方顯示頁碼--->
<cfdocumentitem type="footer" evalatprint="true" >     
  <center>#cfdocument.currentpagenumber# /#cfdocument.totalpagecount#</center>
</cfdocumentitem>

</cfdocumentsection>     

</cfloop>

</cfdocument>

</cfoutput>
