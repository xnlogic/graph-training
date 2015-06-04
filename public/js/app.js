'use strict';

var app = angular.module('NorthWindDemo', ['ui.router']);


app.config(function($stateProvider, $urlRouterProvider) {
    
    $urlRouterProvider.otherwise('/');
    
    $stateProvider
        
        .state('home', {
            url: '/',
            templateUrl: 'templates/home.html'
        })
        
        .state('customers', {
            templateUrl: 'templates/customers.html',
            controller: function($scope, $http) {
            	$scope.customers = [];

            	$http.get('customers')
            		.success(function(data, status, headers, config) {
            			for (var i = 0; i < data.length; i++) {
            				$scope.customers.push(data[i]);
            				// console.log(data[i]);
            			}
            		})
            		.error(function(data, status, headers, config) {
            			console.log("Cannot get customers ... ", data, status, headers, config);
            		});
        	}
        })

        .state('suppliers', {
            templateUrl: 'templates/suppliers.html'
        })

        .state('products', {
            templateUrl: 'templates/products.html'
        })

        .state('orders', {
            templateUrl: 'templates/orders.html'
        });
});






app.directive('summaryItems', function(){
	return {
		restrict: 'EA',
		replace: false,
		templateUrl: 'templates/summary-items.html',
	};
});


app.controller('SummaryItemsCtrl', function($scope, $http) {
	
	$scope.items = [
		{color: '428bca', label: 'customers'},
		{color: '395756', label: 'suppliers'},
		{color: '474350', label: 'products'},
		{color: 'd2b6e1', label: 'orders'}
	];

	var create_callback = function(i, is_success){
		return function(data, status, headers, config) {
			$scope.items[i].text = is_success ? (data + '') : 'N/A';
		}
	};

	for (var i = 0; i < $scope.items.length; i++) {
    	$http.get($scope.items[i].label + '/count')
			.success(create_callback(i, true))
			.error(create_callback(i, false));
	}

});


