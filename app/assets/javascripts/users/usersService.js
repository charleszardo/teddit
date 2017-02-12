app.factory('usersService', ['$http', function($http){
  var o = {};
  
  o.get = function(id) {
    return $http.get('/users/' + id + '.json').then(function(success) {
      return success.data;
    });
  };

  return o;
}])
