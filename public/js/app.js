'use strict';

var app = angular.module('NorthWindDemo', ['ui.router']);

app.item_types = ['customers', 'suppliers', 'products', 'orders', 'employees', 'categories'];

app.run(function ($rootScope) {

    $rootScope.item_types = app.item_types;    

    $rootScope.theme = {
        'customers' : '428bca',
        'suppliers' : '395756',
        'products'  : '474350',
        'orders'    : 'd2b6e1',
        'employees' : '242038',
        'categories': 'ff9e70'
    };

    $rootScope.table_headers = {
        'customers' : ['Customer Code', 'Company'],
        'suppliers' : ['ID', 'Name'],
        'products'  : ['ID', 'Product', 'Price'],
        'orders'    : ['ID', 'Shipped By'],
        'employees' : ['ID', 'First Name', 'Last Name', 'Title'],
        'categories': ['ID', 'Name', 'Description']
    };

    $rootScope.item_properties = {
        'customers' : ['customerID', 'companyName'],
        'suppliers' : ['supplierID', 'companyName'],
        'products'  : ['productID', 'productName', 'unitPrice'],
        'orders'    : ['orderID', 'shipName'],
        'employees' : ['employeeID', 'firstName', 'lastName', 'title'],
        'categories': ['categoryID', 'categoryName', 'description']
    };    

    $rootScope.item_id_property = {
        'customers' : 'customerID',
        'suppliers' : 'supplierID',
        'products'  : 'productID',
        'orders'    : 'orderID',
        'employees' : 'employeeID',
        'categories': 'categoryID'
    };  

    $rootScope.generate_sref = function(item, item_type){
        var sref  = item_type + ".details({item_id: '";
        sref += item[$rootScope.item_id_property[item_type]];
        return sref + "'})";
    };
});


app.singular_form = function(item_type){
    if(item_type == 'categories'){
        return 'category';
    }
    if(item_type[item_type.length - 1] == 's'){
        return item_type.substring(0, item_type.length - 1);
    } else {
        return item_type;
    }
};


/*
 * get_url can be one of the following:
 * 1. Null - We'll use '/item_type'.
 * 2. String - Use this string as a URL.
 * 3. Function(stateParams) that returns a URL as a string. 
 */
app.create_list_items_controller = function(item_type, header, get_url){
    return function($scope, $http, $stateParams){
        $scope.item_type = item_type;
        $scope.header = header;
        $scope.items = [];

        get_url = get_url || ('/' + item_type);
        if(typeof(get_url) == 'function'){
            get_url = get_url($stateParams);
        }

        $http.get(get_url)
            .success(function(data) {
                console.log("Response from '" + get_url + "': ", data);
                for (var i = 0; i < data.length; i++) {
                    $scope.items.push(data[i]);
                }
            })
            .error(function(data, status, headers, config) {
                console.log("Cannot list " + item_type, data, status, headers, config);
            });
    };
};



app.create_details_items_controller = function(item_type){
    return function($scope, $stateParams, $http) {
        var t = app.singular_form(item_type);
        $scope[t] = {};

        var item_id = $stateParams.item_id;
        
        $http.get(item_type + '/' + item_id)
            .success(function(data, status, headers, config) {
                $scope[t] = data;
            })
            .error(function(data, status, headers, config) {
                console.log("Cannot get " + item_type + " " + item_id, data, status, headers, config);
            });
    };
};
    




app.config(function($stateProvider, $urlRouterProvider) {
    
    $urlRouterProvider.otherwise('/');
    
    $stateProvider.state('home', {
        url: '/',
        templateUrl: 'templates/home.html'
    });


    // Create the list and details states for all item types ...
    for (var i = 0; i < app.item_types.length; i++) {
        var item_type = app.item_types[i];

    	// Abstract state, for each of customers/orders/products/suppliers
    	$stateProvider.state(item_type, {
    		url: '/' + item_type,
            template: '<div ui-view></div>',
        });

        $stateProvider.state(item_type + '.list', {
            url: '/list',
            templateUrl: 'templates/list.html',
            controller: app.create_list_items_controller(item_type, item_type)
        });

        $stateProvider.state(item_type + '.details', {
    		url: '/details/:item_id',
    		templateUrl: 'templates/details/' + app.singular_form(item_type) + '.html',
    		controller: app.create_details_items_controller(item_type)
    	});
    }




    $stateProvider.state('customers.suggest_products', {
        url: '/:item_id/suggest_products',
        views : {

            '' : {
                templateUrl: 'templates/customer.html',
                controller: app.create_details_items_controller('customers')
            },

            'table1@customers.suggest_products' : {
                templateUrl: 'templates/list.html',
                controller: app.create_list_items_controller('products', 'Suggested Products', 
                    function(stateParams) {
                        return '/customers/' + stateParams['item_id'] + '/suggest_products';
                    })
            }
        }
    });


    $stateProvider.state('customers.orders', {
        url: '/:item_id/orders',
        views : {

            '' : {
                templateUrl: 'templates/customer.html',
                controller: app.create_details_items_controller('customers')
            },

            'table1@customers.orders' : {
                templateUrl: 'templates/list.html',
                controller: app.create_list_items_controller('orders', 'Order History', 
                    function(stateParams) {
                        return '/customers/' + stateParams['item_id'] + '/orders';
                    })
            }
        }
    });


    $stateProvider.state('customers.favorite_sales_staff', {
        url: '/:item_id/favorite_sales_staff',
        views : {

            '' : {
                templateUrl: 'templates/customer.html',
                controller: app.create_details_items_controller('customers')
            },

            'table1@customers.favorite_sales_staff' : {
                templateUrl: 'templates/list.html',
                controller: app.create_list_items_controller('employees', 'Favorite Sales Staff', 
                    function(stateParams) {
                        return '/customers/' + stateParams['item_id'] + '/favorite_sales_staff';
                    })
            }
        }
    });


    $stateProvider.state('customers.favorite_products', {
        url: '/:item_id/favorite_products',
        views : {

            '' : {
                templateUrl: 'templates/customer.html',
                controller: app.create_details_items_controller('customers')
            },

            'table1@customers.favorite_products' : {
                templateUrl: 'templates/list.html',
                controller: app.create_list_items_controller('products', 'Frequently Purchased Products', 
                    function(stateParams) {
                        return '/customers/' + stateParams['item_id'] + '/favorite_products';
                    })
            }
        }
    });


    
    

});






// =============================================================================
// Summary items (i.e. The circles at the top of the page, containing counts)

app.directive('summaryItems', function(){
	return {
		restrict: 'EA',
		replace: false,
		templateUrl: 'templates/summary-items.html',
	};
});

app.controller('SummaryItemsCtrl', function($scope, $http) {

    $scope.counts = {};

    var create_callback = function(item_type, is_success){
         return function(data) {
             $scope.counts[item_type] = is_success ? data : 'N/A';
         }
    };

    for (var i = 0; i < $scope.item_types.length; i++) {
        var item_type = $scope.item_types[i];
         $http.get('/' + item_type + '/count')
             .success(create_callback(item_type, true))
             .error(  create_callback(item_type, false));
    }
});

// =============================================================================