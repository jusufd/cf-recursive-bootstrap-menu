component persistent="true" table="Categories" hint="Product Categories include menu" {
	property name="Id" fieldtype="id" column="CategoryPk" generator="native" unsavedvalue="-1";
	property name="Name" length="50" notnull="true";
	property name="Path" length="50" notnull="false";
	property name="PathKey" length="255" notnull="false";
	property name="SortOrder" ormtype="integer";
	property name="Section" length="10";
	property name="IsActive" ormtype="true_false";
	property name="Description" length="255";
	property name="MetaTitle" length="128";
	property name="MetaDescription" length="255";
	property name="MetaKeyword" length="128";
	property name="ProductCategory" ormtype="true_false" notnull="true";
	property name="InNav" ormtype="true_false";
	property name="InNavSecure" ormtype="true_false";
	property name="IsHome" ormtype="true_false";
	property name='Created' ormtype='timestamp';
	property name='Updated' ormtype='timestamp';
	property name="Parents" fieldtype="many-to-one" cfc="Category" fkcolumn="ParentFk";
	
	/**
 	* I initialise this component
	*/		
	Category function init(){
		return this;
	}
	/**
	 * I return true if the name is unique in the same level
	 */		
	public struct function isNameUnique(){
		var matches = []; 
		var result = {issuccess=false, failuremessage="The name '#variables.Name#' has been used." };
		if (isPersisted()) 
			if (!isnull(variables.Parents))
				matches = ORMExecuteQuery("from Category where Id<>:Id and Name=:Name and Parents=:Parents",{ Id=variables.Id, Name=variables.Name, Parents=variables.Parents });
			else 
				matches = ORMExecuteQuery("from Category where Id<>:Id and Name=:Name and Parents IS NULL",{ Id=variables.Id, Name=variables.Name });
		else 
			if (!isnull(variables.Parents))
				matches = ORMExecuteQuery("from Category where Name=:Name and Parents=:Parents",{ Name=variables.Name, Parents=variables.Parents } );
			else 
				matches = ORMExecuteQuery("from Category where Name=:Name and Parents IS NULL",{ Name=variables.Name } );	
		if (!ArrayLen(matches)) 
			result.issuccess = true;
		return result;
	}
	/**
	 * I return true if the category is persisted
	 */	
	boolean function isPersisted(){
		if (variables.Id==-1)
			return false;
		else 
			return true;
	}
}	