app.controller('SubsCtrl', ['$scope', 'subsService', 'subs', function($scope, subsService, subs) {
  $scope.subs = subs;

  $scope.addSub =

  $scope.addSub = function () {
      if ($scope.body === '' || $scope.description === '') { return; }

      subsService.create(
        { title: $scope.title,
          description: $scope.description
        }).then(function(success) {
          console.log(success);
          $scope.subs.push(success);
        })

      $scope.body === '';
      $scope.description === '';
    }
}]);
