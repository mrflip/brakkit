'use strict';

/* App Module */

var brakkitApp = angular.module('brakkitApp', [
  'ngRoute',
  // 'ngDraggable',
  'ui.sortable',
  // 'brakkitAnimations',

  'brakkitControllers',
  'brakkitFilters',
  'brakkitServices'
]);

brakkitApp.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/items', {
        templateUrl: 'partials/item-list.html',
        controller: 'ItemListCtrl'
      }).
      when('/items/:itemId', {
        templateUrl: 'partials/item-detail.html',
        controller: 'ItemDetailCtrl'
      }).
      otherwise({
        redirectTo: '/items'
      });
  }]);

