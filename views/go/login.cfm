<cfoutput>
	<form class="form-signin" method="post" action="#buildurl(action='go.login')#">
		<h2 class="form-signin-heading">Please sign in</h2>
	    <input type="text" class="input-block-level" placeholder="Email address" autofocus name="Email" id="Email" value="#trim(rc.Email)#" #rc.e.fields.email.css#/>
		<input type="password" class="input-block-level" placeholder="Password" name="Password" id="Password" value="#trim(rc.Password)#" #rc.e.fields.password.css#/>
	    <label class="checkbox">
	    	<input type="checkbox" name="remember" value="remember-me"<cfif len(trim(rc.remember)) GT 0> checked </cfif>> Remember me
	    </label>
	    <button class="btn btn-large btn-primary" type="submit" name="btn" value="Sign in">Sign in</button>
	</form>
</cfoutput>	