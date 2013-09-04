pathActive = ''
var categorygen = angular.module('CategoryGenApp', ['ngResource']).config(
	function($routeProvider,$locationProvider,$httpProvider) 
	{
		$routeProvider.when('/');
		$httpProvider.defaults.headers.post  = {'Content-Type': 'application/x-www-form-urlencoded'};
		$httpProvider.defaults.transformRequest = function(data) {
        	return data != undefined ? $.param(data) : null;
    	}
	}
);