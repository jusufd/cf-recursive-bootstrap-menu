component accessors="true" {
	
	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	// property name="EnquiryService" setter="true" getter="false";
	property name="config" setter="true" getter="false";
	property name="UserService" setter="true" getter="false";

	/**
	 * I return all the migrations status
	*/
	public array function start() {
		var local = {};
		local.retval = [];
		local.entUser = entityload('User');
		if (arraylen(local.entUser)==0)	
			arrayappend(local.retval,{
				"name" = "establishUser",
				"status" = establishUser()
			});
		return local.retval;	
	};
	/**
	 * I return the status of establishing new admin user or any related test user
	*/
	private struct function establishUser() {
		var local = {};
		local.retval = {"error"=true,"errordump"=""};
		local.password = variables.UserService.hashPassword("admin");
		transaction {
			try {
					entitysave(entitynew('User',{
						FirstName = "Joseph",
						Email = "me@domain.com",
						Password = local.password.password,
						Salt = local.password.salt,
						Created = now()
					}));
					transaction action="commit";
					local.retval.error = false;
			} catch(Any e) {
				transaction action="rollback";
				savecontent variable="local.retval.errordump" { writedump(var='#e#'); };
			}; 
		};
		return local.retval;
	};
}