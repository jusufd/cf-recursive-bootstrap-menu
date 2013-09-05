component table='UserSessions' persistent='true' hint="User Session Table" {
	property name="Id" fieldtype="id" column='SessionPk' generator='assigned' length="255";
	property name='LoginTime' ormtype='timestamp';
	property name='LogoutTime' ormtype='timestamp';
	property name='WrongLogin' ormtype='integer';
	property name="WrongLoginTime" ormtype="timestamp";
	property name='LockEnd' ormtype='timestamp'; 
	property name='Created' ormtype='timestamp';
	property name='Updated' ormtype='timestamp';
	property name="User" fieldtype="many-to-one" cfc="User" fkcolumn="UserFk";
	
	/**
 	* I initialise this component
	*/		
	UserSession function init(){
		return this;
	}

}