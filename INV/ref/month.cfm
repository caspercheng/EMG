<!---品號每月耗用統計--->

<cfquery datasource="#SESSION.COMPANY#" name="CMSPD">
    SELECT *
	FROM CMSPD
	WHERE PD001='月' 
	AND PD002 >= '#DATEFORMAT(NOW()-720,"YYYY-MM")#'
	AND PD002 <= '#DATEFORMAT(NOW(),"YYYY-MM")#'
	ORDER BY PD002 DESC
</cfquery>

<cfoutput>
 
 
 <h5 align="center">每月耗用統計</h5>
 
<table border="1" align="center">

    <TR bgcolor="666666" style="color:FFF">
        <TD>月份</TD>
        <TD>銷貨量</TD>
        <TD>領料量</TD>
    </TR>

<cfloop query="CMSPD">

	<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
		SELECT MB001,
		ISNULL(SUM(COP_TH008),0) AS COP_TH008,
		ISNULL(SUM(MOC_TE005),0) AS MOC_TE005
		
		FROM INVMB
	
		LEFT JOIN
		 (SELECT TH004,SUM(TH008-TH043) AS COP_TH008 
		  FROM COPTH 
		  JOIN COPTG ON TG001=TH001 AND TG002=TH002
		  WHERE TH020 ='Y' 
		   AND SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) >= '#PD003#'
		   AND SUBSTRING(TG003,1,4)+'-'+ SUBSTRING(TG003,5,2)+'-'+SUBSTRING(TG003,7,2) <= '#PD004#'
		  GROUP BY TH004) AS COPTH ON COPTH.TH004=MB001
	
		LEFT JOIN
		 (SELECT TE004,SUM(TE005) AS MOC_TE005
		  FROM MOCTE 
		  JOIN MOCTC ON TC001=TE001 AND TC002=TE002
		  WHERE TE019 ='Y' 
		   AND SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) >= '#PD003#'
		   AND SUBSTRING(TC003,1,4)+'-'+ SUBSTRING(TC003,5,2)+'-'+SUBSTRING(TC003,7,2) <= '#PD004#'
		  GROUP BY TE004) AS MOCTE ON MOCTE.TE004=MB001
	
		WHERE 1=1 
		 AND  MB001 = '#URL.MB001#' 
		GROUP  BY MB001
	</cfquery>

	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<TR bgcolor="#bgcolor#" >
		<TD>#PD002#</TD> 
		<TD align="right"><cfloop query="INVMB">#NUMBERFORMAT(COP_TH008,"9,999,999")#</cfloop></TD> 
		<TD align="right"><cfloop query="INVMB">#NUMBERFORMAT(MOC_TE005,"9,999,999")#</cfloop></TD> 
    </TR>
</cfloop>	

</table>


</cfoutput>

