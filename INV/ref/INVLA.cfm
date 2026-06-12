<!---品號未結採購明細--->

<cfquery datasource="#SESSION.COMPANY#" name="INVLA">
    SELECT  top 30 *
    FROM  INVLA
    JOIN  CMSMQ ON MQ001=LA006
    JOIN CMSMC ON MC001=LA009
	WHERE 1=1
	AND LA001 = '#URL.MB001#'
	AND LA014 <> '4'
	AND LA011 <> 0
    ORDER BY LA004 DESC
</cfquery>

<cfoutput>
 
<cfif #INVLA.recordcount# neq 0>
 
 <h5 align="center">近期異動明細</h5>
 
<table border="1" align="center">

    <TR bgcolor="666666" style="color:FFF">
        <TD>日期</TD>
        <TD>單據</TD>
        <TD>單號</TD>
        <TD>數量</TD>
        <TD>庫別</TD>
        <TD>備註</TD>
    </TR>

<cfloop query="INVLA">
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
	<TR bgcolor="#bgcolor#" >
		<TD align="center" width="120">#MID(LA004,1,4)#-#MID(LA004,5,2)#-#MID(LA004,7,2)#</TD> 
		<TD>#MQ002#</TD> 
		<TD width="180" align="center">#TRIM(LA006)#-#TRIM(LA007)#-#LA008#</TD> 
		<TD align="right" width="60">#NUMBERFORMAT(LA011*LA005,"9,999,999")#</TD> 
		<TD>#MC002#</TD> 
		<TD>#LA010#</TD> 
    </TR>
</cfloop>	

</table>

<BR/>

</cfif>

</cfoutput>

