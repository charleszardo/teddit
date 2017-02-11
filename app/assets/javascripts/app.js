var app = angular.module('teddit', ['ui.router', 'templates', 'Devise']);

app.controller('MainCtrl', [function() {

}]);

app.controller('NavCtrl', [
'$scope',
'Auth',
function($scope, Auth){
  $scope.signedIn = Auth.isAuthenticated;
  $scope.logout = Auth.logout;

  Auth.currentUser().then(function (user){
  $scope.user = user;
});

$scope.$on('devise:new-registration', function (e, user){
  $scope.user = user;
});

$scope.$on('devise:login', function (e, user){
  $scope.user = user;
});

$scope.$on('devise:logout', function (e, user){
  $scope.user = {};
});
}]);

app.config([
'$stateProvider',
'$urlRouterProvider',
function($stateProvider, $urlRouterProvider) {

  $stateProvider
    .state('home', {
      url: '/home',
      templateUrl: 'home/_home.html',
      controller: 'MainCtrl'
    });

  $urlRouterProvider.otherwise('home');
}])
