component accessors="true" extends="models.abstract.BaseService"{

	property name="UserGateway" getter="false";
	property name="Validator" getter="false";
	property name="UserSessionService" getter="false";

	/**
	 * I return an array of one user
	 */	
	public array function getOneUser() {
		return variables.UserGateway.getUsers(limit=1);
	}
	/**
	 * I hash the password
	*/
	public struct function hashPassword(string password,string salt='') {
		var local = structnew();
		local.passwordHash = '';
		local.salt = arguments.salt;
		if (len(trim(arguments.salt))==0) {
			local.salt = createuuid();
		} 
		if (len(trim(arguments.password))) {
			local.passwordHash = hash(arguments.password & local.salt,'SHA-512');
			for(i=1;i<=1025;i++) {
				local.passwordHash = hash(local.passwordHash & local.salt,'SHA-512');
			}
		}	
		return {"password" = local.passwordHash,"salt" = local.salt};
	}
	/**
		* I handle the user login
	*/		
	public struct function login(required struct properties, required string context, string remember=''){
		var currentSesssion = variables.UserSessionService.getCurrentSession();
		var result = variables.Validator.newresult();
		if (len(trim(arguments.properties.btn)) > 0) {
			transaction{
				if (len(trim(arguments.properties.Email)) <= 0) {
					result.addFailure(propertyName = 'Email',message = 'Please enter the email address');
				} else {
					var User = variables.UserGateway.getUserByEmail(arguments.properties.Email);
					if (!isnull(User.getId())) {
						if (len(trim(arguments.properties.Password))==0) {
							result.addFailure(propertyName = 'password',message = 'Please enter the password');
						} else {
							var userPassword = hashPassword(trim(arguments.properties.Password),User.getSalt());
							if (compare(userPassword.password,User.getPassword())!=0) {
								result.addFailure(propertyName = 'password',message = 'Please enter the correct password');
							}
						}	
					} else {
						result.addFailure(propertyName = 'Email',message = 'Can not find this following email address #arguments.properties.Email#');
					}
				}
				if( !result.hasErrors() ) {
					loginGateway(argUser = User,properties = arguments.properties,remember=arguments.remember);
					result.setSuccessMessage( "Login Success" );
				} else {
					updateWrongAnswer();
					result.setErrorMessage( "Login failure. Please amend the highlighted fields." );

				}
			}
		}		
		return result;
	}
	/**
		* I handle the user sign out
	*/		
	public void function signout(){
		var currentSesssion = variables.UserSessionService.getCurrentSession();
		transaction {
			currentSesssion.setUser(javacast("null",""));
			currentSesssion.setLogoutTime(now());
			currentSesssion.setUpdated(now());
			entitysave(currentSesssion);
		}	
	}	
	/**
		* I handle after login success
	*/
	private boolean function loginGateway(required User argUser,required struct properties, string remember='') {
		var currentSesssion = variables.UserSessionService.getCurrentSession();
		var result = false;
		transaction {
			currentSesssion.setUser(argUser);
			currentSesssion.setLoginTime(now());
			currentSesssion.setLogoutTime(javacast('null',''));
			currentSesssion.setWrongLogin(0);
			currentSesssion.setUpdated(now());
			if (len(arguments.remember))
				currentSesssion.setEmail(argUser.getEmail());
			else 
			 	currentSesssion.setEmail(javacast('null',''));
			entitysave(currentSesssion);
			if (structkeyexists(arguments.properties,'goto')) {
				structinsert(result,'goto',deserializeGoto(arguments.properties.goto));
			}
			result = true;
		}	
		return result;
	}
	/**
		* I handle after login not success
	*/
	private void function updateWrongAnswer() {
		var currentSesssion = variables.UserSessionService.getCurrentSession();
		transaction {
			var wrongLogin = currentSesssion.getWrongLogin();
			if (isnull(wrongLogin))
				wrongLogin = 0;
			wrongLogin++;
			currentSesssion.setWrongLogin(wrongLogin);
			entitysave(currentSesssion);
		}	
	}

}	