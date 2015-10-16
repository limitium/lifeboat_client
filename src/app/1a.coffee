class LifeBoat
  constructor: (@seats) ->
  fistLive: ->
    _.first @seats


class Survivor
  constructor: (@name, @strength)->
    @hp = @strength
    @isRowed = false
    @isFought = false
    @wounds = 0
    @items = []
    @underSeat = []
  getTotalStrength: ->
    @strength + @getBonus()
  getBonus: ->
    @items.reduce (bonus, item)->
      bonus + item.getBonus()
    ,
      0
  putInItems: (item)->
    @items.push item
  putUnderSeat: (item)->
    @underSeat.push item
  removeFromUnderSeat: (item)->
    @underSeat.splice(@underSeat.indexOf(item), 1)
  removeFromItems: (item)->
    @items.splice(@items.indexOf(item), 1)
  getSurviveBonus: ->
    12 - @strength

class Item
  constructor: (@name, @bonus = 0)->
  getBonus: ->
    @bonus

class Navigation
  constructor: (@overboard, @thristy, @fight = false, @row = false, @bird = 0)->

class Fight
  constructor: (attacker, defender)->
    @attackers = []
    @defenders = []
    @attackers.push attacker
    @defenders.push defender
  joinAttackers: (suriviver)->
    @attackers.push suriviver
  joinDefenders: (suriviver)->
    @defenders.push suriviver
  getTotalStrength: (side)->
    side.reduce (strength, suriviver) ->
      strength + suriviver.getTotalStrength()
    ,
      0

  getAttackersStrength: ->
    @getTotalStrength(@attackers)
  getDefendersStrength: ->
    @getTotalStrength(@defenders)
  isAttackersWin: ->
    @getAttackersStrength() > @getDefendersStrength()

class Game
  constructor: ->
    @totalTurns = 0
    @currentPlayer = null
    @phase = ''
    @fight = null
    @birds = 0
    @navigationStack = []

    @survivors =
      lady_lauren: new Survivor 'lady_lauren', 4
      sir_stephen: new Survivor 'sir_stephen', 5
      frenchy: new Survivor 'frenchy', 6
      the_captain: new Survivor 'the_captain', 7
      first_mate: new Survivor 'first_mate', 8
      the_kid: new Survivor 'the_kid', 3

    @items = []
    @shuffleItems()
    @navigations = []
    @shuffleNavigation()

    @boat = new LifeBoat [
      @survivors.lady_lauren,
      @survivors.sir_stephen,
      @survivors.frenchy,
      @survivors.the_captain,
      @survivors.first_mate,
      @survivors.the_kid
    ]
    @nextTurn()

  nextTurn: ->
    if @birds == 3
      alert('end')

    @totalTurns += 1
    @phase = 'item_pick'
    @currentPlayer = @boat.fistLive()
  shuffleItems: ->
    items = []
    items.push new Item('oar', 1)
    items.push new Item('blackjack', 2)
    items.push new Item('knife', 3) for [1..6]
    items.push new Item('hook', 4)
    items.push new Item('flare_gun', 8)
    items.push new Item('water') for [1..16]
    items.push new Item('medkit') for [1..3]
    items.push new Item('bucket_chum') for [1..2]
    items.push new Item('jewels') for [1..3]
    items.push new Item('painting') for [1..3]
    items.push new Item('cash') for [1..6]
    items.push new Item('compas')
    items.push new Item('life_preserver')
    items.push new Item('parasol')
    @items.length = 0
    @items.push item for item in _.shuffle(items)

  shuffleNavigation: ->
    navigations = []
    navigations.push new Navigation(
      ['lady_lauren',
       'sir_stephen',
       'frenchy',
       'the_captain',
       'first_mate',
       'the_kid'],
      ['lady_lauren',
       'sir_stephen',
       'frenchy', 'the_captain',
       'first_mate',
       'the_kid'],
      true, true, 1)
    navigations.push new Navigation(
      ['lady_lauren',
       'sir_stephen',
       'frenchy',
       'the_captain',
       'first_mate',
       'the_kid'],
      ['lady_lauren',
       'sir_stephen',
       'frenchy',
       'the_captain',
       'first_mate',
       'the_kid'],
      true)
    navigations.push new Navigation(
      [],
      [],
      false, false, 1)
    navigations.push new Navigation(
      ['the_captain'],
      ['the_captain'])
    navigations.push new Navigation(
      ['the_captain'],
      ['frenchy'])
    navigations.push new Navigation(
      ['first_mate'],
      ['lady_lauren'])
    navigations.push new Navigation(
      ['first_mate'],
      ['the_captain', 'first_mate'], false, true)
    navigations.push new Navigation(
      ['the_kid'],
      ['lady_lauren', 'sir_stephen', 'frenchy', 'the_captain', 'first_mate']
    , false, true)
    navigations.push new Navigation(
      ['the_captain'],
      ['first_mate'], true, false, 1)
    navigations.push new Navigation(
      ['frenchy'],
      ['the_captain', 'first_mate', 'lady_lauren'], true)
    navigations.push new Navigation(
      ['frenchy'],
      ['the_captain', 'first_mate', 'the_kid'], false, true)
    navigations.push new Navigation(
      ['sir_stephen'],
      ['the_captain', 'the_kid'], false, true)
    navigations.push new Navigation(
      ['sir_stephen'],
      ['lady_lauren'], true)
    navigations.push new Navigation(
      ['the_kid'],
      ['sir_stephen', 'frenchy', 'the_captain', 'first_mate', 'the_kid'], true)
    navigations.push new Navigation(
      ['the_kid'],
      ['the_captain', 'first_mate', 'frenchy', 'lady_lauren'])
    navigations.push new Navigation(
      ['frenchy'],
      ['the_captain', 'first_mate', 'sir_stephen', 'frenchy'], true, true)
    navigations.push new Navigation(
      ['sir_stephen'],
      ['the_captain', 'first_mate', 'frenchy'], true, true)
    navigations.push new Navigation(
      ['first_mate'],
      ['the_captain', 'frenchy'], true, true)
    navigations.push new Navigation(
      ['the_kid'],
      ['sir_stephen', 'frenchy', 'the_captain', 'first_mate', 'the_kid']
    , true, true, 1)
    navigations.push new Navigation(
      ['the_captain'],
      ['sir_stephen'], true, true)
    navigations.push new Navigation(
      ['lady_lauren'],
      ['lady_lauren',
       'sir_stephen',
       'frenchy',
       'the_captain',
       'first_mate',
       'the_kid'],
      false, true, -1)
    navigations.push new Navigation(
      ['first_mate'],
      ['the_kid'], true, false, 1)
    navigations.push new Navigation(
      ['frenchy'],
      ['the_captain', 'first_mate', 'sir_stephen'], false, false, 1)
    navigations.push new Navigation(
      ['sir_stephen'],
      ['sir_stephen', 'the_captain'])

    @navigations.length = 0
    @navigations.push navigation for navigation in _.shuffle(navigations)

  pickItems: (alivesurvivors = 6)->
    @shuffleItems() if @items.length < alivesurvivors
    @items.splice(0, alivesurvivors)
  pickNavigation: (count = 2)->
    @navigations.splice(0, count)


class GameController
  constructor: (@game)->
  openItem: (survivor, item)->
    #todo: check has item
    survivor.removeFromUnderSeat(item)
    survivor.putInItems(item)
  pickItem: (survivor, item)->
    #todo: check item pickupable
    if @game.phase is 'pick_item' && @game.currentPlayer is survivor
      survivor.putUnderSeat(item)
  row: (survivor)->
    survivor.isRowed = true
    @game.pickNavigation()
  rowedNavigation: (navigations)->
    @game.navigationStack.push navigation for navigation in navigations
  attack: (attacker, defender)->
    @game.phase = 'fight'
    @game.fight = new Fight attacker, defender
  joinDefenders: (survivor)->
    @game.fight.joinDefenders(survivor)
  joinAttackers: (survivor)->
    @game.fight.joinAttackers(survivor)

class Validator
  constructor: (@game)->
  isSurviverTurn: (surviver)->
    @game.currentPlayer is surviver
  isFight: ->
    @game.fight
  inFight: (surviver)->
    @isFight() and
    (Util.inA(@game.fight.attackers,
      surviver) or Util.inA(@game.fight.defenders,
      surviver))


class Util
  @inA: (array, item)->
    !!~array.lastIndexOf(item)