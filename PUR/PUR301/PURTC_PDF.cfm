<!---依前端勾選條件，查詢採購單內容--->

<cfquery name="PURTC" datasource="#SESSION.COMPANY#" >
	SELECT *
	FROM PURTC
	JOIN PURMA ON MA001=TC004
	LEFT JOIN CMSMV ON TC011=MV001
    LEFT JOIN CMSNA ON NA002=MA055 AND NA001='1'
	WHERE  1=1
	AND TC001 = '#URL.TC001#'
	AND TC002 = '#URL.TC002#'
</cfquery>
 
<cfquery name="PURTD" datasource="#SESSION.COMPANY#" >
	SELECT *
	FROM PURTD
    LEFT JOIN INVMB ON TD004=MB001
	LEFT JOIN PURTB ON TD026=TB001 AND TD027=TB002 AND TD028=TB003
	LEFT JOIN CMSNB ON NB001=TD022
	WHERE  1=1
	AND TD001 = '#URL.TC001#'
	AND TD002 = '#URL.TC002#'
</cfquery>
 
<!---查詢採購單名稱--->
<cfquery name="CMSMQ" datasource="#SESSION.COMPANY#" >
	SELECT *
	FROM CMSMQ
	WHERE  1=1
	AND MQ001 = '#URL.TC001#'
</cfquery>

<cfquery name="sign" datasource="#SESSION.COMPANY#" >
	SELECT TOP 1 *
	FROM PURTD
	LEFT JOIN PURTB ON TD026=TB001 AND TD027=TB002 AND TD028=TB003
	WHERE  1=1
	AND TD001 = '#URL.TC001#'
	AND TD002 = '#URL.TC002#'
</cfquery>

<!---
<cfquery name="KA032_UPDAT" datasource="#APPLICATION.dataSource#" >
	UPDATE PURTC SET TC013=1
	FROM PURTC
	WHERE  1=1
	AND TC001 = '#TC001#'
	AND TC002 = '#TC002#'
</cfquery>
--->

<cfoutput>

<cfloop query="CMSMQ"><cfset rev_name=#MQ002#></cfloop>

<cfset i=9>
<cfset page= Ceiling(PURTD.recordcount/i)>

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
  <td><div style="font:'微軟正黑體';font-size:24px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;元順利有限公司
            <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;採購單</div></td>
  <td></td>
  </tr>
  <tr><td colspan="2" width="800">
  <center><div style="font:'微軟正黑體';font-size:14px" style="border-bottom:1px 000000 solid;">
  統一編號:28668877  &nbsp;&nbsp; 地址:427台中市潭子區中山路三段169號  &nbsp;&nbsp; 電話:04-2534 5219  &nbsp;&nbsp; 
  </div></center>
  </td>
  </tr>
</table>

<cfloop query="PURTC" >
<table style="font:'微軟正黑體';font-size:14px"   >
	<tr>
	<td bgcolor="F0F0F0">廠商名稱：</td><td width="250">#MA001# #MA003#</td>
	<td  bgcolor="F0F0F0">採購日期：</td><td>#MID(TC003,1,4)#-#MID(TC003,5,2)#-#MID(TC003,7,2)#</td>
	</tr>
	
	<tr>
	<td bgcolor="F0F0F0">聯絡人：</td><td>#MA013#</td>   
	<td  bgcolor="F0F0F0">採購單號：</td><td>#TC001#-#TC002#</td>
	</tr>
	
	<tr>
	<td  bgcolor="F0F0F0">電話：</td><td>#MA008#</td>   
	<td  bgcolor="F0F0F0">幣別：</td><td>#TC005#</td>
	</tr>
	
	<tr>
	<td  bgcolor="F0F0F0">傳真：</td><td>#MA010#</td>   
	<td  bgcolor="F0F0F0">匯率：</td><td>#NUMBERFORMAT(TC006,"999.999")#</td>
	</tr>
	
	<tr>
	<td  bgcolor="F0F0F0">採購人：</td><td>#MV002#&nbsp;#MV015#</td>   
	<td  bgcolor="F0F0F0">廠商地址：</td><td>#MA014#</td>
	</tr>
	
	<tr>
	<td  bgcolor="F0F0F0">送貨地址：</td><td>#TC021#</td>
	<td  bgcolor="F0F0F0">付款條件：</td><td>#NA003#</td>
	</tr>
	
	<tr>
	<td  bgcolor="F0F0F0">備註：</td><td colspan="3">#TC009#</td>
	</tr>
</table>

</cfloop>

</cfdocumentitem>


<table  style="font:'微軟正黑體';font-size:14px" style="border-top:1px 000000 solid;border-bottom:1px 000000 solid;">
	<tr bgcolor="F0F0F0">
		<td>序號</td>
		<td>品號</td>
		<td>品名/規格</td>
		<td>預交日</td>
		<td align="center">數量</td>
		<td align="center">單位</td>
		<td align="center">單價</td>
		<td align="center">金額</td>
	</tr>

<!---單身--->
<cfloop query="PURTD"  startrow="#start#" endrow="#end#"> 	

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="FFFFFF"></cfif>

    <tr>
		<td width="30">#TD003#</td>
		<td width="100">#TD004#<BR/>#NB002#</td>
		<td width="260">#TD005#<BR/>#TD006#</td>
		<td width="100">#MID(TD012,1,4)#-#MID(TD012,5,2)#-#MID(TD012,7,2)#</td>
		<td  align="center" width="50">#NUMBERFORMAT(TD008,"9,999,999")#</td>
		<td  align="center" width="35">#TD009#</td>
		<td align="center" width="50">#NUMBERFORMAT(TD010,"999,999.99")#</td>
		<td align="right" width="50">#NUMBERFORMAT(TD011,"9,999,999")#</td>
	</tr>
    <tr>
		<td  colspan="20">備註：#TD014# 請購單：#TD026#-#TD027#-#TD028#</td>
	</tr>
     <tr >
		<td colspan="10" >--------------------------------------------------------------------------------------------------------</td>
	</tr>

</cfloop>	

<cfif #a# neq #page#>
     <tr >
		<td colspan="10"  align="center">接續下一頁</td>
	</tr>

</cfif>

<!---單尾--->	
<cfif #a# eq #page#>
	 <cfloop query="PURTC">
		<td ></td>
		<td ></td>
		<td ></td>
		<td ></td>
		<td> </td>
		<td></td>
		<td bgcolor="F0F0F0"><BR/>金額合計<BR/>稅額<BR/>金額總計</td>
		<td align="right" width="60">
		   <BR/>#NUMBERFORMAT(TC019,"9,999,999")#
		   <BR/>#NUMBERFORMAT(TC020,"9,999,999")#
		   <BR/>#NUMBERFORMAT(TC019+TC020,"9,999,999")#
		   </td>
	</cfloop>  	
</table>
		
<p/>
    
	<div style="font:'微軟正黑體';font-size:16px">
      1.請簽名回傳並確認交期。<br/>
	  2.收貨時間：上午11：00前，下午4：00前，逾期不收料。<br/>
	  3.交期與素材數量，請確認。<br/>
	  4.首件合格才可生產。
	</div>
<!--- 
    <cfloop query="PURTC">
	<div style="font:'微軟正黑體';font-size:16px">核准：</div>
    <cfif #TC014# EQ "Y"> <img src="sign.jpg" width="300"></cfif>
    </cfloop> 
    --->
<p/>
<p/>

	<div style="font:'微軟正黑體';font-size:16px">
      主管核准：<cfloop query="sign">#TB055#</cfloop>
	  <br/><br/>
      經辦人員：</div>
      
 </cfif>
 

<!---於畫面下方顯示頁碼--->
<cfdocumentitem type="footer" evalatprint="true" >     
  <center>#cfdocument.currentpagenumber# /#cfdocument.totalpagecount#</center>
</cfdocumentitem>

</cfdocumentsection>     

</cfloop>

</cfdocument>

</cfoutput>
