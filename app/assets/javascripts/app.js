var app = angular.module('teddit', ['ui.router', 'templates', 'Devise']);

app.config([
'$stateProvider',
'$urlRouterProvider',
function($stateProvider, $urlRouterProvider) {

  $stateProvider
    .state('home', {
      url: '/home',
      templateUrl: 'home/_home.html',
      controller: 'HomeCtrl'
    })
    .state('users', {
      url: '/users/{id}',
      templateUrl: 'users/_user.html',
      controller: 'UsersCtrl',
      resolve: {
        user: ['$stateParams', 'usersService', function($stateParams, usersService) {
          return usersService.get($stateParams.id);
        }]
      }
    })
    .state('login', {
      url: '/login',
      templateUrl: 'auth/_login.html',
      controller: 'AuthCtrl',
      onEnter: ['$state', 'Auth', function($state, Auth) {
        Auth.currentUser().then(function (){
          $state.go('home');
        })
      }]
    })
    .state('register', {
      url: '/register',
      templateUrl: 'auth/_register.html',
      controller: 'AuthCtrl',
      onEnter: ['$state', 'Auth', function($state, Auth) {
        Auth.currentUser().then(function (){
          $state.go('home');
        })
      }]
    });

  $urlRouterProvider.otherwise('home');
}])
