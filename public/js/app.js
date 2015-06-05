'use strict';

var app = angular.module('NorthWindDemo', ['ui.router']);


app.config(function($stateProvider, $urlRouterProvider) {
    
    $urlRouterProvider.otherwise('/');
    
    $stateProvider.state('home', {
        url: '/',
        templateUrl: 'templates/home.html'
    });



    // Setup ls states...
    // That is, states that simply list all items in a table

    var ls_setup_data = [
    	['customers', ['Customer Code', 'Company'], ['customerID', 'companyName'] ], 
    	['suppliers', ['ID', 'Name']              , ['supplierID', 'companyName'] ],
    	['products' , ['ID', 'Product', 'Price']  , ['productID', 'productName', 'unitPrice'] ], 
    	['orders'   , ['ID', 'Shipped By']        , ['orderID', 'shipName'] ]
    ];

    var create_list_controller = function(label, get_url, table_headers, item_properties, item_id_property){
    	return function($scope, $http) {
            $scope.items = [];
            $scope.label = label;
            $scope.table_headers = table_headers;
            $scope.item_properties = item_properties;
            $scope.item_id_property = item_id_property;

            $http.get(get_url)
            	.success(function(data, status, headers, config) {
        			for (var i = 0; i < data.length; i++) {
        				$scope.items.push(data[i]);
        			}
            	})
        		.error(function(data, status, headers, config) {
        			console.log("Cannot get " + label + " ... ", data, status, headers, config);
        		});
        };
    };


    var create_details_controller = function(state){
    	return function($scope, $stateParams, $http) {
    		var type = state.substring(0, state.length - 1);
    		$scope[type] = {};
    		var item_id = $stateParams.item_id;
    		
            $http.get(state + '/' + item_id)
            	.success(function(data, status, headers, config) {
        			$scope[type] = data;
            	})
        		.error(function(data, status, headers, config) {
        			console.log("Cannot get " + type + " " + item_id, data, status, headers, config);
        		});
        };
    };

    for (var i = 0; i < ls_setup_data.length; i++) {
    	var state = ls_setup_data[i][0];
    	var table_headers = ls_setup_data[i][1];
    	var item_properties = ls_setup_data[i][2];

    	// Abstract state, for each of customers/orders/products/suppliers
    	$stateProvider.state(state, {
    		url: '/' + state,
            template: '<div ui-view></div>',
        });

        $stateProvider.state(state + '.list', {
    		url: '/list',
            templateUrl: 'templates/ls.html',
            controller: create_list_controller(state, state, table_headers, 
                item_properties, state.substring(0, state.length - 1) + 'ID')
        });

        $stateProvider.state(state + '.details', {
    		url: '/details/:item_id',
    		templateUrl: 'templates/' + state.substring(0, state.length - 1) + '.html',
    		controller: create_details_controller(state)
    	});
    }
    

    $stateProvider.state('customers.suggest_products', {
		url: '/suggested_products/:customer_id',
		templateUrl: 'templates/ls.html',
		controller: function($scope, $stateParams, $http){
            console.log('state params', $stateParams);
            $scope.items = [];
            $scope.label = 'products';
            $scope.table_headers = ['ID', 'Product', 'Price'];
            $scope.item_properties = ['productID', 'productName', 'unitPrice'];
            $scope.item_id_property = 'productID';

            $http.get('/customers/' + $stateParams['customer_id'] + '/suggest_products')
                .success(function(data, status, headers, config) {
                    console.log("Got back " + data.length + " suggested products", data);

                    for (var i = 0; i < data.length; i++) {
                        $scope.items.push(data[i]);
                    }
                })
                .error(function(data, status, headers, config) {
                    console.log("Cannot get suggested products ... ", data, status, headers, config);
                });
        }
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


