<cfif structkeyexists(rc.config,'development')>
	<cfdump var="#request#">
<cfelse>
	<cfheader statuscode="404" statustext="Not Found">
	<cfoutput>
		<p style="font:normal 18px/25px Arial, Helvetica, sans-serif;">404. That's an error.</p>
		<p style="font:normal 18px/25px Arial, Helvetica, sans-serif;">The requested URL #trim(cgi.PATH_INFO)# was not found on this server.<br />That's all we know.</p>
	</cfoutput>
	<cfmail 
		from="#rc.config.exceptionTracker.emailNewExceptionsFrom#" 
		to="#rc.config.exceptionTracker.emailNewExceptionsTo#" 
		subject="Failure" 
		type="html">
		<cfdump var="#request#">
	</cfmail>		
</cfif>
