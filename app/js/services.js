'use strict';

/* Services */

var brakkitServices = angular.module('brakkitServices', ['ngResource']);

brakkitServices.factory('Item', ['$resource',
  function($resource){
    return $resource('items/:itemId.json', {}, {
      query: {method:'GET', params:{itemId:'items'}, isArray:true}
    });
  }]);
