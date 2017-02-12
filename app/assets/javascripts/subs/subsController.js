app.controller('SubsCtrl', ['$scope', 'subsService', function($scope, subsService) {
  subsService.getAll().then(function(success){
    $scope.subs = success;
  });
}]);
