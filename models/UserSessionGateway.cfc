component accessors="true" extends="models.abstract.BaseGateway"{

	/**
	 * I delete a user session
	*/		 	
	void function deleteUserSession (required UserSession theUserSession) {
		delete( arguments.theUserSession );
	}
	/**
	 * I delete a user session
	*/
	UserSession function getUserSession( required string id ){
		return get( "UserSession", arguments.id );
	}
	/**
	 * I make a new user session
	 */		
	UserSession function newUserSession(){
		return new("UserSession");
	}
	/**
	 * I save a user session
	 */	
	UserSession function saveUserSession(required UserSession theUserSession){
		return save( arguments.theUserSession );
	}	
}