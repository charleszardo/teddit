app.factory('subsService', ['$http', function($http) {
  var o = {};

  o.getAll = function() {
    return $http.get('/subs.json').then(function(success) {
      return success.data;
    })
  }

  return o;
}]);
