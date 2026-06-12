<!---«~¸¹®w¦s©ú²Ó--->
<title>«~¸¹®w¦s©ú²Ó</title>
<cfquery datasource="#SESSION.COMPANY#" name="INVMB">
    SELECT  *
    FROM INVMB
    LEFT JOIN INVMA ON MA001='2' AND MA002=MB006
	WHERE 1=1
	AND MB001='#URL.MB001#'
</cfquery>



<cfquery datasource="#SESSION.COMPANY#" name="INVMC">
    SELECT  CMSMC.MC002 AS NAME,INVMC.MC003 AS LOCATION,INVMC.MC007 AS NUM,INVMC.MC004 AS MC004
    FROM INVMC
    LEFT JOIN CMSMC ON CMSMC.MC001=INVMC.MC002
	WHERE 1=1
	AND INVMC.MC001 = '#URL.MB001#'
	AND INVMC.MC007 <> 0
</cfquery>

<h4 align="center">«~¸¹®w¦s©ú²Ó</h4>

<!---¨Ï¥ÎŽÍ¿é¤J±ø¥ó--->
<cfoutput>
<cfloop query="INVMB">
	
    <table border="1" align="center" >
    
        <tr>
            <td  bgcolor="666666" style="color:FFF">«~¸¹</td>
            <td>#MB001#</td>
        </tr>
        
        <tr>
            <td  bgcolor="666666" style="color:FFF">«~¦W</td>
            <td>#MB002#</td>
        </tr>
    
        <tr>
            <td  bgcolor="666666" style="color:FFF">³W®æ</td>
            <td>#MB003#</td>
        </tr>
    
        <tr>
            <td  bgcolor="666666" style="color:FFF">³æ¦ì</td>
            <td>#MB004#</td>
        </tr>		
        
        <tr>
            <td  bgcolor="666666" style="color:FFF">«e¸m¤Ñ¼Æ</td>
            <td>#MB036#</td>
        </tr>		

        <tr>
            <td  bgcolor="666666" style="color:FFF">³Ì§C¸É¶q</td>
            <td>#NUMBERFORMAT(MB039,"9,999,999")#</td>
        </tr>		
 
         <tr>
            <td  bgcolor="666666" style="color:FFF">®w¦s¼Æ¶q</td>
            <td>#NUMBERFORMAT(MB064,"9,999,999")#</td>
        </tr>		
           
          
    </table>

</cfloop>	

<BR/>

 <h5 align="center">¦U®w§O¼Æ¶q</h5>

<table  align="center" border="1">

	<tr bgcolor="666666" style="color:FFF">
		<td>®w§O</td>
		<td>Àx¦s¦ì¸m</td>
		<td>¦w¥þ¦s¶q</td>
		<td align="center">¼Æ¶q</td>
	</tr>

<cfloop query="INVMC" > 	
	<cfif CurrentRow MOD 2 IS 0><cfset bgcolor="F0F0F0"><cfelse><cfset bgcolor="E0E0E0"></cfif>
    
	<TR bgcolor="#bgcolor#" >
		<td align="center">#NAME#</td>
		<td align="center">#LOCATION#</td>
		<td align="right">#NUMBERFORMAT(MC004 ,"9,999,999")#</td>
		<td align="right">#NUMBERFORMAT(NUM ,"9,999,999")#</td>
	</tr>
	</cfloop>	
	
</table>
<BR/>

<cfinclude template="PURTD.cfm">

<cfinclude template="MOCTB.cfm">

<cfinclude template="MOCTA.cfm">
	
<cfinclude template="COPTD.cfm">

<cfinclude template="INVLA.cfm">

<cfinclude template="month.cfm">

</cfoutput>

<cfinclude template="/EMG/close_window.cfm">
<cfinclude template="/EMG/footer.cfm">

