<!---人員作業權限新增---> 

<!---判斷前面checkbox是否有勾，給預設值---> 
<cfif  NOT IsDefined("FORM.PF003")> <cfset #FORM.PF003#="">	</cfif> 
<cfif  NOT IsDefined("FORM.PF004")> <cfset #FORM.PF004#="">	</cfif> 
<cfif  NOT IsDefined("FORM.PF005")> <cfset #FORM.PF005#="">	</cfif> 
<cfif  NOT IsDefined("FORM.PF006")> <cfset #FORM.PF006#="">	</cfif> 
<cfif  NOT IsDefined("FORM.PF007")> <cfset #FORM.PF007#="">	</cfif> 

<cfif #FORM.PF003# neq ""><cfset PF003 ="Y"><cfelse><cfset PF003 ="N"></cfif>
<cfif #FORM.PF004# neq ""><cfset PF004 ="Y"><cfelse><cfset PF004 ="N"></cfif>
<cfif #FORM.PF005# neq ""><cfset PF005 ="Y"><cfelse><cfset PF005 ="N"></cfif>
<cfif #FORM.PF006# neq ""><cfset PF006 ="Y"><cfelse><cfset PF006 ="N"></cfif>
<cfif #FORM.PF007# neq ""><cfset PF007 ="Y"><cfelse><cfset PF007 ="N"></cfif>

<cfquery name="BIMPF_INSERT" datasource="PKOOL">
     INSERT INTO BIMPF(PF001,PF002,PF003,PF004,PF005,PF006,PF007)
     
     VALUES('#TRIM(FORM.PF001)#','#FORM.PF002#','#PF003#','#PF004#','#PF005#',
                    '#PF006#','#PF007#')
</cfquery>

	<!---新增公司別權限---> 
	<cfquery name="BIMPH_INSERT" datasource="PKOOL">
		INSERT INTO BIMPH(PH001,PH002,PH003)
		VALUES('#FORM.PF001#','#FORM.PF002#','AGP')
	</cfquery>

<cflocation url="BIMPF.cfm?PE001=#FORM.PF002#">
