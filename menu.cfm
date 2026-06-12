<!---<cfinclude template="header.cfm">--->
<title>┄м</title>

<!---CSS--->
<style>
  table {border-collapse: collapse;font-family: "Microsoft JhengHei",arial,sans-serif !important;}
  h3{color:#000000;}
  body{font-family: "Microsoft JhengHei",arial,sans-serif !important;}
  input.largerCheckbox { width: 22px;  height: 22px;  } 
</style>
<html>

<head>
     <link rel="stylesheet" href="/css/bootstrap.min.css">
   
    <!---Fontawesome瓜ボ硈挡--->
    <link rel="stylesheet" href="/fontawesome/css/all.css">
  </head>
  <body>
    <!---<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>--->
    <!--- Optional JavaScript --->
    <!--- jQuery first, then Popper.js, then Bootstrap JS --->
    <script src="/js/jquery-3.5.1.slim.js"></script>
	<script src="/js/popper.min.js"></script>
	
    <script src="/js/bootstrap.min.js"></script>
  </body>
  
<link href="/css/defaultTheme.css" rel="stylesheet" media="screen" />
<link href="/css/myTheme.css" rel="stylesheet" media="screen" />
<script src="/js/jquery.min.js"></script>
<script src="/js/jquery.fixedheadertable.js"></script>

<script>
	$(document).ready(function() {
		$('#myTable01').fixedHeaderTable({ 
			footer: false,		
			cloneHeadToFoot: false,	
		});
	});
</script>

<cfif NOT IsDefined("SESSION.CNNAME")><cfset #SESSION.CNNAME#=""></cfif> 
<cfif NOT IsDefined("SESSION.ENNAME")><cfset #SESSION.ENNAME#=""></cfif> 
<cfif NOT IsDefined("SESSION.DepCode")><cfset #SESSION.DepCode#=""></cfif> 
<cfif NOT IsDefined("SESSION.COMPANY")><cfset #SESSION.COMPANY#=""></cfif> 
<cfif NOT IsDefined("SESSION.COMPANY_NAME")><cfset #SESSION.COMPANY_NAME#=""></cfif> 

<cfoutput>

<cfquery name="DSCMB" datasource="PKOOL">
<!---	SELECT *
	FROM DSCMB
	WHERE 1=1
	     AND MB001 <> '#SESSION.COMPANY#'
--->		 
		   SELECT   distinct MB001,MB002,MB003
	 FROM DSCMB
	 JOIN BIMPH ON MB001=PH003
	 WHERE PH001 = '#SESSION.Code#' AND MB001 <> '#SESSION.COMPANY#'
</cfquery>

<cfif #SESSION.CNNAME# neq "">
  
<!---琩高Τ舦家舱--->
<cfquery name="BIMPD" datasource="PKOOL">
    SELECT DISTINCT PD001,PD002
	FROM BIMPF
	JOIN BIMPE ON PE001=PF002
	JOIN BIMPD ON PE003=PD001
	JOIN BIMPH ON PH001=PF001 AND PH002=PF002
	WHERE PF001='#SESSION.Code#' 
	    AND PH003='#SESSION.COMPANY#'
    ORDER BY PD001
</cfquery>

<cfif #BIMPD.recordcount# eq 0>
      <h4 align="center" class="alert alert-warning">琩礚舦戈</h4>
        <a class="btn btn-outline-warning my-2 my-sm-0 m-1 " href="/EMG/Logout.cfm">祅</a>
 <cfabort>
 
</cfif>

<!---menu
<cfmenu bgcolor="666666" fontcolor="FFF" selectedItemColor="FFCC00"  type="horizontal" fontsize="14">
		   
<cfloop query="BIMPD">

     <!---琩高Τ舦家舱穨--->
	<cfquery name="BIMPG" datasource="PKOOL">
	   SELECT  DISTINCT PE001,PE002,PE005
		FROM BIMPF
		JOIN BIMPE ON PE001=PF002
		JOIN BIMPD ON PE003=PD001
		JOIN BIMPH ON PH001=PF001 AND PH002=PF002
		WHERE PF001='#SESSION.Code#' AND PD002='#PD002#' AND PH003='#SESSION.COMPANY#'
		ORDER BY PE001
	</cfquery>
    
   <cfmenuitem display="#PD002#"> 
        <cfloop query="BIMPG"><cfmenuitem display="#PE002#" href="#PE005#"></cfmenuitem></cfloop>
   </cfmenuitem>
   
</cfloop>
     
</cfmenu>
--->

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <a class="navbar-brand" href="/EMG/menu.cfm">
<!---  <img src="/EMG/logo.png" height="50" class="d-inline-block " alt="" loading="lazy">
---> ┄м
  </a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="##navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">

    <cfloop query="BIMPD">

		 <!---琩高Τ舦家舱穨--->
		<cfquery name="BIMPG" datasource="PKOOL">
		   SELECT  DISTINCT PE001,PE002,PE005
			FROM BIMPF
			JOIN BIMPE ON PE001=PF002
			JOIN BIMPD ON PE003=PD001
			JOIN BIMPH ON PH001=PF001 AND PH002=PF002
			WHERE PF001='#SESSION.Code#' 
			    AND PD002='#PD002#' 
				AND PH003='#SESSION.COMPANY#'
			ORDER BY PE001
		</cfquery>
	
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          #PD002#
        </a>
		
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
        <cfloop query="BIMPG"><a class="dropdown-item" href="#PE005#">#PE002#</a></cfloop>
          </div>
      </li>
     
	 </cfloop>
	 
    <form action="/EMG/change.cfm" method="post">	
     <span class="navbar-text">
		&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;
		祅<span class="badge badge-info" style="font-size:16px">#SESSION.cnname#</span>
		&nbsp;&nbsp; 
		そ<span class="badge badge-info" style="font-size:16px">#SESSION.COMPANY_NAME#</span>
    </span>
	
	<select name="COMPANY">
	<option value="#SESSION.COMPANY#">#SESSION.COMPANY_NAME#</option>	 
	<cfloop query="DSCMB"><option value="#MB003#">#MB002#</option></cfloop>
	</select>
	
	<input type="submit" name="submit" value="ち传そ"  class="btn btn-warning btn-sm">

	</form>
	
      <li class="nav-item nav-right">
        <a class="btn btn-outline-warning my-2 my-sm-0 m-1 " href="/EMG/Logout.cfm">祅</a>
      </li>  
    </ul>
  </div>
</nav>

</cfif>

</cfoutput>
