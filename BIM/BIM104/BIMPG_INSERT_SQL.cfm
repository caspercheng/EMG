<!---部門權限新增---> 

<!---判斷前面checkbox是否有勾，給預設值---> 
<cfif  NOT IsDefined("FORM.PG003")> <cfset #FORM.PG003#="">	</cfif> 
<cfif  NOT IsDefined("FORM.PG004")> <cfset #FORM.PG004#="">	</cfif> 
<cfif  NOT IsDefined("FORM.PG005")> <cfset #FORM.PG005#="">	</cfif> 
<cfif  NOT IsDefined("FORM.PG006")> <cfset #FORM.PG006#="">	</cfif> 
<cfif  NOT IsDefined("FORM.PG007")> <cfset #FORM.PG007#="">	</cfif> 

<cfif #FORM.PG003# neq ""><cfset PG003 ="Y"><cfelse><cfset PG003 ="N"></cfif>
<cfif #FORM.PG004# neq ""><cfset PG004 ="Y"><cfelse><cfset PG004 ="N"></cfif>
<cfif #FORM.PG005# neq ""><cfset PG005 ="Y"><cfelse><cfset PG005 ="N"></cfif>
<cfif #FORM.PG006# neq ""><cfset PG006 ="Y"><cfelse><cfset PG006 ="N"></cfif>
<cfif #FORM.PG007# neq ""><cfset PG007 ="Y"><cfelse><cfset PG007 ="N"></cfif>

<cfquery name="BIMPG_INSERT" datasource="PKOOL">
     INSERT INTO BIMPG(PG001,PG002,PG003,PG004,PG005,PG006,PG007)
     
     VALUES('#TRIM(FORM.PG001)#','#FORM.PG002#','#PG003#','#PG004#','#PG005#',
                    '#PG006#','Y')
</cfquery>

<cflocation url="BIMPG.cfm?PC001=#FORM.PG001#">
