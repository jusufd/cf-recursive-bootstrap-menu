categorygen.factory('ProductCategories',['gatewayCategory',function(gatewayCategory) {
    var ProductCategoriesService = {};

    var data;

    var categories = function(pid,initvar,selection) {
        var params = {};
        if (typeof pid == 'undefined')
            params.pid = '';
        else
            params.pid = pid;
        params.action = 'admin.category';
        if (typeof selection != 'undefined')
             params[selection] = '';
        params[initvar] = true; 
        params.json = '';
        data = gatewayCategory.get(params);
        return data;
    };

    // var menu = function(pid,selection) {
    //     var params = {};
    //     if (typeof pid == 'undefined')
    //         params.pid = '';
    //     else
    //         params.pid = pid;
    //     params.action = 'admin.menu';
    //     params[selection] = '';
    //     params.json = '';
    //     data = gatewayCategory.get(params);
    //     return data;
    // };

    var oneCategory = function(pid,initvar,selection,parentId) {
        var params = {};
        if (typeof pid == 'undefined')
            params.pid = '';
        else
            params.pid = pid;
        if (typeof parentId != 'undefined')
            params.parentId = parentId;
        params.action = 'admin.category';
        // if (typeof selection != 'undefined')
        //      params[selection] = '';
        if (selection!='')
            params[selection] = '';
        params[initvar] = true;
        params.one = '1'; 
        params.json = '';
        data = gatewayCategory.get(params);
        return data;
    }

    var saveCategory = function(params) {
        data = gatewayCategory.save(params);
        return data; 
    }

    var deleteCategory = function(params) {
        data = gatewayCategory.getId(params);
        return data; 
    }

    return {
        getCategories: function(pid) {
           return categories(pid,'product'); 
        },
        getMenu: function(pid,selection) {
           return categories(pid,'menu',selection); 
        },
        getOneCategory: function(pid,parentId) {
           return oneCategory(pid,'product','',parentId); 
        },
        getOneMenu: function(pid,parentId,selection) {
           return oneCategory(pid,'menu',selection,parentId); 
        },
        saveCategory: function(params) {
            return saveCategory(params);
        },
        deleteCategory: function(params) {
            return deleteCategory(params);  
        }
    };

}]);    

// store1Admin.factory('ProductCategories',['$resource',function($resource) {
//     return $resource('/store2railo' + "/index.cfm", 
//             {}, 
//             {
//                 getcategory: 
//                 { 
//                     method: "GET",
//                     pid: "@pid",
//                     action: "@action",
//                     json: "@json"   
//                 }
//             }
//         );
// }]);