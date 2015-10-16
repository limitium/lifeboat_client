class BaseRoutes extends Config
  constructor: (@$stateProvider) ->
#    @$stateProvider
#    .state("home",
#      url: ""
#      templateUrl: "/components/home.html"
#    )

class Main extends Controller
  constructor: () ->


class App extends App
  constructor: ->
    return ['ui.router', 'angularMoment', 'ngResource', 'ui.bootstrap', 'ngSanitize']


