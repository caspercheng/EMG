<title>退貨單查詢作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "PUR305" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.TI001")><cfset #FORM.TI001#=""></cfif>
<cfif NOT IsDefined("FORM.TI002")><cfset #FORM.TI002#=""></cfif>
<cfif NOT IsDefined("FORM.TI003_1")><cfset #FORM.TI003_1#=""></cfif>
<cfif NOT IsDefined("FORM.TI003_2")><cfset #FORM.TI003_2#=""></cfif>
<cfif NOT IsDefined("FORM.MA001")><cfset #FORM.MA001#=""></cfif>
<cfif NOT IsDefined("FORM.MA002")><cfset #FORM.MA002#=""></cfif>
<cfif NOT IsDefined("FORM.MB001")><cfset #FORM.MB001#=""></cfif> 
<cfif NOT IsDefined("FORM.MB002")><cfset #FORM.MB002#=""></cfif> 
<cfif NOT IsDefined("FORM.TJ012")><cfset #FORM.TJ012#=""></cfif> 
<cfif NOT IsDefined("FORM.TJ016")><cfset #FORM.TJ016#=""></cfif> 
<cfif NOT IsDefined("FORM.TJ017")><cfset #FORM.TJ017#=""></cfif> 
<cfif NOT IsDefined("FORM.TJ020")><cfset #FORM.TJ020#=""></cfif> 
<cfif NOT IsDefined("FORM.num")><cfset #FORM.num#="500"></cfif> 

<!---查詢廠商資料--->
<cfquery datasource="#SESSION.COMPANY#" name="PURMA">
    SELECT DISTINCT MA002
    FROM PURMA
	WHERE 1=1 
</cfquery>

<cfset list1=ValueList(PURMA.MA002)>

<h4><center>退貨單查詢 <center></h4>

<cfform action="PURTJ.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
      
      <td>單別</td>
      <td><cfinput type="text"  name="TI001" size="4"  maxlength="4" value=""></td>
 
      <td>單號</td>
      <td><cfinput type="text"  name="TI002" size="8" maxlength="12"></td>
          
	  <td>退貨日期</td>
	  <td><input type="date" name="TI003_1" >～</td>
	  <td><input type="date" name="TI003_2" ></td>

      <td>廠商簡稱</td>
      <td><cfinput type="text"  name="MA002" size="8" maxlength="20" autosuggest="#list1#" maxresultsdisplayed="30"></td>

	  <td>品號</td><td><cfinput type="text" size="15" name="MB001"></td>
	  <td>品名</td><td><cfinput type="text" size="10" name="MB002"></td>
	
	  <td>採購單別</td>
      <td><cfinput type="text"  name="TJ016" size="4"  maxlength="4" value=""></td>
 
      <td>單號</td>
      <td><cfinput type="text"  name="TJ017" size="10" maxlength="12"></td>
      <td>確認碼</td>
	  <td>
	      <select name="TJ020">
		     <option value="">全部</option>
			 <option value="N">未確認</option>
			 <option value="Y">已確認</option>
	      </select>
	  </td>

	  <td>筆數</td><td><select name="num"><option value="500">500</option><option value="1000">1000</option><option value="2000">2000</option></select></td>
  
	  <td colspan="1" align="center"><input type="submit" value="查詢" name="submit"></td>
	  
	  </tr>
	</table>
	
</cfform>

<!---查詢未詢採購單資料--->
<cfquery datasource="#SESSION.COMPANY#" name="PURTJ">
    SELECT top #FORM.num# *
    FROM PURTJ
	JOIN PURTI ON TJ001=TI001 AND TJ002=TI002
    JOIN PURMA ON TI004=MA001
	JOIN CMSMC ON MC001=TJ011
	JOIN INVMB ON MB001=TJ004
	WHERE 1=1  AND TJ020<> 'V'
	<cfif FORM.TI001 IS NOT ""> AND TI001 = '#FORM.TI001#'</cfif>
	<cfif FORM.TI002 IS NOT ""> AND TI002 = '#FORM.TI002#'</cfif>
	<cfif FORM.TI003_1 IS NOT ""> AND  SUBSTRING(TI003,1,4)+'-'+ SUBSTRING(TI003,5,2)+'-'+SUBSTRING(TI003,7,2) >= '#FORM.TI003_1#'</cfif>
	<cfif FORM.TI003_2 IS NOT ""> AND  SUBSTRING(TI003,1,4)+'-'+ SUBSTRING(TI003,5,2)+'-'+SUBSTRING(TI003,7,2) <= '#FORM.TI003_2#'</cfif>
	<cfif FORM.MA002 IS NOT ""> AND  MA002 like '#FORM.MA002#%'</cfif>
    <cfif FORM.MB001 IS NOT ""> AND  MB001 like '%#FORM.MB001#%' </cfif>
    <cfif FORM.MB002 IS NOT ""> AND  MB002 like '%#FORM.MB002#%' </cfif>
    <cfif FORM.TJ012 IS NOT ""> AND  TJ012 = '#FORM.TJ012#' </cfif>
	<cfif FORM.TJ016 IS NOT ""> AND TJ016 = '#FORM.TJ016#'</cfif>
	<cfif FORM.TJ017 IS NOT ""> AND TJ017 = '#FORM.TJ017#'</cfif>
	<cfif FORM.TJ020 IS NOT ""> AND TJ020 = '#FORM.TJ020#'</cfif>
    ORDER BY TI003 DESC,TI001,TI002
	
</cfquery>

<!---查詢計數歸零--->
<cfset current_row=0>

<cfoutput>

<div style="height:80%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR bgcolor="666666" style="color:FFF">
    <TH>退貨單別-單號<br/>採購單別-單號</TH>
    <TH>退貨日期</TH>
    <TH>廠商簡稱</TH>
	<TH>品號</TH>
	<TH>品名<br/>規格</TH>
	<TH>退貨數量</TH>
	<TH>單位</TH>
	<TH>應付憑單</TH>
	<TH>備註</TH>
</TR>

</thead>

<tbody>

<cfset SUMTJ009=0>

<cfloop query="PURTJ">

<cfset SUMTJ009 = SUMTJ009 + TJ009>

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	
	<tr bgcolor="#bgcolor#">
		<TD align="center">#TRIM(TI001)#-#TRIM(TI002)#</br>#TJ016#-#TJ017#-#TJ018#<cfif TJ020 EQ "N"><span class="badge badge-warning">未確認</span></cfif></TD> 
		<TD align="center">#MID(TI003,1,4)#-#MID(TI003,5,2)#-#MID(TI003,7,2)#</TD>
		<TD align="center">#MA002#</TD>
		<TD align="center" >#TJ004#</TD>
		<TD>#TJ005#<b/>#TJ006#</TD>
		<TD align="right" width="60">#NUMBERFORMAT(TJ009,"9,999,999")#</TD>
		<TD align="center">#TJ007#</TD>
		<TD align="center">#TJ025#-#TJ026#-#TJ027#</TD>
		<TD width="250">#TJ019#</TD>
	</tr>


</cfloop>

	<TR bgcolor="666666">
		<TD></TD> 
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD align="center" style="color:FFF">小計</TD>
		<TD align="right" style="color:FFF" width="60">#NUMBERFORMAT(SUMTJ009,"9,999,999")#</TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
	</TR>


</tbody>

</table>

</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">
