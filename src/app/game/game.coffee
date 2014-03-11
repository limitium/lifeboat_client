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

angular
  .module("ngBoilerplate.game", [
    "ui.bootstrap",
    "ui.state",
    "lvl.directives.dragdrop"
  ])
  .config(
    ($stateProvider) ->
      $stateProvider.state "game",
        url: "/game"
        views:
          main:
            controller: "GameCtrl"
            templateUrl: "game/board.tpl.html"

        data:
          pageTitle: "Game"

  )
  .factory('GameService', ->
    game = new Game

    game: game,
    gameController: new GameController(game),
    validator: new Validator(game),
    player: game.boat.seats[0],
    enemy: game.boat.seats[1],
    friend: game.boat.seats[2]
  )
  .controller("GameCtrl", ($scope, $modal, GameService) ->
    $scope.game = GameService.game
    $scope.player = GameService.player
    $scope.enemy = GameService.enemy
    $scope.friend = GameService.friend

    $scope.openItem = (item)->
      GameService.gameController.openItem(GameService.player, item)

    $scope.openPickUpModal = ->
      pickUpModal = $modal.open({
        keyboard: false,
        backdrop: 'static',
        templateUrl: 'game/pickUpModal.tpl.html',
        controller: PickUpCtrl,
        resolve:
          items: ->
            GameService.game.pickItems()
      })
      pickUpModal.result.then (selectedItem) ->
        GameService.player.putUnderSeat selectedItem
      , ->
        console.log('Modal dismissed at: ' + new Date())

    $scope.openRowModal = ->
      rowModal = $modal.open({
        keyboard: false,
        backdrop: 'static',
        templateUrl: 'game/rowModal.tpl.html',
        controller: RowCtrl,
        resolve:
          navigations: ->
            GameService.gameController.row(GameService.player)
      })
      rowModal.result.then (selected) ->
        GameService.gameController.rowedNavigation selected
      , ->
        console.log('Modal dismissed at: ' + new Date())

  )
  .directive('survivor', (GameService)->
    templateUrl: 'game/survivor.tpl.html',
    replace: true
    scope:
      survivor: '=survivor'
    link: (scope, el, attr)->
      scope.attack = (survivor)->
        GameService.gameController.attack GameService.player, survivor

      scope.relClass = 'neutral'
      if scope.survivor is GameService.enemy
        scope.relClass = 'enemy'
      if scope.survivor is GameService.player
        scope.relClass = 'you'
      if scope.survivor is GameService.friend
        scope.relClass = 'friend'

  )
  .directive('card', ->
    templateUrl: 'game/card.tpl.html',
    replace: true
    scope:
      click: '=click',
      item: '=card'
    link: (scope, el, attr)->
  )
  .directive('navigation', ->
    templateUrl: 'game/navigation.tpl.html',
    replace: true
    scope:
      click: '=click',
      navigation: '=navigation'
    link: (scope, el, attr)->
  )
  .directive('fight', (GameService)->
    templateUrl: 'game/fight.tpl.html',
    replace: true
    scope:
      game: '=fight',
    link: (scope, el, attr)->
      scope.joinDefenders = ->
        GameService.gameController.joinDefenders GameService.player
      scope.joinAttackers = ->
        GameService.gameController.joinAttackers GameService.player
      scope.inFight = ->
        GameService.validator.inFight GameService.player
  )
  .directive('inventory', ->
    templateUrl: 'game/inventory.tpl.html',
    replace: true
    scope:
      items: '=inventory',
      name: '@name',
      click: '=click'
    link: (scope, el, attr)->
  )
