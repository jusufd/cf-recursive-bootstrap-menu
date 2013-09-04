component persistent='true' table='Users' hint="User/Customer Table" cacheuse="transactional" 
{
	property name="Id" fieldtype='id' column='UserPk' generator='uuid' length="32" unsavedvalue="-1"; 
	property name='FirstName' length='50' notnull='true';
	property name='LastName' length='50';
	property name='MiddleInitial' length='5';
	property name='Gender' ormtype='char' length='1';
	property name='Dob' ormtype='date';
	property name='IsPicture' ormtype='boolean';
	property name='Email' length='255' notnull='true';
	property name='Password' length='255' notnull='true';
	property name='PasswordReset' length='255' ;
	property name='PasswordResetTimeout' ormtype='timestamp';
	property name='Salt' length='50' notnull='true'; 
	property name='Created' ormtype='timestamp';
	property name='Updated' ormtype='timestamp';	
	
	/**
 	* I initialise this component
	*/		
	User function init(){
		return this;
	}
	/**
	 * I return true if the email address is unique
	 */		
	public struct function isEmailUnique(){
		var matches = []; 
		var result = {issuccess=false, failuremessage="The email address '#variables.Email#' has been used." };
		if (isPersisted()) 
			matches = ORMExecuteQuery("from User where Id <> :Id and Email = :Email",{ Id=variables.Id, Email=variables.Email });
		else 
			matches = ORMExecuteQuery("from User where Email=:Email",{ Email=variables.Email } );
		if (!ArrayLen(matches)) 
			result.issuccess = true;
		return result;
	}
	/**
	 * I return true if the user is persisted
	 */	
	public boolean function isPersisted(){
		return !IsNull( variables.UserPk );
	}
	
}