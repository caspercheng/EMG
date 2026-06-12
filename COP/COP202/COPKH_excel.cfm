<cfsetting enablecfoutputonly="Yes">
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=多階成本核價表_#dateformat(now(),"YYYY-MM-DD")#.xls">

<!---查詢資料--->
<cfquery name="COPKG" datasource="#SESSION.COMPANY#">
	SELECT *
	FROM COPKG
	LEFT JOIN INVMB ON MB001=KG002	
	WHERE 1=1
      AND KG001= '#TRIM(URL.KH001)#'
</cfquery>

<cfloop query="COPKG">
	<cfset MB001=#KG002#>
	<cfset KG003=#KG003#>
	<cfset KG004=#KG004#>
	<cfset KG005=#KG005#>
	<cfset KG006=#KG006#>
</cfloop>

<!---查詢資料--->
<cfquery name="COPKH" datasource="#SESSION.COMPANY#">
	SELECT *,A.MA002 A_MA002,B.MA002 B_MA002
	FROM COPKH
	JOIN INVMB ON KH004=MB001
	LEFT JOIN PURMA A ON A.MA001=KH009
	LEFT JOIN PURMA B ON B.MA001=KH013
	WHERE 1=1
      AND KH001= '#TRIM(URL.KH001)#'
</cfquery>

<cfquery name="GET_KH014" datasource="#SESSION.COMPANY#">
	SELECT SUM(KH014) SUMKH014
	FROM COPKH
	WHERE 1=1
      AND KH001= '#TRIM(URL.KH001)#'
</cfquery>

<cfoutput>


<table align="center"  border="1" >
	<tr>
			<td align="center" colspan="18">
			<font size="+2"><strong>上岳科技股份有限公司</strong></font><br />
			<font size="+1"><strong>多階成本核價表</strong></font><br />
			<font size="+1"><strong>品號：#MB001#&emsp;基準日：#KG003#</strong></font><br />
			<font size="+1"><strong>製表日期：#dateformat(NOW(),"yyyy-mm-dd")#</strong></font>	
			
			</td>
		</tr>
	<tr align="center">
		<td colspan="6" align="left">主件品號：#MB001#</td>
		<td colspan="5">前次核價</td>
		<td colspan="7">本次核價</td>
	</tr>
	<tr align="center">
		<td>階次</td>
		<td>屬性</td>
		<td>元件品號</td>
		<td>品名</td>
		<td>規格</td>
		<td>單位</td>
		<td>標準用量</td>
		<td>單價(未稅)</td>
		<td>加工費</td>
		<td>總價(未稅)</td>
		<td>廠商</td>
		<td>核價後單價(未稅)</td>
		<td>核價後加工費</td>
		<td>核價後總價(未稅)</td>
		<td>廠商</td>
		<td>異動金額</td>
		<td>價格浮動幅度</td>
		<td>核價單單號</td>
	</tr>

<cfloop query="COPKH" > 	
	 
    <tr>
		<td>#KH003#</td>
		<td>
		<cfif #MB025# EQ "P">採購件</cfif>
		<cfif #MB025# EQ "S">託外加工件</cfif>
		<cfif #MB025# EQ "M">自製件</cfif>
		<cfif #MB025# EQ "Y">虛設件</cfif>
		</td>
		<td>#KH004#</td>
		<td>#MB002#</td>
		<td>#MB003 #</td>
		<td>#KH019#</td>
		<td align="right">#NUMBERFORMAT(KH005,"999,999,999.99")#</td>
		<td align="right">#NUMBERFORMAT(KH006,"999,999,999.99")#</td>
		<td align="right">#NUMBERFORMAT(KH007,"999,999,999.99")#</td>
		<td align="right">#NUMBERFORMAT(KH008,"999,999,999.99")#</td>
		<td>#A_MA002#</td>
		<td align="right">#NUMBERFORMAT(KH010,"999,999,999.99")#</td>
		<td align="right">#NUMBERFORMAT(KH011,"999,999,999.99")#</td>
		<td align="right">#NUMBERFORMAT(KH012,"999,999,999.99")#</td>
		<td>#B_MA002#</td>
		<td align="right">#NUMBERFORMAT(KH014,"999,999,999.99")#</td>		
		<td align="right"><cfif #KH015# NEQ 0>#NUMBERFORMAT(KH015*100,"999,999,999.99")#%</cfif></td>
		<td>#KH016#-#KH017#-#KH018#</td>
	</tr>
	</cfloop>	
    <tr align="center">
		<td colspan="1"></td>
		<td colspan="1"></td>
		<td colspan="1"></td>
		<td colspan="1">合計:</td>
		<td colspan="1"></td>
		<td colspan="1"></td>
		<td colspan="3">核價前</td>
		<td colspan="1" align="right">#NUMBERFORMAT(KG004,"999,999,999.99")#</td>
		<td colspan="1"></td>
		<td colspan="2">核價後</td>
		<td colspan="1" align="right">#NUMBERFORMAT(KG005,"999,999,999.99")#</td>
		<td colspan="1"></td>
		<td colspan="1" align="right"><cfloop query="GET_KH014">#NUMBERFORMAT(SUMKH014,"999,999,999.99")#</cfloop></td>
		<td colspan="1" align="right">#NUMBERFORMAT(KG006*100,"999,999,999.99")#%</td>
		<td colspan="1"></td>
	</tr>
		<TR style="vertical-align:middle; border:hidden">
			<TD colspan="18" height="50"><font size="+1">&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;核准：
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;審核：
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;經辦：#SESSION.CNNAME#
			
			
			
			</font></TD>

			
		</TR>
</table>
</cfoutput>
