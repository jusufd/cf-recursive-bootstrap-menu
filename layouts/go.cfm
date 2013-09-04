<cfoutput>
	<!DOCTYPE html>
	<html lang="en" ng-app="CategoryGenApp" id="ng-app" xmlns:ng="http://angularjs.org">
  		<head>
    		<meta charset="utf-8">
    		<cfloop list="#structkeylist(rc.meta)#" delimiters="," index="local.p">
    			<cfset local.valueMeta = evaluate("rc.meta.#local.p#")>
    			<cfif isstruct(local.valueMeta)>
    				<cfloop list="#structkeylist(local.valueMeta)#" delimiters="," index="local.q">
    					<cfset local.valueMetaSub = evaluate("rc.meta.#local.p#.#local.q#")>
    					<meta name="#local.q#" content="#local.valueMetaSub#">		
    				</cfloop>	
    			<cfelse>
    				 <meta name="#local.p#" content="#local.valueMeta#">	
    			</cfif>
    		</cfloop>
   			<link rel="shortcut icon" href="#rc.ico_path#favicon.png">
			<link rel="apple-touch-icon-precomposed" sizes="144x144" href="#rc.ico_path#apple-touch-icon-144-precomposed.png">
   	 		<link rel="apple-touch-icon-precomposed" sizes="114x114" href="#rc.ico_path#apple-touch-icon-114-precomposed.png">
      		<link rel="apple-touch-icon-precomposed" sizes="72x72" href="#rc.ico_path#apple-touch-icon-72-precomposed.png">
            <link rel="apple-touch-icon-precomposed" href="#rc.ico_path#apple-touch-icon-57-precomposed.png">
            <title>#rc.meta_title#</title>
		    #trim(rc.cssString)#
    		<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    		<!--[if lt IE 9]>
      			<script src="#rc.js_path#html5shiv.js"></script>
      			<script src="#rc.js_path#respond.min.js"></script>
    		<![endif]-->
    		<style>
				[ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak { display:none!important; }
   			</style>	
 		</head>
		<body>
			<div class="navbar navbar-inverse navbar-fixed-top">
      			<div class="navbar-inner">
        			<div class="container-fluid">
			          	<button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
			            	<span class="icon-bar"></span>
			            	<span class="icon-bar"></span>
			            	<span class="icon-bar"></span>
			          	</button>
	          			<a class="brand" href="#buildurl(action='go.main')#">#trim(rc.config.name)#</a>
	          			<div class="nav-collapse collapse">
	          				<cfif !isnull(rc.getCurrentSessionUser)>
	          					<p class="navbar-text pull-right">
				              		<span>Logged in as <a href="#buildurl(action='go.profile')#" class="navbar-link">#trim(rc.getCurrentSessionUser.getEmail())#</a></span>
				              		<span><a href="#buildurl(action='go.signout')#" class="navbar-link">Logout</a></span>
				            	</p>
							</cfif>		
				            <cfif listfirst(rc.action,'.') IS 'admin'>
				            	<ul class="nav">
						            <li<cfif rc.action IS 'admin.main'> class="active" </cfif>><a href="/">Home</a></li>
						            <li<cfif rc.action IS 'admin.category'> class="active dropdown" <cfelse> class="dropdown" </cfif>>
						            	<a href="##" class="dropdown-toggle" data-toggle="dropdown">Catalog <b class="caret"></b></a>
				              			<ul class="dropdown-menu">
				                			<li><a href="#buildurl(action='admin.category',querystring='product')#">Manage Product Categories</a></li>
				                			<li><a href="#buildurl(action='admin.category',querystring='menu')#">Manage Front End Menu</a></li>
				              			</ul>
				            		</li>
		          				</ul>
				            <cfelseif len(trim(rc.navString)) GT 0>
				            	#trim(rc.navString)#
							</cfif>	
	          			</div><!--/.nav-collapse -->
        			</div>
      			</div>
    		</div>
    		<cfif structkeyexists(rc,'e')>
				<cfif structkeyexists(rc.e,'messageBox')>#rc.e.messageBox#</cfif>
			</cfif>
		    <div class="container-fluid">
		    	#body#
			</div>
			<cfif !structkeyexists(rc,'nofooter')>
				<div id="footer">
	      			<div class="container">
	      				<p>
							Design thanks to <a href="http://twitter.github.com/bootstrap">Twitter Boostrap</a>
						</p>
	      			</div>
	    		</div>
			</cfif>		
			#trim(rc.jsString)#	
		</body>
	</html>
</cfoutput>	