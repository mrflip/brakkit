'use strict';

/* Controllers */

var brakkitControllers = angular.module('brakkitControllers', []);

brakkitControllers.controller('ItemListCtrl', ['$scope', 'Item',
  function($scope, Item) {
    $scope.items = Item.query();
    $scope.orderProp = 'age';

    $scope.sortableOptions = {
      // itemMoved:    function (event){ },
      stop: function(ev, ui){
        $.each($scope.items, function(ii, obj){ obj.idx = ii; });
        console.log( ['reordered', ev, ui, $scope.items] ); }
    };
   
  }]);

brakkitControllers.controller('ItemDetailCtrl', ['$scope', '$routeParams', 'Item',
  function($scope, $routeParams, Item) {
    $scope.item = Item.get({itemId: $routeParams.itemId}, function(item) {
      $scope.mainImageUrl = item.images[0];
    });

    $scope.setImage = function(imageUrl) {
      $scope.mainImageUrl = imageUrl;
    }
  }]);
