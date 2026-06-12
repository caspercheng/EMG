<!---108.3.27 資料查詢確認碼條件改為未確認、已確認，並增加確認碼及簽核欄位--->
<!---108.4.11 簽核狀態欄位增加開啟簽核憑證圖片檔--->

<title>報價單查詢作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "COP302" >
<cfset program_name = "報價單查詢" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.TA001")><cfset #FORM.TA001#=""></cfif> 
<cfif NOT IsDefined("FORM.TA002")><cfset #FORM.TA002#=""></cfif> 
<cfif NOT IsDefined("FORM.MA002")><cfset #FORM.MA002#=""></cfif> 
<cfif NOT IsDefined("FORM.TA003_1")><cfset #FORM.TA003_1#=""></cfif> 
<cfif NOT IsDefined("FORM.TA003_2")><cfset #FORM.TA003_2#=""></cfif> 
<cfif NOT IsDefined("FORM.MB001")><cfset #FORM.MB001#=""></cfif> 
<cfif NOT IsDefined("FORM.MB002")><cfset #FORM.MB002#=""></cfif>
<cfif NOT IsDefined("FORM.TA019")><cfset #FORM.TA019#=""></cfif> 
<cfif NOT IsDefined("FORM.num")><cfset #FORM.num#="500"></cfif>

<h4><center>報價單查詢作業</center></h4>

<!---使用者查詢條件--->
<cfform action="COPTB.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
		 
	  <td>單別</td><td><cfinput type="text" size="1" name="TA001" maxlength="4" value=""></td>
	  <td>單號</td><td><cfinput type="text" size="8" name="TA002" maxlength="12"></td>

	   <td>報價日期</td> <td>
	  <cfinput type="datefield"  mask="yyyy-mm-dd" name="TA003_1" size="6" 
	  monthnames="一月,二月,三月,四月,五月,六月,七月,八月,九月,十月,十一月,十二月" firstdayofweek="1" maxlength="10" >
	  ～</td>
      <TD><cfinput type="datefield"   mask="yyyy-mm-dd" name="TA003_2" size="6" 
	  monthnames="一月,二月,三月,四月,五月,六月,七月,八月,九月,十月,十一月,十二月" firstdayofweek="1" maxlength="10" ></td>
	  <td>客戶簡稱</td><td><cfinput type="text" size="8" name="MA002"></td>
	  <td>品號</td><td><cfinput type="text" size="10" name="MB001"></td>
	  <td>品名</td><td><cfinput type="text" size="10" name="MB002"></td>
          <td>確認碼</td>
	  <td>
	      <select name="TA019">
		     <option value="">全部</option>
			 <option value="N">未確認</option>
			 <option value="Y">已確認</option>
	      </select></td>

          <td>筆數</td><td><select name="num"><option value="500">500</option><option value="1000">1000</option><option value="2000">2000</option></select></td>

	  <td align="center"><input type="submit" name="submit" value="查詢"></td>

	  </tr>
	</table>

</cfform>

<cfquery datasource="#SESSION.COMPANY#" name="COPTB">
    SELECT TOP #FORM.num# *
    FROM COPTB
	JOIN COPTA ON TA001=TB001 AND TA002=TB002
	JOIN INVMB ON MB001=TB004
	JOIN COPMA ON MA001=TA004
	WHERE 1=1 AND TA019 <> 'V'
    <cfif FORM.TA001 IS NOT ""> AND TA001 = '#FORM.TA001#'</cfif>
    <cfif FORM.TA019 IS NOT ""> AND TA019 = '#FORM.TA019#'</cfif>
    <cfif FORM.TA002 IS NOT ""> AND TA002 like '#FORM.TA002#%'</cfif>
    <cfif FORM.MA002 IS NOT ""> AND MA002 like '%#FORM.MA002#%'</cfif>
	<cfif FORM.TA003_1 IS NOT ""> AND SUBSTRING(TA003,1,4)+'-'+ SUBSTRING(TA003,5,2)+'-'+SUBSTRING(TA003,7,2) >= '#FORM.TA003_1#'</cfif>
	<cfif FORM.TA003_2 IS NOT ""> AND SUBSTRING(TA003,1,4)+'-'+ SUBSTRING(TA003,5,2)+'-'+SUBSTRING(TA003,7,2) <= '#FORM.TA003_2#'</cfif>
    <cfif FORM.MB001 IS NOT ""> AND MB001 like '%#FORM.MB001#%'</cfif>
    <cfif FORM.MB002 IS NOT ""> AND MB001 like '%#FORM.MB001#%'</cfif>
	ORDER BY TA003 DESC,TA001,TA002
</cfquery>

<cfoutput>

<div style="height:80%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR bgcolor="666666" style="color:FFF">
	<TH>單別-單號</TH>
	<TH>報價日期</TH>
	<TH>客戶簡稱</TH>
	<TH>品號</TH>
	<TH>品名</TH>
	<TH>規格</TH>
	<TH>報價數量</TH>
	<cfif #價格權限# eq "Y">
	<TH>單價</TH>
	<TH>金額</TH>
	</cfif>
	<TH>確認碼</TH>    
	<TH>憑證</TH>    
</TR>

</thead>

<tbody>

<cfloop query="COPTB">

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	
 	<cfif TA019 EQ "Y"><cfset confirm="已確認"><cfelse><cfset confirm="未確認"></cfif>
	
    <tr bgcolor="#bgcolor#">
		<TD align="center">#TRIM(TA001)#-#TA002#</TD>
		<TD align="center">#MID(TA003,1,4)#-#MID(TA003,5,2)#-#MID(TA003,7,2)#</TD> 
		<TD align="center">#MA002#</TD> 
		<TD align="center">#MB001#</TD>
		<TD>#MB002#</TD> 
		<TD align="center">#MB003#</TD>
		<TD align="right">#NUMBERFORMAT(TB007,"9,999,999")#</TD>
		<cfif #價格權限# eq "Y">
		<TD align="right">#NUMBERFORMAT(TB009,"9,999,999.99")#</TD>
		<TD align="right">#NUMBERFORMAT(TB010,"99,999,999.99")#</TD>
		</cfif>
    	<TD align="center">#confirm#</TD>
    	<TD align="center"><a href="COPTB_PDF.cfm?TA001=#trim(TA001)#&TA002=#TA002#" target="_blank">憑證</a></TD>
	</tr>
</cfloop>

</tbody>

</table>

</div>

</cfoutput>
 
<cfinclude template="/EMG/footer.cfm">
