component accessors="true" extends="models.abstract.BaseService"{

	property name="UserSessionGateway" getter="false";

	/**
	 * I am adding user session into database
	 */		
	public UserSession function saveUserSession(required struct properties){
		var local = {};
		var UserSession = variables.UserSessionGateway.getUserSession(arguments.properties.Id);
		transaction {
			populate(entity=UserSession,memento=properties);
			variables.UserSessionGateway.save(UserSession);
		}
		return UserSession;
	}
	/**
	 * I am getting current user session 
	 */
	public UserSession function getCurrentSession() {
		return variables.UserSessionGateway.getUserSession(trim(session.sessionid));
	}


}