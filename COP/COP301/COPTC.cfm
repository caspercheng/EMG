<title>客戶訂單查詢</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "COP301" >
<cfset program_name = "客戶訂單查詢" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif NOT IsDefined("FORM.TC001")><cfset #FORM.TC001#=""></cfif> 
<cfif NOT IsDefined("FORM.TC002")><cfset #FORM.TC002#=""></cfif> 
<cfif NOT IsDefined("FORM.MA002")><cfset #FORM.MA002#=""></cfif> 
<cfif NOT IsDefined("FORM.TC003_1")><cfset #FORM.TC003_1#=""></cfif>
<cfif NOT IsDefined("FORM.TC003_2")><cfset #FORM.TC003_2#=""></cfif>
<cfif NOT IsDefined("FORM.TD013_1")><cfset #FORM.TD013_1#=""></cfif>
<cfif NOT IsDefined("FORM.TD013_2")><cfset #FORM.TD013_2#=""></cfif>
<cfif NOT IsDefined("FORM.TC012")><cfset #FORM.TC012#=""></cfif>
<cfif NOT IsDefined("FORM.TD004")><cfset #FORM.TD004#=""></cfif>
<cfif NOT IsDefined("FORM.TD016")><cfset #FORM.TD016#=""></cfif>  
<cfif NOT IsDefined("FORM.TD021")><cfset #FORM.TD021#=""></cfif>  

<cfoutput>

<h4 align="center">客戶訂單查詢 </h4>

<!---使用者查詢條件--->
<cfform action="COPTC.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>
		 
	  <td>單別</td><td><cfinput type="text" size="4" name="TC001" maxlength="4" value=""></td>
	  <td>單號</td><td><cfinput type="text" size="12" name="TC002" maxlength="12"></td>
	  <td>訂單日</td>
	  <td><input type="date" name="TC003_1" size=8>～</td>
	  <td><input type="date" name="TC003_2" size=8></td>
	  <td>預交日</td>
	  <td><input type="date" name="TD013_1" size=8 >～</td>
	  <td><input type="date" name="TD013_2" size=8 ></td>
	  <td>客戶簡稱</td><td><cfinput type="text" size="6" name="MA002"></td>
	  <td>客戶單號</td><td><cfinput type="text" size="8" name="TC012"></td>
	  <td>品號</td><td><cfinput type="text" size="10" name="TD004"></td>
      <td>確認碼</td>
	  <td>
	      <select name="TD021">
		     <option value="">全部</option>
			 <option value="N">未確認</option>
			 <option value="Y">已確認</option>
	      </select>
	  </td>
      <td>結案碼</td>
	  <td>
	      <select name="TD016">
		     <option value="">全部</option>
			 <option value="N">未結案</option>
			 <option value="Y">已結案</option>
             <option value="y">指定結案</option>                         
	      </select>
	  </td>
	  <td  align="center"><input type="submit" name="submit" value="查詢"></td>
	  </tr>
	</table>

</cfform>

<cfquery datasource="#SESSION.COMPANY#" name="COPTC">
    SELECT  * 
    FROM COPTD
	JOIN COPTC ON TC001=TD001 AND TC002=TD002
	JOIN INVMB ON MB001=TD004
	JOIN COPMA ON MA001=TC004
	LEFT JOIN MEMPC ON PC001=TC012
	WHERE 1=1 AND TD008 > 0 AND TC027 <> 'V'
    <cfif FORM.TC001 IS NOT ""> AND TC001 = '#FORM.TC001#'</cfif>
    <cfif FORM.TC002 IS NOT ""> AND TC002 like '#FORM.TC002#%'</cfif>
    <cfif FORM.MA002 IS NOT ""> AND MA002 like '%#FORM.MA002#%'</cfif>
	<cfif FORM.TC003_1 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) >= '#FORM.TC003_1#'</cfif>
	<cfif FORM.TC003_2 IS NOT ""> AND  SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) <= '#FORM.TC003_2#'</cfif>
	
	
	<cfif FORM.TD013_1 IS NOT ""> AND  SUBSTRING(TD013,1,4)+'-'+ SUBSTRING(TD013,5,2)+'-'+SUBSTRING(TD013,7,2) >= '#FORM.TD013_1#'</cfif>
	<cfif FORM.TD013_2 IS NOT ""> AND  SUBSTRING(TD013,1,4)+'-'+ SUBSTRING(TD013,5,2)+'-'+SUBSTRING(TD013,7,2) <= '#FORM.TD013_2#'</cfif>
    <cfif FORM.TC012 IS NOT ""> AND TC012 like '#FORM.TC012#%'</cfif>
    <cfif FORM.TD004 IS NOT ""> AND TD004 like '%#FORM.TD004#%'</cfif>
    <cfif FORM.TD016 IS NOT ""> AND TD016 = '#FORM.TD016#'</cfif>
    <cfif FORM.TD021 IS NOT ""> AND TD021 = '#FORM.TD021#'</cfif>
	ORDER BY TC003 DESC,TC001,TC002
</cfquery>

<div>
	<a href="COPTC_EXCEL.cfm?TC001=#FORM.TC001#&TC002=#FORM.TC002#&MA002=#FORM.MA002#&TC003_1=#FORM.TC003_1#&TC003_2=#FORM.TC003_2#&TD013_1=#FORM.TD013_1#&TD013_2=#FORM.TD013_2#&TC012=#FORM.TC012#&TD004=#FORM.TD004#&TD016=#FORM.TD016#" class="btn btn-success m-1">產生EXCEL</a>
</div>


<div style="height:85%">
<table id="myTable01" class="fancyTable" >
<thead>

<TR bgcolor="666666" style="color:FFF">
	<TH>單別-單號</TH>
    <TH>訂單日期</TH>
    <TH>預交日期</TH>
	<TH>客戶簡稱</TH>
	<TH>會員</TH>
	<TH>品號</TH>
	<TH>品名/規格</TH>
	<TH>訂單數量</TH>
	<TH>未交數量</TH>
	<cfif #價格權限# eq "Y">
	<TH>單價</TH>
	<TH>金額</TH>
	</cfif>
   <TH>出貨明細</TH>
</TR>

</thead>
<tbody>

<cfset totalqty =0>
<cfset totalmoney =0>

<cfloop query="COPTC">

<cfset totalqty =totalqty + #TD008#>
<cfset totalmoney =totalmoney+#TD012#>


<cfquery datasource="#SESSION.COMPANY#" name="COPTH">
    SELECT TG003,TH008
    FROM COPTH
	JOIN COPTG ON TG001=TH001 AND TG002=TH002
	WHERE 1=1 AND TG023 <> 'V'
	   AND TH014='#TD001#' AND TH015='#TD002#' AND TH016='#TD003#'
	   AND TH008 <> 0
	   ORDER BY  TG003,TH008 DESC
</cfquery>

<!---<cfquery datasource="#SESSION.COMPANY#" name="COPTJ">
    SELECT TJ001,TJ002,TI003,TJ007*-1  AS TJ007
    FROM COPTJ
	JOIN COPTI ON TI001=TJ001 AND TI002=TJ002
	WHERE 1=1 AND TJ021 <> 'V'
	   AND TJ018='#TD001#' AND TJ019='#TD002#' AND TJ020='#TD003#'
	   AND TJ007 <> 0
	   ORDER BY  TJ003
</cfquery>
--->
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>

    <tr bgcolor="#bgcolor#">
		<TD align="center" width="80">
		   #TRIM(TC001)#-#TC002#
		  <cfif #Asc(TD016)# eq "78"><br/><span class="badge badge-pill badge-secondary">未結案</span>
		  <cfelseif #Asc(TD016)# eq "89"><br/><span class="badge badge-pill badge-success">已結案</span>
		  <cfelseif #Asc(TD016)# eq "121"><br/><span class="badge badge-pill badge-info">指定結案</span>
		  </cfif>
		  <cfif #TD021# EQ "Y"><br/><span class="badge badge-pill badge-success">已確認</span>
		  <cfelseif #TD021# EQ "N"><br/><span class="badge badge-pill badge-secondary">未確認</span>
		  <cfelseif #TD021# EQ "V"><br/><span class="badge badge-pill badge-danger">作廢</span>
		  </cfif>

		</TD>
        <TD align="center">
		    #MID(TC003,1,4)#-#MID(TC003,5,2)#-#MID(TC003,7,2)#
	    </TD>
        <TD align="center">
		    #MID(TD013,1,4)#-#MID(TD013,5,2)#-#MID(TD013,7,2)#
			<cfif #Dateformat(now(),"yyyymmdd")# gt #TD013# AND #TD016# EQ "N"><br/><span class="badge badge-danger">逾期未出貨</span></cfif>
	    </TD>
		<TD align="center" width="100">#MA002#</TD> 
		<TD align="center" width="80">#TC012#<BR>#PC002#</TD>
		<TD align="center">#TD004#</TD>
		<TD width="250">#TD005#<br/>#TD006#</TD>
        <TD align="right" >#NUMBERFORMAT(TD008,"9,999,999")#</TD>
        <TD align="right" >#NUMBERFORMAT(TD008-TD009,"9,999,999")#</TD>
		<cfif #價格權限# eq "Y">
		<TD align="right">#NUMBERFORMAT(TD011,"9,999,999.99")#</TD>
		<TD align="right">#NUMBERFORMAT(TD012,"99,999,999")#</TD>
		</cfif>
		<TD align="center">
		   <cfloop query="COPTH">#MID(TG003,1,4)#/#MID(TG003,5,2)#/#MID(TG003,7,2)#(#NUMBERFORMAT(TH008,"9,999,999")#)<BR/></cfloop>
		</TD>
<!---		<TD align="center">
		   <cfloop query="COPTJ">#TRIM(TJ001)#-#TJ002#<BR/>#MID(TI003,1,4)#/#MID(TI003,5,2)#/#MID(TI003,7,2)#(#NUMBERFORMAT(TJ007,"9,999,999")#)<BR/></cfloop>
		</TD>
--->	 </tr>


</cfloop>
	<tr bgcolor="666666">
		<TD colspan="6"></TD>
		<TD align="center" style="color:FFF">小計</TD>
		<TD align="right" style="color:FFF">#numberformat(TOTALQTY,"999,999,999")#</TD>
		<td></td>
		<td></td>
		<TD align="right" style="color:FFF">#numberformat(TOTALMONEY,"999,999,999")#</TD>
		<td></td>
	</TR>
</tbody>
</table>
</div>

</cfoutput>

<cfinclude template="/EMG/footer.cfm">
