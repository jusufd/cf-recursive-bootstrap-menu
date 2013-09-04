component accessors="true" extends="models.abstract.BaseGateway" {

	/**
	* I return users
	*/
	array function getUsers(numeric limit = 0,string orderby = "FirstName"){
		var local = {};
		local.maxResults = {};
		if (arguments.limit > 0)
			structinsert(local.maxResults,'maxResults',arguments.limit);
		return EntityLoad("User",{},arguments.orderby,local.maxResults);
	}
	/**
	* I find user by their email address
	*/
	User function getUserByEmail(required string email ){
		var Entity = EntityLoad("User",{"Email"=arguments.email},true);
		if (IsNull(Entity)) 
			Entity = newUser();
		return Entity;
	}
	/**
	 * I return a new user
	 */		
	User function newUser(){
		return new( "User" );
	}
}	