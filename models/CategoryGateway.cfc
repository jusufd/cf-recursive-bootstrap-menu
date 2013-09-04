component accessors="true" extends="models.abstract.BaseGateway"{

	/**
	* I return a product category matching an id
	*/		
	public Category function getProductCategory( required numeric id ){
		return getSingle( "Category",{id=arguments.id,ProductCategory=true});
	}
	/**
	* I return a menu category matching an id
	*/		
	public Category function getMenuCategory( required numeric id,required string section ){
		return getSingle( "Category",{id=arguments.id,ProductCategory=false,Section=arguments.section});
	}
	/**
	 * I save a category
	 */	
	Category function saveCategory( required Category theCategory ){
		var isPersisted = theCategory.isPersisted();
		var result = save( arguments.theCategory );
		if (!isPersisted)
			result = new( "Category" );
		return result;
	}
	/**
	 * I delete a category
	*/		 	
	public void function deleteCategory( required Category theCategory ){
		delete( arguments.theCategory );
	}
	/**
	* I return a menu category matching an id
	*/
	public array function getParentsOfCategory(required Category theCategory,required string initVar) {
		var result = [];
		if (theCategory.hasParents()) {
			var sqlParam = {};
			var parent = theCategory.getParents();
			if (parent.hasParents())
				var grandparent = parent.getParents();
			var sqlStatement = "from Category where 1=1";
			if (!parent.hasParents()) 
				sqlStatement = sqlStatement & ' and ParentFk IS NULL';
			else {
				sqlStatement = sqlStatement & ' and ParentFk = #grandparent.getId()#';
			}	
			sqlStatement = sqlStatement & ' and Section = :argSection';
			sqlStatement = sqlStatement &  ' and ProductCategory = :argProductCategory';
			sqlStatement = sqlStatement & ' and IsHome = null';
			structinsert(sqlParam,'argSection',parent.getSection());
			structinsert(sqlParam,'argProductCategory',false);
			if (arguments.initVar=='product')
				sqlParam.argProductCategory = true;
			result = ormExecuteQuery(sqlStatement,sqlParam);
		}	
		return result;
	}
	/**
	* I return a category matching an id
	*/		
	public Category function getCategory( required numeric id ){
		return get( "Category", arguments.id );
	}
	/**
	* I return all kids whose matching parent 
	*/
	public array function getKids(required numeric parentId) {
		var sqlStatement = 'from Category where 1=1';
		if (isnull(arguments.parentId)) 
			sqlStatement = sqlStatement & ' and ParentFk IS NULL';
		else
			sqlStatement = sqlStatement & ' and ParentFk = #arguments.parentId#';
		var result = ormExecuteQuery(sqlStatement);
		return result;
	}	
	/**
	* I return data from query 
	*/
	public array function QueryCategory( required Category theCategory, string sortorder='', string initVar='product') {
		var sqlStatement = 'from Category where 1=1';
		var sqlParam = {};
		if (!isnull(theCategory.getSection())) {
			sqlStatement = sqlStatement & ' and Section = :argSection';
			structinsert(sqlParam,'argSection',theCategory.getSection());
		}
		if (!isnull(theCategory.getIsActive())) {
			sqlStatement = sqlStatement & ' and IsActive = :argIsActive';
			structinsert(sqlParam,'argIsActive',theCategory.getIsActive());
		}
		if (!isnull(theCategory.getInNav())) {
			sqlStatement = sqlStatement &  ' and InNav = :argIsInNav';
			structinsert(sqlParam,'argIsInNav',theCategory.getInNav());
		}
		if (!isnull(theCategory.getInNavSecure())) {
			if (!theCategory.getInNavSecure()) { 
				sqlStatement = sqlStatement &  ' and InNavSecure = :argInNavSecure';
				structinsert(sqlParam,'argInNavSecure',theCategory.getInNavSecure());
			}	
		}

		if (arguments.initVar=='menu') {
			var parentId = theCategory.getParents();
			if (len(trim(parentId))==0 || isnull(parentId)) 
				sqlStatement = sqlStatement & ' and ParentFk IS NULL';
			else
			{
				sqlStatement = sqlStatement & ' and ParentFk = #parentId#';
				// structinsert(sqlParam,'argParents',parentId);
				if (!isnull(theCategory.getProductCategory())) {
					sqlStatement = sqlStatement &  ' and ProductCategory = :argProductCategory';
					structinsert(sqlParam,'argProductCategory',theCategory.getProductCategory());
				}
			}
		} else {
			if (!isnull(theCategory.getProductCategory())) {
				sqlStatement = sqlStatement &  ' and ProductCategory = :argProductCategory';
				structinsert(sqlParam,'argProductCategory',theCategory.getProductCategory());
			}
			var parentId = theCategory.getParents();
			if (len(trim(parentId))==0 || isnull(parentId)) 
				sqlStatement = sqlStatement & ' and ParentFk IS NULL';
			else
			{
				sqlStatement = sqlStatement & ' and ParentFk = #parentId#';
			} 
		}
		if (len(arguments.sortorder)) 
			sqlStatement = sqlStatement & ' order by #arguments.sortorder#';
		var result = ormExecuteQuery(sqlStatement,sqlParam);
		return result;
	}
	/**
	* I return the latest sort order number 
	*/
	public numeric function lastSortOrder( required any parentId = '' ) {
		var local = {};
		local.sqlStatement = 'from Category where 1=1';

		if (len(trim(arguments.parentId))==0) 
			local.sqlStatement = local.sqlStatement & ' and ParentFk IS NULL';
		else {
			local.sqlStatement = local.sqlStatement & ' and ParentFk = #arguments.parentId#';
		}
		local.sqlStatement = local.sqlStatement & ' order by sortorder DESC';
		local.result = 0;
		local.resultSet = ormExecuteQuery(local.sqlStatement,false,{maxResults=1});
		if (arraylen(local.resultSet)>0)
			local.result = local.resultSet[1].getSortOrder();
		return local.result;
	}

}	