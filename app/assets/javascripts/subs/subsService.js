app.factory('subsService', ['$http', function($http) {
  var o = {};

  o.getAll = function() {
    return $http.get('/subs.json').then(function(success) {
      return success.data;
    })
  }

  o.get = function(id) {
    return $http.get('/subs/' + id + '.json').then(function(success) {
      return success.data;
    })
  }

  o.create = function(data) {
    return $http.post('/subs', data).then(function(success) {
      return success.data;
    })
  }

  return o;
}]);
