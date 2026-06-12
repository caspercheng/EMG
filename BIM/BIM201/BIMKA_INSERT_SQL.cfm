<cfquery name="MAX_KA001" datasource="EAGLE">
     SELECT MAX(KA001)+1 AS MAXKA001 
	 FROM BIMKA
</cfquery>

<cfif #MAX_KA001.recordcount#  eq 1>
	<cfloop query="MAX_KA001"><cfset MAXSN=#MAXKA001#> </cfloop>
<cfelse>
	<cfset MAXSN=1>	
   
</cfif>

<!---系統別資料新增---> 
<cfquery name="BIMKA_INSERT" datasource="EAGLE">
     INSERT INTO BIMKA(KA001,KA002,KA003,KA004)
     
     VALUES('#NUMBERFORMAT(MAXSN,"00000")#','#FORM.KA002#','#FORM.KA003#','#FORM.KA004#')
</cfquery>



<cflocation url="BIMKA.cfm">