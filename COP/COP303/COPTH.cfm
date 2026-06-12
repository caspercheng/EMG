<title>銷貨單查詢</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "COP303" >
<cfset program_name = "銷貨單查詢" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.TH014")><cfset #FORM.TH014#=""></cfif> 
<cfif NOT IsDefined("FORM.TH015")><cfset #FORM.TH015#=""></cfif> 
<cfif NOT IsDefined("FORM.TG001")><cfset #FORM.TG001#=""></cfif> 
<cfif NOT IsDefined("FORM.TG002")><cfset #FORM.TG002#=""></cfif>
<cfif NOT IsDefined("FORM.TG023")><cfset #FORM.TG023#=""></cfif> 
<cfif NOT IsDefined("FORM.MA002")><cfset #FORM.MA002#=""></cfif> 
<cfif NOT IsDefined("FORM.TG003_1")><cfset #FORM.TG003_1#=""></cfif> 
<cfif NOT IsDefined("FORM.TG003_2")><cfset #FORM.TG003_2#=""></cfif> 
<cfif NOT IsDefined("FORM.TH005")><cfset #FORM.TH005#=""></cfif> 
<cfif NOT IsDefined("FORM.TH019")><cfset #FORM.TH019#=""></cfif> 
<cfif NOT IsDefined("FORM.submit")><cfset #FORM.submit#=""></cfif> 
<cfif NOT IsDefined("FORM.num")><cfset #FORM.num#="500"></cfif> 

<cfoutput>

<h4 align="center">銷貨單查詢</h4>

<!---使用者查詢條件--->
<cfform action="COPTH.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
		 
	  <td>單別</td><td><cfinput type="text" size="1" name="TG001" maxlength="4" value=""></td>
	  <td>單號</td><td><cfinput type="text" size="8" name="TG002" maxlength="12"></td>
	  <td>銷貨日期</td> 
	  <td><input type="date" name="TG003_1" size="10">～</td>
	  <td><input type="date" name="TG003_2" size="10"></td>
	  <td>客戶簡稱</td><td><cfinput type="text" size="8" name="MA002"></td>
	  <td>客戶品號</td><td><cfinput type="text" size="10" name="TH019"></td>
	  <td>品名</td><td><cfinput type="text" size="10" name="TH005"></td>
      <td>訂單單別</td><td><cfinput type="text" size="1" name="TH014" maxlength="4" value=""></td>
	  <td>單號</td><td><cfinput type="text" size="8" name="TH015" maxlength="12"></td>

      <td>確認碼</td>
	  <td>
	      <select name="TG023">
		     <option value="">全部</option>
			 <option value="N">未確認</option>
			 <option value="Y">已確認</option>
	      </select></td>
	  <td>筆數</td><td><select name="num"><option value="500">500</option><option value="1000">1000</option><option value="2000">2000</option></select></td>
	  <td colspan="1" align="center"><input type="submit" name="submit" value="查詢"></td>
	  </tr>
	</table>

</cfform>


<cfquery datasource="#SESSION.COMPANY#" name="COPTH">
    SELECT TOP #FORM.num#  *
    FROM COPTH
	JOIN COPTG ON TH001=TG001 AND TH002=TG002
	LEFT JOIN COPTD ON TD001=TH014 AND TD002=TH015 AND TD003=TH016

	JOIN INVMB ON MB001=TH004
	JOIN COPMA ON MA001=TG004
	WHERE 1=1 AND TH020 <> 'V'
    <cfif FORM.TG001 IS NOT ""> AND TG001 = '#FORM.TG001#'</cfif>
    <cfif FORM.TG023 IS NOT ""> AND TG023 = '#FORM.TG023#'</cfif>
    <cfif FORM.TH014 IS NOT ""> AND TH014 = '#FORM.TH014#'</cfif>
    <cfif FORM.TH015 IS NOT ""> AND TH015 = '#FORM.TH015#'</cfif>
    <cfif FORM.TG002 IS NOT ""> AND TG002 like '#FORM.TG002#%'</cfif>
    <cfif FORM.MA002 IS NOT ""> AND MA002 like '%#FORM.MA002#%'</cfif>
	<cfif FORM.TG003_1 IS NOT ""> AND SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) >= '#FORM.TG003_1#'</cfif>
	<cfif FORM.TG003_2 IS NOT ""> AND SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) <= '#FORM.TG003_2#'</cfif>
    <cfif FORM.TH019 IS NOT ""> AND TH019 like '%#FORM.TH019#%'</cfif>
    <cfif FORM.TH005 IS NOT ""> AND TH005 like '%#FORM.TH005#%'</cfif>
	ORDER BY TG003 DESC,TG001,TG002
</cfquery>

<a href="COPTH_excel.cfm?TG001=#FORM.TG001#&TG023=#FORM.TG023#&TH014=#FORM.TH014#&TH015=#FORM.TH015#&TG002=#FORM.TG002#&MA002=#FORM.MA002#&TG003_1=#FORM.TG003_1#&TG003_2=#FORM.TG003_2#&TH019=#FORM.TH019#&TH005=#FORM.TH005#&num=#FORM.num#" class="btn btn-success">轉EXCEL</a>

<div style="height:85%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR bgcolor="666666" style="color:FFF">
	<TH>銷貨單別-單號<BR/>訂單單別-單號</TH>	
	<TH>銷貨日期</TH>
	<TH>客戶簡稱</TH>	
    <TH>品號</TH>
	<TH>品名/規格</TH>
	<TH>銷貨數量</TH>
	<cfif #價格權限# eq "Y">
	<TH>單價</TH>
	<TH>金額</TH>
	</cfif>
	<TH>結帳單</TH>    
</TR>

</thead>

<tbody>

<cfset SUMTH008 =  0>
<cfset SUMTH013 =  0>

<cfloop query="COPTH">

<cfset SUMTH008 =  SUMTH008 +TH008>
<cfset SUMTH013 =  SUMTH013 +TH013>

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	
    <tr bgcolor="#bgcolor#">
		<TD align="center">#TRIM(TG001)#-#TRIM(TG002)#-#TH003#<br/>#TRIM(TH014)#-#TRIM(TH015)#-#TH016#<cfif TG023 EQ "N"><span class="badge badge-warning">未確認</span></cfif></TD>		
		<TD align="center" width="100">#MID(TG003,1,4)#-#MID(TG003,5,2)#-#MID(TG003,7,2)#</TD> 
		<TD align="center">#MA002#</TD>		
        <TD align="center" width="120">#TH004#</TD>
		<TD width="250">#TH005#<BR/>#TH006#</TD> 
		<TD align="right">#NUMBERFORMAT(TH008,"9,999,999")#</TD>
		<cfif #價格權限# eq "Y">
		<TD align="right">#NUMBERFORMAT(TH012,"9,999,999.99")#</TD>
		<TD align="right">#NUMBERFORMAT(TH013,"99,999,999")#</TD>
		</cfif>
		<TD align="center">#TRIM(TH027)#-#TRIM(TH028)#-#TH029#</TD>		
	</tr>
</cfloop>

	<tr bgcolor="666666">
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD align="center" style="color:FFF">小計</TD>
		<TD align="right" style="color:FFF">#NUMBERFORMAT(SUMTH008,"99,999,999")#</TD>
		<TD></TD>

		<cfif #價格權限# eq "Y">
		<TD align="right" style="color:FFF">#NUMBERFORMAT(SUMTH013,"999,999,999")#</TD>
		</cfif>
		<TD></TD>
	</tr>

</tbody>

</table>

</div>

 </cfoutput>

<cfinclude template="/EMG/footer.cfm">
