categorygen.controller('ProductCategoryListController',['$scope','$window','ProductCategories',function($scope,$window,ProductCategories) 
{
	$scope.init = function(categorySelection,selection) {
		$scope.categorySelection = categorySelection;
		if ($scope.categorySelection=='product')  
			var result = ProductCategories.getCategories();
		else if ($scope.categorySelection=='menu') 
			var result = ProductCategories.getMenu('',selection);
		$scope.categories = result;
		$scope.openCategory = function(pid) {
			if ($scope.categorySelection=='product') 
				var result = ProductCategories.getCategories(pid);
			else if ($scope.categorySelection=='menu') 
				var result = ProductCategories.getMenu(pid,selection);
			$scope.categories = result;
		};
		$scope.arrowUp = function(idprev,id) {
			var params = {};
			params.Id = id;
			params.newId = idprev;
			params.action = 'admin.UpDownCategory';
			params.initvar = categorySelection;
			params.json = '';
			result = ProductCategories.saveCategory(params);
			$scope.categories = result;
		};
		$scope.arrowDown = function(idnext,id) {
			var params = {};
			params.Id = id;
			params.newId = idnext;
			params.action = 'admin.UpDownCategory';
			params.initvar = categorySelection;
			params.json = '';
			result = ProductCategories.saveCategory(params);
			$scope.categories = result;
		};
		$scope.editCategory = function(pid) {
			// $window.alert('edit category');
			if (categorySelection=='product') {
				var result = ProductCategories.getOneCategory(pid);
				$scope.titleCategoryWindow = "Edit Product Category";
			} else {
				var result = ProductCategories.getOneMenu(pid,undefined,selection);
				$scope.titleCategoryWindow = "Edit " + selection + " Menu Option";
			}
			$scope.category = result;
			// $scope.modalCategory = true;
			$('#modalCategory').modal('show');	
		};
		$scope.addCategory = function(parentId) {
			if (categorySelection=='product') {
				var result = ProductCategories.getOneCategory(0,parentId);
				$scope.titleCategoryWindow = "Add Product Category";
			} else {
				var result = ProductCategories.getOneMenu(0,parentId,selection);
				$scope.titleCategoryWindow = "Add " + selection + " Menu Option";
			}	
			$scope.category = result;
			// $scope.modalCategory = true;
			$('#modalCategory').modal('show');	
		};
		$scope.addProduct = function() {

		};
		$scope.deleteCategory = function(id) {
			var params = {};
			params.id = id;
			params.action = 'admin.deletecategory';
			params.initvar = categorySelection;
			params.json = '';
			result = ProductCategories.deleteCategory(params);
			$scope.categories = result;
		};
		$scope.saveCategory = function(pid,id) {
			var params = {};
			params.Name = $scope.category.data.Name;
			params.Path = $scope.category.data.Path;
			params.PathKey = $scope.category.data.PathKey;
			params.MetaTitle = $scope.category.data.MetaTitle;
			params.MetaDescription = $scope.category.data.MetaDescription;
			params.MetaKeyword = $scope.category.data.MetaKeyword;
			params.Description = $scope.category.data.Description;
			params.IsActive = $scope.category.data.IsActive;
			params.InNav = $scope.category.data.InNav;
			params.InNavSecure = $scope.category.data.InNavSecure;
			params.SubCategoryOf = $scope.category.data.Parents.Id;
           	params.Parents = pid;
            params.Id = id;
            params.action = 'admin.savecategory';
            if (categorySelection=='product')
            	params.ProductCategory = 'Yes';	
            else
            	params.ProductCategory = 'No';
            // if (categorySelection=='menu') 
            // 	params[selection] = '';
            params.json = '';
            console.log(params);
			result = ProductCategories.saveCategory(params);
			$scope.category = result;
		};
		$scope.modalCategoryClose = function(pid) {
			$scope.openCategory(pid);
		}
	} 
}]);