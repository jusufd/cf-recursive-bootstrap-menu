component accessors="true" extends="models.abstract.BaseService"{

	property name="CategoryGateway" getter="false";

	/**
	 * I return the new order list after swapping the order
	*/
	public struct function swap( required numeric id, required string initVar, required numeric idNew ) {
		var result = {};
		transaction {
			var Category1 = variables.CategoryGateway.getCategory( arguments.id );
			var Category2 = variables.CategoryGateway.getCategory( arguments.idNew );
			if (!isnull(Category1) && !isnull(Category2)) {
				var CategoryParent = Category1.getParents();
				var CategoryParentId = '';
				if (!isnull(CategoryParent))
					CategoryParentId = CategoryParent.getId();	
				var CategorySection = Category1.getSection();
				var ProductCategory = Category1.getProductCategory();
				var SortOrder1 = Category1.getSortOrder();
				var SortOrder2 = Category2.getSortOrder();
				Category1.setSortOrder(SortOrder2);
				Category2.setSortOrder(SortOrder1);
				variables.CategoryGateway.save(Category1);
				variables.CategoryGateway.save(Category2);	
			}
		}
		if (!isnull(ProductCategory)) {
			result = getManageMenuProductCategory(parentId=CategoryParentId,initVar=arguments.initVar,section=CategorySection);	
		};		
		return result;	
	}
	/**
	 * I return the new order list after deleting the category
	*/
	public struct function deleteCategory( required numeric id, required string initVar ) {
		var result = {};
		transaction {
			var Category = variables.CategoryGateway.getCategory( arguments.Id );
			var CategoryParent = Category.getParents();
			var CategoryParentId = '';
			if (!isnull(CategoryParent))
				CategoryParentId = CategoryParent.getId();
			var CategorySection = Category.getSection();
			var ProductCategory = Category.getProductCategory();
			variables.CategoryGateway.deleteCategory(Category);
		}
		if (!isnull(ProductCategory))
			result = getManageMenuProductCategory(parentId=CategoryParentId,initVar=arguments.initVar,section=CategorySection);
		return result;		
	}
	/**
	 * I return the menu or product category information by id
	*/
	public struct function getMenuProductCategory( required numeric id, required string initVar, string section='go', numeric parentId=0 ) {
		var result = {"data"={}};
		if (arguments.initVar == 'menu')
			var Category = variables.CategoryGateway.getMenuCategory(arguments.id,arguments.section);
		else 
			var Category = variables.CategoryGateway.getProductCategory(arguments.id);
		if (isnull(Category.getId())) {
			/* New Category */
			Category.setProductCategory(true);
			Category.setSection(arguments.section);
			if (arguments.initVar == 'menu')
				Category.setProductCategory(false);
			if (arguments.parentId!=0) {
				if (arguments.initVar == 'menu')
					var parentCategory = variables.CategoryGateway.getMenuCategory(arguments.parentId,arguments.section);
				else 
					var parentCategory = variables.CategoryGateway.getProductCategory(arguments.parentId);
				var parentPathKey = parentCategory.getPathKey();
				var parentPath = parentCategory.getPath();
				Category.setPathKey(parentPathKey);
				Category.setPath(parentPath); 
			};		
		};	
		var temp = properties2struct(Category);
		if (!isnull(temp.Id)) 
			result.data = temp;
		var ParentsOfCategory = variables.CategoryGateway.getParentsOfCategory(Category,arguments.initVar);
		structinsert(result.data,'parentOptions',ParentsOfCategory);
		return result;
	}	
	/**
	 * I return the menu or product category list by product and section of menu
	*/
	public struct function getManageMenuProductCategory(required string initVar, string section='go', Any parentId) {
		var result = {
			"data" = 
			{
				"main" = [],
				"rootParent" = true,
				"parent" = {},
				"isHome" = false
			}
		};
		var ProductCategory = false;
		if (arguments.initVar == 'product')
			ProductCategory = true;
		structinsert(result.data,'isProductCategory',ProductCategory);	
		var queryResult = variables.CategoryGateway.QueryCategory
		(
			entitynew('Category',
			{
				"Parents" = arguments.parentId,
				"Section" = arguments.section,
				"ProductCategory" = ProductCategory
			}),'sortorder',arguments.initVar
		);
		if (len(arguments.parentId))
			var CategoryCurrent = variables.CategoryGateway.getCategory(arguments.parentId);
		else 
			var CategoryCurrent = variables.CategoryGateway.getCategory(0);
		if (arraylen(queryResult) > 0) {
			var level = 0;
			if (queryResult[1].hasParents()) {
				result.data.rootParent = false;
				level++;
				var CategoryCurrent = variables.CategoryGateway.getCategory(queryResult[1].getParents().getId());
				var idParent = "";
				if (CategoryCurrent.hasParents()) {
					idParent = CategoryCurrent.getParents().getId();
					level++;
				}	
				result.data.parent = {
					"Id" = idParent,
					"Id2" = queryResult[1].getParents().getId(),
					"Name" = '.. ' & '[' & CategoryCurrent.getName() & ']',
					"IsActive" = CategoryCurrent.getIsActive(),
					"ProductCategory" = CategoryCurrent.getProductCategory(),
					"SortOrder" = CategoryCurrent.getSortOrder(),
					"PathKey" = CategoryCurrent.getPathKey(),
					"Editable" = false,
					"Deleteable" = false,
					"Level" = 0
				};
				arrayappend(result.data.main,result.data.parent);
			}
			var prevId = '';
			var j = 2;
			if (arraylen(queryResult)>1) 
				var nextId = queryResult[j].getId();
			else 
				var nextId = '';
			for(i=1;i<=arraylen(queryResult);i++) {
				deletableStatus = true;
				editableStatus = true;
				if ( arraylen(variables.CategoryGateway.getKids(queryResult[i].getId())) )
					deletableStatus = false;
				if (!isnull(queryResult[i].getIsHome()))
					if (queryResult[i].getIsHome())
						deletableStatus = false;
				arrayappend(result.data.main,
				{
					"Id" = queryResult[i].getId(),
					"prevId" = prevId,
					"nextId" = nextId,
					"Name" = queryResult[i].getName(),
					"IsActive" = queryResult[i].getIsActive(),
					"IsHome" = queryResult[i].getIsHome(),
					"ProductCategory" = queryResult[i].getProductCategory(),
					"SortOrder" = queryResult[i].getSortOrder(),
					"PathKey" = queryResult[i].getPathKey(),
					"Editable" = editableStatus,
					"Deleteable" = deletableStatus,
					"Index" = i,
					"Size" = arraylen(queryResult),
					"Level" = level
				});
				j = j + 1;
				prevId = queryResult[i].getId();
				if (j <= arraylen(queryResult)) 
					nextId = queryResult[j].getId();
				else 
					nextId = '';
			}
	
		} 
		else
		{
			result.data.rootParent = false;
			var idParent = "";
			if (CategoryCurrent.hasParents()) 
				idParent = CategoryCurrent.getParents().getId();
				// if (!isnull(CategoryCurrent.getIsHome()))
				// 	result.data.isHome = true;	
			if (!isnull(CategoryCurrent.getIsHome()))
				result.data.isHome = CategoryCurrent.getIsHome();	
			if (!isnull(CategoryCurrent.getProductCategory()))
				result.data.isProductCategory = CategoryCurrent.getProductCategory();	
			result.data.parent = {
				"Id" = idParent,
				"Id2" = arguments.parentId,
				"Name" = '.. ' & '[' & CategoryCurrent.getName() & ']',
				"IsActive" = CategoryCurrent.getIsActive(),
				"ProductCategory" = CategoryCurrent.getProductCategory(),
				"SortOrder" = CategoryCurrent.getSortOrder(),
				"PathKey" = CategoryCurrent.getPathKey(),
				"Editable" = false,
				"Deleteable" = false,
				"Level" = 0
			};
			if (arguments.parentId>0)
				arrayappend(result.data.main,result.data.parent);
		}	
		return result;
	}
	/**
	 * I return the new information after saving the change category information
	*/
	public struct function saveCategory( required struct properties, required string context, required string selection ) {
		transaction {
			var result = variables.Validator.newresult();
			if (len(trim(arguments.properties.Id))==0)
				arguments.properties.Id = -1;
			if (len(trim(arguments.properties.Parents))==0)
				arguments.properties.Parents = -1;	
			var Category = variables.CategoryGateway.getCategory( arguments.properties.Id );
			populate(Entity=Category,memento=arguments.properties,exclude="Parents");
			
			var newParent = variables.CategoryGateway.getCategory(arguments.properties.Parents);
			var diffParent = false;
			if (structkeyexists(arguments.properties,'SubCategoryOf'))
				if (len(trim(arguments.properties.SubCategoryOf))>0)
					if (arguments.properties.SubCategoryOf!=arguments.properties.Parents) {
						var newParent = variables.CategoryGateway.getCategory(arguments.properties.SubCategoryOf);
						diffParent = true;
					}	
			if (!isnull(newParent.getId())) 
				Category.setParents(newParent);
			if (arguments.properties.Id==-1 || diffParent) {
				var lastSortOrder = variables.CategoryGateway.lastSortOrder(newParent.getId());
				Category.setSortOrder(lastSortOrder+1);
				if (isnull(newParent.getSection()))
					Category.setSection('go');
					/* for more than one section use this statement */
					// if (len(trim(arguments.selection))==0)
					// 	Category.setSection('go');
					// else 
					// 	Category.setSection(lcase(arguments.selection));
				else 
					Category.setSection(newParent.getSection());
			};
			var result = variables.Validator.validate( theObject=Category, context=arguments.context );
			resultCategory = Category;
			if( !result.hasErrors() ) {
				newCategory = variables.CategoryGateway.saveCategory(Category);
				resultCategory = newCategory;
				result.setSuccessMessage( "The category has been saved." );
			} else {
				result.setErrorMessage( "The category could not be saved. Please amend the highlighted fields." );
			}
			var resultForm = properties2struct(resultCategory);
			structinsert(result,'resultForm',resultForm);
		}	
		return result;
	}

}	