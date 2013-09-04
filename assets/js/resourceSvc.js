// product category
categorygen.factory('gatewayCategory',['$resource',function($resource) {
    return $resource(pathActive + "/index.cfm", 
    	{}, 
    	{
        	get: 
            { 
                method: "GET",
                action: "@action",
                json: "@json", 
                pid: "@pid"   
            },
            getId: 
            { 
                method: "GET",
                action: "@action",
                json: "@json", 
                id: "@id"   
            },
            save:
            {
                method: "POST",
                action: "@action",
                json: "@json"
            }
    	});
}]);
