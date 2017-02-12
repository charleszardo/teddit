app.factory('subsService', ['$http', function($http) {
  var o = {};

  o.getAll = function() {
    return $http.get('/subs.json').then(function(success) {
      return success.data;
    })
  }

  o.get = function(id) {
    console.log(id);
    return $http.get('/subs/' + id + '.json').then(function(success) {
      return success.data;
    })
  }

  return o;
}]);
