<cfif structkeyexists(rc,'json')>
	<cfcontent type="application/json" >
	<cfoutput>#serializejson(rc.remoteResult)#</cfoutput>
</cfif>
<cfset request.layout = false>