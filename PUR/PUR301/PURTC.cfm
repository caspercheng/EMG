<title>採購單查詢</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "PUR301" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.TC001")><cfset #FORM.TC001#=""></cfif>
<cfif NOT IsDefined("FORM.TC002")><cfset #FORM.TC002#=""></cfif>
<cfif NOT IsDefined("FORM.TC014")><cfset #FORM.TC014#=""></cfif>
<cfif NOT IsDefined("FORM.TC003_1")><cfset #FORM.TC003_1#=""></cfif>
<cfif NOT IsDefined("FORM.TC003_2")><cfset #FORM.TC003_2#=""></cfif>
<cfif NOT IsDefined("FORM.TD012_1")><cfset #FORM.TD012_1#=""></cfif>
<cfif NOT IsDefined("FORM.TD012_2")><cfset #FORM.TD012_2#=""></cfif>
<cfif NOT IsDefined("FORM.MA002")><cfset #FORM.MA002#=""></cfif>
<cfif NOT IsDefined("FORM.MB001")><cfset #FORM.MB001#=""></cfif>
<cfif NOT IsDefined("FORM.MB002")><cfset #FORM.MB002#=""></cfif>
<cfif NOT IsDefined("FORM.TD014")><cfset #FORM.TD014#=""></cfif> 
<cfif NOT IsDefined("FORM.TD022")><cfset #FORM.TD022#=""></cfif> 
<cfif NOT IsDefined("FORM.TD016")><cfset #FORM.TD016#=""></cfif> 
<cfif NOT IsDefined("FORM.num")><cfset #FORM.num#="300"></cfif> 

<h4><center>採購單查詢<center></h4>

<cfform action="PURTC.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
      
      <td>單別</td>
      <td><cfinput type="text"  name="TC001" size="4" maxlength="4" value=""></td>
 
      <td>單號</td>
      <td><cfinput type="text"  name="TC002" size="10" maxlength="15"></td>
          
	  <td>採購日期</td>
	  <td><input type="date" name="TC003_1" >～</td>
	  <td><input type="date" name="TC003_2" ></td>
	  <td>品號</td><td><cfinput type="text" size="10" name="MB001"></td>
	  <td>品名</td><td><cfinput type="text" size="10" name="MB002"></td>

      <td>廠商簡稱</td>
      <td><cfinput type="text"  name="MA002" size="10" maxlength="20" ></td>
	  </tr>
	  <tr>
	  <td>備註</td><td><cfinput type="text" size="15" name="TD014"></td>
	  <td>專案代號</td><td><cfinput type="text" size="15" name="TD022"></td>
	  <td>預交日</td>
	  <td><input type="date" name="TD012_1" >～</td>
	  <td><input type="date" name="TD012_2" ></td>
      <td>結案碼</td>
	  <td>
	      <select name="TD016">
		     <option value="">全部</option>
			 <option value="N">未結案</option>
			 <option value="Y">已結案</option>
			 <option value="y">指定結案</option>                         
	      </select></td>
      <td>確認碼</td>
	  <td>
	      <select name="TC014">
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
<cfquery datasource="#SESSION.COMPANY#" name="PURTC">
    SELECT top #FORM.num# *
    FROM PURTD
	JOIN PURTC ON TC001=TD001 AND TC002=TD002
    JOIN PURMA ON TC004=MA001
	JOIN INVMB ON MB001=TD004
	LEFT JOIN PURTB ON TD026=TB001 AND TD027=TB002 AND TD028=TB003
	WHERE 1=1 AND TC014  <> 'V'
	<cfif FORM.TC001 IS NOT ""> AND TC001 = '#FORM.TC001#'</cfif>
	<cfif FORM.TC002 IS NOT ""> AND TC002 = '#FORM.TC002#'</cfif>
    <cfif FORM.TC014 IS NOT ""> AND TC014 = '#FORM.TC014#'</cfif>
	<cfif FORM.TC003_1 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) >= '#FORM.TC003_1#'</cfif>
	<cfif FORM.TC003_2 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) <= '#FORM.TC003_2#'</cfif>
	<cfif FORM.TD012_1 IS NOT ""> AND  SUBSTRING(TD012,1,4)+'-'+ SUBSTRING(TD012,5,2)+'-'+SUBSTRING(TD012,7,2) >= '#FORM.TD012_1#'</cfif>
	<cfif FORM.TD012_2 IS NOT ""> AND  SUBSTRING(TD012,1,4)+'-'+ SUBSTRING(TD012,5,2)+'-'+SUBSTRING(TD012,7,2) <= '#FORM.TD012_2#'</cfif>
	<cfif FORM.MA002 IS NOT ""> AND  MA002 like '%#FORM.MA002#%'</cfif>
    <cfif FORM.MB001 IS NOT ""> AND MB001 like '#FORM.MB001#%'</cfif>
    <cfif FORM.MB002 IS NOT ""> AND MB002 like '%#FORM.MB002#%'</cfif>
    <cfif FORM.TD014 IS NOT ""> AND TD014 like '%#FORM.TD014#%'</cfif>
    <cfif FORM.TD022 IS NOT ""> AND TD022 like '%#FORM.TD022#%'</cfif>
    <cfif FORM.TD016 IS NOT ""> AND TD016 = '#FORM.TD016#'</cfif>
    ORDER BY TC003 DESC,TC001,TC002
</cfquery>

<cfoutput>


<div style="height:85%">
<table id="myTable01" class="fancyTable">
<thead>

<TR bgcolor="666666" style="color:FFF">
   <TH>單別-單號<BR/>採購日期</TH>
   <TH>預計交貨日</TH>
   <TH>廠商簡稱</TH>
   <TH>品號</TH>
   <TH>品名/規格</TH>  
   <TH>採購數量<br/>已交數量<br/>未交數量</TH>
   <cfif #價格權限# eq "Y">
   <TH>單價</TH>
   <TH>金額</TH>
   </cfif>
   <TH>單位</TH>
   <TH>備註／專案代號</TH>
   <TH>進貨明細</TH>
   <TH>退貨明細</TH>
</TR>

</thead>

<tbody>

<cfset SUMTD008=0>
<cfset SUMTD015=0>
<cfset SUMTD008_2=0>
<cfset SUMTD015_2=0>

<cfloop query="PURTC">

<!---查詢未詢採購單資料
<cfquery datasource="#SESSION.COMPANY#" name="PURTH">
    SELECT *
	FROM (
    SELECT TG003,TH015
    FROM PURTH
	JOIN PURTG ON TG001=TH001 AND TG002=TH002
	WHERE 1=1 AND TG013 <> 'V'
	   AND TH011='#TD001#' AND TH012='#TD002#' AND TH013='#TD003#'
 
   UNION ALL
   
    SELECT TI003 AS TG003,TJ009*-1  AS TH015
    FROM PURTJ
	JOIN PURTI ON TI001=TJ001 AND TI002=TJ002
	WHERE 1=1 AND TJ020 <> 'V'
	   AND TJ016='#TD001#' AND TJ017='#TD002#' AND TJ018='#TD003#'
	   ) AS PURTH
	  WHERE TH015 <> 0
	   ORDER BY  TG003,TH015 DESC
</cfquery>
--->
<cfquery datasource="#SESSION.COMPANY#" name="PURTH">
    SELECT TG003,TH015
    FROM PURTH
	JOIN PURTG ON TG001=TH001 AND TG002=TH002
	WHERE 1=1 AND TG013 <> 'V'
	   AND TH011='#TD001#' AND TH012='#TD002#' AND TH013='#TD003#'
	   AND TH015 <> 0
	   ORDER BY  TG003,TH015 DESC
</cfquery>

<cfquery datasource="#SESSION.COMPANY#" name="PURTJ">
    SELECT TI003,TJ009*-1  AS TJ009
    FROM PURTJ
	JOIN PURTI ON TI001=TJ001 AND TI002=TJ002
	WHERE 1=1 AND TJ020 <> 'V'
	   AND TJ016='#TD001#' AND TJ017='#TD002#' AND TJ018='#TD003#'
	   AND TJ009 <> 0
	   ORDER BY  TJ003
</cfquery>


	<cfset SUMTD008 = SUMTD008 + TD008>
	<cfset SUMTD015 = SUMTD015 + TD015>
	
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	
	<tr bgcolor="#bgcolor#" >
		<TD align="center">#TRIM(TC001)#-#TRIM(TC002)#<BR/>#MID(TC003,1,4)#-#MID(TC003,5,2)#-#MID(TC003,7,2)#
		<cfif TC014 EQ "N"><span class="badge badge-warning">未確認</span></cfif>
		<cfif #TD016# EQ "Y" AND #TD015# GTE #TD008#>
		    <br/><span class="badge badge-success">已結案</span>
		<cfelseif #TD016# EQ "y">
		     <br/><span class="badge badge-secondary">指定結案</span>
	    </cfif>
		</TD> 
        <TD align="center" >
		    #MID(TD012,1,4)#-#MID(TD012,5,2)#-#MID(TD012,7,2)#
		    <cfif #Dateformat(now(),"yyyymmdd")# gt #TD012# AND #TD016# EQ "N"><br/><span class="badge badge-danger">逾期未進貨</span></cfif>
		</TD>
		<TD align="center">#MA002#</TD>
		<td align="center" >#TD004#</td>
		<td width="300">#TD005#<BR/>#TD006#</td>
		<TD align="right" width="80">#NUMBERFORMAT(TD008,"9,999,999")#<BR/>#NUMBERFORMAT(TD015,"9,999,999")#<BR/>#NUMBERFORMAT(TD008-TD015,"9,999,999")#</TD>
		<cfif #價格權限# eq "Y">
        <TD align="right" width="60">#NUMBERFORMAT(TD010,"9,999,999.99")#</TD>
        <TD align="right" width="60">#NUMBERFORMAT(TD011,"99,999,999")#</TD>
		</cfif>
		<TD align="center">#TD009#</TD>
		<TD width="400">#TD014#<br/>#TD022#</TD>
		<TD align="center">
		   <cfloop query="PURTH">#MID(TG003,1,4)#/#MID(TG003,5,2)#/#MID(TG003,7,2)#(#NUMBERFORMAT(TH015,"9,999,999")#)<BR/></cfloop>
		</TD>
		<TD align="center">
		   <cfloop query="PURTJ">#MID(TI003,1,4)#/#MID(TI003,5,2)#/#MID(TI003,7,2)#(#NUMBERFORMAT(TJ009,"9,999,999")#)<BR/></cfloop>
		</TD>


	</tr>

</cfloop>

</tbody>
</table>
</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">
