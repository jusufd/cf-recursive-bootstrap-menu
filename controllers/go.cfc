component accessors="true" extends="models.abstract.Base" {

	// DI
	property name="config" setter="true" getter="false";
	property name="MigrationService" setter="true" getter="false";

	public void function before(required struct rc) {
		super.before(rc,false,'go');
	}
	
	public void function main(required struct rc ){
		var local = {};
		param name='rc.errHeader' default='';
		if (rc.InitialSetup) {
			rc.migrationReport = variables.MigrationService.start();
		}	
	}
	/**	
	* I handle login 
	*/
	public void function login(required struct rc ){
		param name="rc.Password" default="";
		param name="rc.btn" default="";
		param name="rc.users_login" default={};
		var local = {};
		if (len(rc.UserSession.getEmail())) {
			param name="rc.remember" default="remember-me";
			param name="rc.Email" default="#rc.UserSession.getEmail()#";
		} else { 
			param name="rc.remember" default="";
			param name="rc.Email" default="";
		}
		rc.nofooter = true;
		local.reqField=['Email','Password'];
		rc.e = initErrField(reqField=local.reqField);
		if (!rc.userSession.hasUser()) {
			rc.users_login = variables.userService.login({
				"Email" = rc.Email,
				"Password" = rc.Password,
				"btn" = rc.btn
			},'Login',trim(rc.remember));
			if (len(trim(rc.users_login.getSuccessMessage())) > 0) {
				if (!structkeyexists(rc,'json')) {
					if (structkeyexists(rc.users_login,'goto')) 
						variables.fw.redirect(action=rc.users_login.goto.action,querystring=rc.users_login.goto.querystring);
					else 	
						variables.fw.redirect(action='admin.main');
				}	
			}
			rc.e = rc.users_login.getValidationMessage(reqField=local.reqField);
			structinsert(rc.remoteResult,'data',rc.e.remote);
			if (structkeyexists(rc.users_login,'showCaptcha')) 
				structinsert(rc.remoteResult.data,'showCaptcha',true);
		} else {
			variables.fw.redirect(action='admin.main');
		}
	}
	/**	
	* I handle logout 
	*/
	public void function signout(required struct rc ){
		if (rc.userSession.hasUser()) 
			variables.userService.signout();
		variables.fw.redirect(action='go.login');
	}
	/**	
	* I handle user profile 
	*/
	public void function profile(required struct rc ){
		if (isnull(rc.getCurrentSessionUser))
			variables.fw.redirect(action='go.login');
	}	
}	