PickUpCtrl = ($scope, $modalInstance, items)->
  $scope.items = items
  $scope.select = (item)->
    $modalInstance.close(item)

RowCtrl = ($scope, $modalInstance, navigations)->
  $scope.navigations = navigations
  $scope.selected = []
  $scope.select = (navigation)->
    if !!~$scope.selected.indexOf(navigation)
      $scope.selected.splice($scope.selected.indexOf(navigation), 1)
    else
      $scope.selected.push(navigation)
  $scope.ok = ->
    $modalInstance.close($scope.selected)

class GameRoutes extends Config
  constructor: (@$stateProvider) ->
    @$stateProvider
    .state("game",
      url: ""
      templateUrl: "app/game/board.tpl.html"
      controller: "GMController as gm"
    )

class GameService extends Factory
  constructor:  ->
    game = new Game

    return {
      game: game,
      gameController: new GameController(game),
      validator: new Validator(game),
      player: game.boat.seats[0],
      enemy: game.boat.seats[1],
      friend: game.boat.seats[2]
    }

class GM extends Controller
  constructor:($scope, $modal, GameService) ->
    @game = GameService.game
    @player = GameService.player
    @enemy = GameService.enemy
    @friend = GameService.friend

    @openItem = (item)->
      GameService.gameController.openItem(GameService.player, item)

    @openPickUpModal = ->
      pickUpModal = $modal.open({
        keyboard: false,
        backdrop: 'static',
        templateUrl: 'app/game/pickUpModal.tpl.html',
        controller: PickUpCtrl,
        resolve:
          items: ->
            GameService.game.pickItems()
      })
      pickUpModal.result.then (selectedItem) ->
        GameService.player.putUnderSeat selectedItem
      , ->
        console.log('Modal dismissed at: ' + new Date())

    @openRowModal = ->
      rowModal = $modal.open({
        keyboard: false,
        backdrop: 'static',
        templateUrl: 'app/game/rowModal.tpl.html',
        controller: RowCtrl,
        resolve:
          navigations: ->
            GameService.gameController.row(GameService.player)
      })
      rowModal.result.then (selected) ->
        GameService.gameController.rowedNavigation selected
      , ->
        console.log('Modal dismissed at: ' + new Date())


class GSurvivor extends Directive
  constructor: (GameService)->
    return {
    templateUrl: 'app/game/survivor.tpl.html',
    replace: true
    scope:
      survivor: '=gSurvivor'
    link: (scope, el, attr)->
      console.log scope.survivor
      scope.attack = (survivor)->
        GameService.gameController.attack GameService.player, survivor

      scope.relClass = 'neutral'
      if scope.survivor is GameService.enemy
        scope.relClass = 'enemy'
      if scope.survivor is GameService.player
        scope.relClass = 'you'
      if scope.survivor is GameService.friend
        scope.relClass = 'friend'
    }

class GCard extends Directive
  constructor:->
    return {
    templateUrl: 'app/game/card.tpl.html',
    replace: true
    scope:
      click: '=click',
      item: '=gCard'
    link: (scope, el, attr)->
    }
class GNavigation extends Directive
  constructor:->
    return {
    templateUrl: 'app/game/navigation.tpl.html',
    replace: true
    scope:
      click: '=click',
      navigation: '=gNavigation'
    link: (scope, el, attr)->
    }
class GFight extends Directive
  constructor:(GameService)->
    return {
    templateUrl: 'app/game/fight.tpl.html',
    replace: true
    scope:
      game: '=gFight',
    link: (scope, el, attr)->
      scope.joinDefenders = ->
        GameService.gameController.joinDefenders GameService.player
      scope.joinAttackers = ->
        GameService.gameController.joinAttackers GameService.player
      scope.inFight = ->
        GameService.validator.inFight GameService.player
    }
class GInvetory extends Directive
  constructor:->
    return {
    templateUrl: 'app/game/inventory.tpl.html',
    replace: true
    scope:
      items: '=gInventory',
      name: '@name',
      click: '=click'
    link: (scope, el, attr)->
    }