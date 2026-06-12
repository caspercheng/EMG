<title>進貨統計表</title>
<cfinclude template="/EMG/menu.cfm">

<!---設定此程式代號--->
<cfset program_id = "PUR306" >
<cfset program_name = "進貨統計表" >
<cfset program_type = "Q" >

<!---檢查是否有權限--->
<cfinclude template="/EMG/permission.cfm">

<cfif  NOT IsDefined("FORM.MA002")> <cfset #FORM.MA002#="">	</cfif> 
<cfif  NOT IsDefined("FORM.TG003_1")> <cfset #FORM.TG003_1#="">	</cfif> 
<cfif  NOT IsDefined("FORM.TG003_2")> <cfset #FORM.TG003_2#="">	</cfif> 
<cfif  NOT IsDefined("FORM.TH004")> <cfset #FORM.TH004#="">	</cfif> 
<cfif  NOT IsDefined("FORM.submit")> <cfset #FORM.submit#="">	</cfif> 

<cfoutput>

<h4><center>進貨統計表</center></h4>

<!---使用者查詢條件--->
<cfform action="PURTH.cfm" method="post">

	<table align="center" bgcolor="9999CC">
	 <tr>		 
	  <td>進貨日期</td> <td>
	  <cfinput type="datefield"  mask="yyyy-mm-dd" name="TG003_1" size="6" 
	  monthnames="一月,二月,三月,四月,五月,六月,七月,八月,九月,十月,十一月,十二月" firstdayofweek="1" maxlength="10" required="yes"  message="請輸入開始銷貨日期">
	  ～</td>
      <TD><cfinput type="datefield"   mask="yyyy-mm-dd" name="TG003_2" size="6" 
	  monthnames="一月,二月,三月,四月,五月,六月,七月,八月,九月,十月,十一月,十二月" firstdayofweek="1" maxlength="10" required="yes"  message="請輸入結束銷貨日期"></td>
	  <td>廠商簡稱</td><td><cfinput type="text" size="8" name="MA002"></td>
	  <td>品號</td><td><cfinput type="text" size="15" name="TH004"></td>
	  <td>類別</td><td><select name="TYPE"><option value="1">依廠商統計</option><option value="2">依品號統計</option></select></td>
	  <td>排序</td><td><select name="order"><option value="1">依金額</option><option value="2">依數量</option></select></td>
	  <td colspan="1" align="center"><input type="submit" name="submit" value="查詢"></td>
	  </tr>
	</table>

</cfform>

<cfif #FORM.submit# neq "查詢"><cfabort></cfif>

<!---查詢計數歸零--->
<cfset current_row=0>

查詢條件：進貨日期: #TG003_1#～#TG003_2#，客戶簡稱: #MA002#，品號: #TH004#

<cfif #FORM.TYPE# eq "1">

		<!---查詢客戶統計--->
		<cfquery datasource="#SESSION.COMPANY#" name="PURTH">
			SELECT MA001,MA002,SUM(TH007) AS SUMTH007,SUM(TH019) AS SUMTH019
			FROM PURTH
			JOIN PURTG ON TH001=TG001 AND TH002=TG002
			JOIN INVMB ON MB001=TH004
			JOIN PURMA ON MA001=TG005
			WHERE 1=1 AND TH030 = 'Y'
			<cfif FORM.MA002 IS NOT ""> AND  MA002 like '%#FORM.MA002#%' </cfif>
			<cfif FORM.TG003_1 IS NOT ""> AND  SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) >= '#FORM.TG003_1#' </cfif>
			<cfif FORM.TG003_2 IS NOT ""> AND  SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) <= '#FORM.TG003_2#' </cfif>
			<cfif FORM.TH004 IS NOT ""> AND  TH004 like '%#FORM.TH004#%' </cfif>
			GROUP BY MA001,MA002
			ORDER BY <cfif FORM.order IS  "1"> SUM(TH019)<cfelse>SUM(TH007)</cfif> DESC
		</cfquery>
		
		<div style="height:80%">
		<table id="myTable01" class="fancyTable" >
		<thead>
		
		<TR bgcolor="666666" style="color:FFF">
			<TH>排名</TH>
			<TH>廠商代號</TH>
			<TH>廠商簡稱</TH>
			<TH>數量</TH>
			<cfif #價格權限# eq "Y">
			<TH>金額</TH>
			</cfif>
			<TH>明細</TH>
		</TR>
		  </thead>
		
		<tbody>
		
		<cfloop query="PURTH">
		
			<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
			
			<tr bgcolor="#bgcolor#">
				<TD align="center">#CurrentRow#</TD>
				<TD align="center">#MA001#</TD> 
				<TD align="center">#MA002#</TD> 
				<TD align="right">#NUMBERFORMAT(SUMTH007,"9,999,999")#</TD>
				<cfif #價格權限# eq "Y">
				<TD align="right">#NUMBERFORMAT(SUMTH019,"99,999,999.99")#</TD>
				</cfif>
				<TD align="center"><a href="PURTH_detail.cfm?TG003_1=#FORM.TG003_1#&TG003_2=#FORM.TG003_2#&MA002=#MA002#&TH004=#FORM.TH004#" target="_blank">明細</a></TD>
			</tr>

                 <!---查詢計數--->
                 <cfif #MA002# NEQ "">
                 <cfset current_row=current_row + 1>
                 </cfif>

		</cfloop>

		</tbody>

		<!---查詢無資料提示--->
                <cfif current_row EQ "0">
                <h4><center><span style="color:FF3030;">本次查詢無資料，請更新查詢條件。</span></center></h4>
                </cfif>

		</table>
		</div>

<cfelse>

		<!---查詢品號統計--->
		<cfquery datasource="#SESSION.COMPANY#" name="PURTH2">
			SELECT  MB001,MB002,MB003,SUM(TH007) AS SUMTH007,SUM(TH019) AS SUMTH019
			FROM PURTH
			JOIN PURTG ON TH001=TG001 AND TH002=TG002
			JOIN INVMB ON MB001=TH004
			JOIN PURMA ON MA001=TG005
			WHERE 1=1 AND TH030 = 'Y'
			<cfif FORM.MA002 IS NOT ""> AND  MA002 like '%#FORM.MA002#%' </cfif>
			<cfif FORM.TG003_1 IS NOT ""> AND  SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) >= '#FORM.TG003_1#' </cfif>
			<cfif FORM.TG003_2 IS NOT ""> AND  SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) <= '#FORM.TG003_2#' </cfif>
			<cfif FORM.TH004 IS NOT ""> AND  TH004 like '%#FORM.TH004#%' </cfif>
			GROUP BY MB001,MB002,MB003
			ORDER BY <cfif FORM.order IS  "1"> SUM(TH019)<cfelse>SUM(TH007)</cfif> DESC
		</cfquery>
		
		
		<div style="height:80%">
		<table id="myTable01" class="fancyTable" >
		<thead>
		
		<TR bgcolor="666666" style="color:FFF">
			<TH>排名</TH>
			<TH>品號</TH>
			<TH>品名</TH>
			<TH>規格</TH>
			<TH>數量</TH>
			<cfif #價格權限# eq "Y">
			<TH>金額</TH>
			</cfif>
			<TH>明細</TH>
		</TR>
		  </thead>
		
		<tbody>
		
		
		<cfloop query="PURTH2">
		
			<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
			
			<tr bgcolor="#bgcolor#">
				<TD align="center">#CurrentRow#</TD>
				<TD align="center">#MB001#</TD>
				<TD>#MB002#</TD> 
				<TD align="center">#MB003#</TD>
				<TD align="right">#NUMBERFORMAT(SUMTH007,"9,999,999")#</TD>
				<cfif #價格權限# eq "Y">
				<TD align="right">#NUMBERFORMAT(SUMTH019,"99,999,999.99")#</TD>
				</cfif>
				<TD align="center"><a href="PURTH_detail.cfm?TG003_1=#FORM.TG003_1#&TG003_2=#FORM.TG003_2#&MA002=#FORM.MA002#&TH004=#MB001#" target="_blank">明細</a></TD>
			</tr>

                 <!---查詢計數--->
                 <cfif #MB001# NEQ "">
                 <cfset current_row=current_row + 1>
                 </cfif>

		</cfloop>
		
		</tbody>

                <!---查詢無資料提示--->
                <cfif current_row EQ "0">
                <h4><center><span style="color:FF3030;">本次查詢無資料，請更新查詢條件。</span></center></h4>
                </cfif>

		</table>

		</div>
		
</cfif>


 </cfoutput>

<cfinclude template="/EMG/footer.cfm">
