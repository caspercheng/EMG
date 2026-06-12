<title>進貨單查詢</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "PUR302" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.TG001")><cfset #FORM.TG001#=""></cfif>
<cfif NOT IsDefined("FORM.TG002")><cfset #FORM.TG002#=""></cfif>
<cfif NOT IsDefined("FORM.TG003_1")><cfset #FORM.TG003_1#=""></cfif>
<cfif NOT IsDefined("FORM.TG003_2")><cfset #FORM.TG003_2#=""></cfif>
<cfif NOT IsDefined("FORM.MA001")><cfset #FORM.MA001#=""></cfif>
<cfif NOT IsDefined("FORM.MA002")><cfset #FORM.MA002#=""></cfif>
<cfif NOT IsDefined("FORM.MB001")><cfset #FORM.MB001#=""></cfif> 
<cfif NOT IsDefined("FORM.MB002")><cfset #FORM.MB002#=""></cfif> 
<cfif NOT IsDefined("FORM.TH010")><cfset #FORM.TH010#=""></cfif> 
<cfif NOT IsDefined("FORM.TH011")><cfset #FORM.TH011#=""></cfif> 
<cfif NOT IsDefined("FORM.TH012")><cfset #FORM.TH012#=""></cfif> 
<cfif NOT IsDefined("FORM.TH030")><cfset #FORM.TH030#=""></cfif> 
<cfif NOT IsDefined("FORM.num")><cfset #FORM.num#="500"></cfif> 

<h4><center>進貨單查詢<center></h4>

<cfform action="PURTH.cfm" method="post">

	<table align="center" >
	 <tr>
      
      <td>單別</td>
      <td><cfinput type="text"  name="TG001" size="4" maxlength="4" value=""></td>
 
      <td>單號</td>
      <td><cfinput type="text"  name="TG002" size="10" maxlength="12"></td>
          
	  <td>進貨日期</td>
	  <td><input type="date" name="TG003_1" >～</td>
	  <td><input type="date" name="TG003_2" ></td>

      <td>廠商簡稱</td>
      <td><cfinput type="text"  name="MA002" size="8" maxlength="20" ></td>
	  <td>品號</td><td><cfinput type="text" size="15" name="MB001"></td>
	  <td>品名</td><td><cfinput type="text" size="10" name="MB002"></td>
	  <td>採購單別</td>
      <td><cfinput type="text"  name="TH011" size="4" maxlength="4" value=""></td>
      <td>單號</td>
      <td><cfinput type="text"  name="TH012" size="10" maxlength="12"></td>
      <td>確認碼</td>
	  <td>
	      <select name="TH030">
		     <option value="">全部</option>
			 <option value="N">未確認</option>
			 <option value="Y">已確認</option>
	      </select></td>

	  <td>筆數</td><td><select name="num"><option value="500">500</option><option value="1000">1000</option><option value="2000">2000</option></select></td>
  
	  <td colspan="1" align="center"><input type="submit" value="查詢" name="submit"></td>
	  
	  </tr>
	</table>
	
</cfform>


<!---查詢未詢採購單資料--->
<cfquery datasource="#SESSION.COMPANY#" name="PURTH">
    SELECT top #FORM.num# TG001,TG002,TG003,TH011,TH012,TH013,TG013,MA002,TH004,TH005,TH006,TH007,TH018,TH019,TH008,TH039,TH040,TH041,MC002,MV002
	
    FROM PURTH
	JOIN PURTG ON TH001=TG001 AND TH002=TG002
    JOIN PURMA ON TG005=MA001
	JOIN CMSMC ON MC001=TH009
	JOIN INVMB ON MB001=TH004
	LEFT JOIN CMSMV ON MV001=PURTH.CREATOR
	WHERE 1=1  AND TG013 <> 'V'
	<cfif FORM.TG001 IS NOT ""> AND TG001 = '#FORM.TG001#'</cfif>
	<cfif FORM.TG002 IS NOT ""> AND TG002 = '#FORM.TG002#'</cfif>
	<cfif FORM.TG003_1 IS NOT ""> AND  SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) >= '#FORM.TG003_1#'</cfif>
	<cfif FORM.TG003_2 IS NOT ""> AND  SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) <= '#FORM.TG003_2#'</cfif>
	<cfif FORM.MA002 IS NOT ""> AND  MA002 like '#FORM.MA002#%'</cfif>
    <cfif FORM.MB001 IS NOT ""> AND  MB001 like '%#FORM.MB001#%' </cfif>
    <cfif FORM.MB002 IS NOT ""> AND  MB002 like '%#FORM.MB002#%' </cfif>
    <cfif FORM.TH010 IS NOT ""> AND  TH010 like '#FORM.TH010#%' </cfif>
	<cfif FORM.TH011 IS NOT ""> AND TH011 = '#FORM.TH011#'</cfif>
	<cfif FORM.TH012 IS NOT ""> AND TH012 = '#FORM.TH012#'</cfif>
	<cfif FORM.TH030 IS NOT ""> AND TH030 = '#FORM.TH030#'</cfif>
    ORDER BY TG003 DESC,TG001,TG002
	
</cfquery>

<cfoutput>


<div style="height:80%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR bgcolor="666666" style="color:FFF">
    <TH>進貨單別-單號<br/>採購單別-單號</TH>
    <TH>進貨日期</TH>
    <TH>廠商簡稱</TH>
	<TH>品號</TH>
	<TH>品名<BR/>規格</TH>
	<TH>進貨數量</TH>
   <cfif #價格權限# eq "Y">
   <TH>單價</TH>
   <TH>金額</TH>
   </cfif>
	<TH>單位</TH>
	<TH>應付憑單</TH>
	<TH>庫別</TH>
</TR>

</thead>

<tbody>

<cfset SUMTH007=0>
<cfset SUMTH007_2=0>

<cfloop query="PURTH">

<cfset SUMTH007 = SUMTH007 + TH007>

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	
	<tr bgcolor="#bgcolor#">
		<TD align="center">#TRIM(TG001)#-#TRIM(TG002)#<br/>#TH011#-#TH012#-#TH013#<cfif TG013 EQ "N"><br/><span class="badge badge-warning">未確認</span></cfif></TD> 
		<TD align="center">#MID(TG003,1,4)#-#MID(TG003,5,2)#-#MID(TG003,7,2)#</TD>
		<TD align="center">#MA002#</TD>
		<TD align="center" >#TH004#</TD>
		<TD>#TH005#<BR/>#TH006#</TD>
		<TD align="right" width="80">#NUMBERFORMAT(TH007,"9,999,999")#</TD>
		<cfif #價格權限# eq "Y">
        <TD align="right">#NUMBERFORMAT(TH018,"9,999,999.99")#</TD>
        <TD align="right">#NUMBERFORMAT(TH019,"99,999,999")#</TD>
		</cfif>
		<TD align="center">#TH008#</TD>
		<TD>#TH039#-#TH040#-#TH041#</TD>
		<TD align="center">#MC002#</TD>
	</tr>


</cfloop>

	<TR bgcolor="666666">
		<TD></TD> 
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD align="center" style="color:FFF">小計</TD>
		<TD align="right" style="color:FFF" width="60">#NUMBERFORMAT(SUMTH007,"9,999,999")#</TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
	</TR>
</tbody>

</table>

</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">
