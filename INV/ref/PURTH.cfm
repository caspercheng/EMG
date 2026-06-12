<title>價格走勢及進貨明細</title>
<h4 align="center">價格走勢及進貨明細</h3>

<cfquery name="PURTH" datasource="#SESSION.COMPANY#" >
    SELECT *
    FROM PURTH
    JOIN PURTG ON TG001=TH001 AND TG002=TH002
    JOIN PURMA ON MA001=TG005
    WHERE TH004='#URL.MD003#' 
	    AND TH030='Y'
		AND TG003 >= '20180101'
		AND TH015 > 0
		AND TH047 > 0
	ORDER BY TG003 DESC
</cfquery>

<cfquery name="PURTH_SUM" datasource="#SESSION.COMPANY#" >
       SELECT SUBSTRING(TG003,1,4) AS YEAR,ROUND(SUM(TH047)/SUM(TH015),3) AS PRICE
    FROM PURTH
    JOIN PURTG ON TG001=TH001 AND TG002=TH002
    JOIN PURMA ON MA001=TG005
    WHERE TH004='#URL.MD003#' 
	    AND TH030='Y'
		AND TG003 >= '20180101'
		AND TH015 > 0
		AND TH047 > 0
	GROUP BY SUBSTRING(TG003,1,4)
	ORDER BY SUBSTRING(TG003,1,4)
</cfquery>

<cfloop query="PURTH_SUM" startrow="1" endrow="1">
   <cfset a = #NUMBERFORMAT(PRICE*0.8,"99999.99")#>
</cfloop>

<cfloop query="PURTH_SUM">
   <cfset b = #NUMBERFORMAT(PRICE*1.2,"99999.99")#>
</cfloop>

<div align="center">
<cfchart format="html" chartwidth="600"  chartheight="300" yaxistitle="單價" xaxistitle="年度" markersize="3"
   scaleFrom = "#a#" labelformat="number" scaleTo = "#b#" 
   fontsize="14"  gridlines="10" showXGridlines="yes">

  <cfchartseries type="line" query="PURTH_SUM" valuecolumn="PRICE"  itemcolumn="YEAR" serieslabel="進價走勢" seriescolor="0000FF" paintstyle="light" ></cfchartseries>


</cfchart>
</div>

<br/>

<cfoutput>
 
<table align="center" border="1">
	<TR bgcolor="666666" style="color:FFF">
	    <td>進貨日</td>
	    <td>廠商</td>
	    <td>進貨單號</td>
		<td>品號</td>
		<td>品名</td>
        <td>規格</td>
		<td>數量</td>
		<td>金額</td>
		<td>單價</td>
	</tr>

    <cfloop query="PURTH">
    
    <cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<TR bgcolor="#bgcolor#">
	    <td>#MID(TG003,1,4)#-#MID(TG003,5,2)#-#MID(TG003,7,2)#</td>
	    <td>#MA002#</td>
	    <td>#trim(TH001)#-#TH002#-#TH003#</td>
		<td>#TH004#</td>
		<td>#TH005#</td>
        <td>#TH006#</td>
		<td align="right">#NUMBERFORMAT(TH015,"9,999,999")#</td>
		<td align="right">#NUMBERFORMAT(TH047,"9,999,999")#</td>
		<td align="right">#NUMBERFORMAT(TH047/TH015,"9,999,999.99")#</td>
	</tr>
    </cfloop>
</table>

</cfoutput>


<cfinclude template="/EMG/close_window.cfm">
<cfinclude template="/EMG/footer.cfm">
