<!---108.6.16 新增，依廠商分類--->

<title>採購單查詢作業</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "PUR304" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">


<cfif NOT IsDefined("FORM.TC001")><cfset #FORM.TC001#=""></cfif>
<cfif NOT IsDefined("FORM.TC002")><cfset #FORM.TC002#=""></cfif>
<cfif NOT IsDefined("FORM.TC007")><cfset #FORM.TC007#=""></cfif>
<cfif NOT IsDefined("FORM.TC008")><cfset #FORM.TC008#=""></cfif>
<cfif NOT IsDefined("FORM.TC009")><cfset #FORM.TC009#=""></cfif>
<cfif NOT IsDefined("FORM.TC012")><cfset #FORM.TC012#=""></cfif>
<cfif NOT IsDefined("FORM.TC014")><cfset #FORM.TC014#=""></cfif>
<cfif NOT IsDefined("FORM.TC003_1")><cfset #FORM.TC003_1#=""></cfif>
<cfif NOT IsDefined("FORM.TC003_2")><cfset #FORM.TC003_2#=""></cfif>
<cfif NOT IsDefined("FORM.TD012_1")><cfset #FORM.TD012_1#=""></cfif>
<cfif NOT IsDefined("FORM.TD012_2")><cfset #FORM.TD012_2#=""></cfif>
<cfif NOT IsDefined("FORM.MA001")><cfset #FORM.MA001#=""></cfif>
<cfif NOT IsDefined("FORM.MA002")><cfset #FORM.MA002#=""></cfif>
<cfif NOT IsDefined("FORM.MB001")><cfset #FORM.MB001#=""></cfif> 
<cfif NOT IsDefined("FORM.MB002")><cfset #FORM.MB002#=""></cfif>
<cfif NOT IsDefined("FORM.TD016")><cfset #FORM.TD016#=""></cfif> 
<cfif NOT IsDefined("FORM.num")><cfset #FORM.num#="300"></cfif> 
<cfif NOT IsDefined("FORM.SUBMIT")><cfset #FORM.SUBMIT#=""></cfif> 

<h4><center>採購單查詢(依廠商分類) <center></h4>

<cfform action="PURTC.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
      
      <td>單別</td>
      <td><cfinput type="text"  name="TC001" size="4" maxlength="4" value=""></td>
 
      <td>單號</td>
      <td><cfinput type="text"  name="TC002" size="10" maxlength="12"></td>
          
	  <td>採購日期</td>
	  <td><input type="date" name="TC003_1" >～</td>
	  <td><input type="date" name="TC003_2" ></td>

	  <td>預交日</td>
	  <td><input type="date" name="TD012_1" >～</td>
	  <td><input type="date" name="TD012_2" ></td>

      <td>廠商簡稱</td>
      <td><cfinput type="text"  name="MA002" size="8" maxlength="20" ></td>
	  <td>品號</td><td><cfinput type="text" size="15" name="MB001"></td>
	  <td>品名</td><td><cfinput type="text" size="10" name="MB002"></td>
      <td>結案碼</td>
	  <td>
	      <select name="TD016">
		     <option value="">全部</option>
			 <option value="N">未結案</option>
			 <option value="Y">已結案</option>
			 <option value="y">指定結案</option>                         
	      </select></td>

	  <td>筆數</td><td><select name="num"><option value="500">500</option><option value="1000">1000</option><option value="2000">2000</option></select></td>

	  <td colspan="1" align="center"><input type="submit" value="查詢" name="submit"></td>
	  
	  </tr>
	</table>
	
</cfform>

<cfif #FORM.submit# neq "查詢">
    <cfabort>
</cfif>

<!---查詢廠商資料--->
<cfquery datasource="#SESSION.COMPANY#" name="PURMA">
    SELECT DISTINCT MA001,MA002
    FROM PURTD
	JOIN PURTC ON TC001=TD001 AND TC002=TD002
    JOIN PURMA ON TC004=MA001
	JOIN INVMB ON MB001=TD004
	WHERE 1=1 AND TC014  = 'Y'
	<cfif FORM.TC001 IS NOT ""> AND TC001 = '#FORM.TC001#'</cfif>
	<cfif FORM.TC002 IS NOT ""> AND TC002 = '#FORM.TC002#'</cfif>
    <cfif FORM.TC007 IS NOT ""> AND TC007 = '#FORM.TC007#'</cfif>
    <cfif FORM.TC008 IS NOT ""> AND TC008 = '#FORM.TC008#'</cfif>
    <cfif FORM.TC009 IS NOT ""> AND TC009 = '#FORM.TC009#'</cfif>
	<cfif FORM.TC012 IS NOT ""> AND TC012 = '#FORM.TC012#'</cfif>
	<cfif FORM.TC003_1 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) >= '#FORM.TC003_1#'</cfif>
	<cfif FORM.TC003_2 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) <= '#FORM.TC003_2#'</cfif>
	<cfif FORM.TD012_1 IS NOT ""> AND  SUBSTRING(TD012,1,4)+'-'+ SUBSTRING(TD012,5,2)+'-'+SUBSTRING(TD012,7,2) >= '#FORM.TD012_1#'</cfif>
	<cfif FORM.TD012_2 IS NOT ""> AND  SUBSTRING(TD012,1,4)+'-'+ SUBSTRING(TD012,5,2)+'-'+SUBSTRING(TD012,7,2) <= '#FORM.TD012_2#'</cfif>
	<cfif FORM.MA002 IS NOT ""> AND  MA002 like '%#FORM.MA002#%'</cfif>
    <cfif FORM.MB001 IS NOT ""> AND MB001 like '%#FORM.MB001#%'</cfif>
    <cfif FORM.MB002 IS NOT ""> AND MB002 like '%#FORM.MB002#%'</cfif>
    <cfif FORM.TD016 IS NOT ""> AND TD016 = '#FORM.TD016#'</cfif>
    ORDER BY MA001,MA002
</cfquery>

<br/>

<cfoutput>

<cflayout type="tab">
   <cfloop query="PURMA">
   
   <cflayoutarea title="#MA002#">

<!---查詢未詢採購單資料--->
<cfquery datasource="#SESSION.COMPANY#" name="PURTC">
    SELECT top #FORM.num# *
    FROM PURTD
	JOIN PURTC ON TC001=TD001 AND TC002=TD002
    JOIN PURMA ON TC004=MA001
	JOIN INVMB ON MB001=TD004
	WHERE 1=1 AND TC014  = 'Y'  AND MA001='#MA001#'
	<cfif FORM.TC001 IS NOT ""> AND TC001 = '#FORM.TC001#'</cfif>
	<cfif FORM.TC002 IS NOT ""> AND TC002 = '#FORM.TC002#'</cfif>
    <cfif FORM.TC007 IS NOT ""> AND TC007 = '#FORM.TC007#'</cfif>
    <cfif FORM.TC008 IS NOT ""> AND TC008 = '#FORM.TC008#'</cfif>
    <cfif FORM.TC009 IS NOT ""> AND TC009 = '#FORM.TC009#'</cfif>
	<cfif FORM.TC012 IS NOT ""> AND TC012 = '#FORM.TC012#'</cfif>
	<cfif FORM.TC003_1 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) >= '#FORM.TC003_1#'</cfif>
	<cfif FORM.TC003_2 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) <= '#FORM.TC003_2#'</cfif>
	<cfif FORM.TD012_1 IS NOT ""> AND  SUBSTRING(TD012,1,4)+'-'+ SUBSTRING(TD012,5,2)+'-'+SUBSTRING(TD012,7,2) >= '#FORM.TD012_1#'</cfif>
	<cfif FORM.TD012_2 IS NOT ""> AND  SUBSTRING(TD012,1,4)+'-'+ SUBSTRING(TD012,5,2)+'-'+SUBSTRING(TD012,7,2) <= '#FORM.TD012_2#'</cfif>
	<cfif FORM.MA002 IS NOT ""> AND  MA002 like '%#FORM.MA002#%'</cfif>
    <cfif FORM.MB001 IS NOT ""> AND MB001 like '%#FORM.MB001#%'</cfif>
    <cfif FORM.MB002 IS NOT ""> AND MB002 like '%#FORM.MB002#%'</cfif>
    <cfif FORM.TD016 IS NOT ""> AND TD016 = '#FORM.TD016#'</cfif>
    ORDER BY TC003 DESC,TC001,TC002
</cfquery>

<table border="1" align="center">

<TR bgcolor="666666" style="color:FFF">
   <TH>單別-單號</TH>
   <TH>採購日期</TH>
   <TH>預計交貨日</TH>
   <TH>廠商簡稱</TH>
   <TH>品號</TH>
   <TH>品名/規格</TH>  
   <TH>採購數量</TH>
   <TH>已交數量</TH>
   <TH>未交數量</TH>
   <TH>單位</TH>
   <TH>結案</TH>
   <TH>進貨明細</TH>
</TR>

<cfset SUMTD008=0>
<cfset SUMTD015=0>
<cfset SUMTD008_2=0>
<cfset SUMTD015_2=0>

<cfloop query="PURTC">

<!---查詢未詢採購單資料--->
<cfquery datasource="#SESSION.COMPANY#" name="PURTH">
    SELECT *
    FROM PURTH
	JOIN PURTG ON TG001=TH001 AND TG002=TH002
	WHERE 1=1 AND TG013 <> 'V'
	   AND TH011='#TD001#' AND TH012='#TD002#' AND TH013='#TD003#'
     
</cfquery>

	<cfset SUMTD008 = SUMTD008 + TD008>
	<cfset SUMTD015 = SUMTD015 + TD015>
	
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<cfif #Dateformat(now(),"yyyymmdd")# gt #TD012# AND #TD016# EQ "N"><cfset bgcolor2="FFCCFF"><cfelse><cfset bgcolor2=bgcolor></cfif>

	<tr bgcolor="#bgcolor#" >
		<TD align="center">#TRIM(TC001)#-#TRIM(TC002)#</TD> 
		<TD align="center">#MID(TC003,1,4)#-#MID(TC003,5,2)#-#MID(TC003,7,2)#</TD>
        <TD align="center" bgcolor="#bgcolor2#">#MID(TD012,1,4)#-#MID(TD012,5,2)#-#MID(TD012,7,2)#</TD>
		<TD align="center">#MA002#</TD>
		<td align="center" >#TD004#</td>
		<td >#TD005#<BR/>#TD006#</td>
		<TD align="right" width="60">#NUMBERFORMAT(TD008,"9,999,999")#</TD>
        <TD align="right" width="60">#NUMBERFORMAT(TD015,"9,999,999")#</TD>
        <TD align="right" width="60">#NUMBERFORMAT(TD008-TD015,"9,999,999")#</TD>
		<TD align="center">#TD009#</TD>
        <TD align="center"><cfif #TD016# EQ "Y">V</cfif></TD>
		<TD align="center"><cfloop query="PURTH">#MID(TG003,1,4)#/#MID(TG003,5,2)#/#MID(TG003,7,2)#(#NUMBERFORMAT(TH015,"9,999,999")#)<BR/></cfloop></TD>
	</tr>

</cfloop>

	<tr bgcolor="666666">
		<TD></TD> 
		<TD></TD> 
		<TD></TD> 
		<TD></TD> 
		<TD></TD> 
		<TD align="center" style="color:FFF">小計</TD> 
		<TD align="right" style="color:FFF"width="60">#NUMBERFORMAT(SUMTD008,"9,999,999")#</TD>
		<TD align="right" style="color:FFF" width="60">#NUMBERFORMAT(SUMTD015,"9,999,999")#</TD>
		<TD align="right" style="color:FFF" width="60">#NUMBERFORMAT(SUMTD008-SUMTD015,"9,999,999")#</TD>
		<TD></TD> 
		<TD></TD> 
		<TD></TD> 
	</tr>

</table>

</cflayoutarea>

</cfloop>

</cflayout>
</cfoutput>

<cfinclude template="/EMG/footer.cfm">
