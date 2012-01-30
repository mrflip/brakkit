"use strict"

expectToAll = (arr, fn) ->
  # console.log( arr, _.all(arr, fn), _.map(arr, fn) )
  expect( _.all(arr, fn) ).toBe(true)

describe "seed order", ->
  _.each [2, 4, 8, 16, 32, 64], (t_size) ->
    context "for tournaments of size #{t_size}", ->
      it "all exist", ->
        _.each [SEED_FOR_SLOT[t_size], SLOT_FOR_SEED[t_size], MATCH_FOR_SEED[t_size]], (subject) ->
          expect( _.keys(subject).length ).toBe(t_size)
      it "has all the slots", ->
        _.each [SEED_FOR_SLOT[t_size], SLOT_FOR_SEED[t_size], MATCH_FOR_SEED[t_size]], (subject) ->
          expectToAll( [1..t_size], (seed) -> subject[seed]? )
      it "SEED_FOR_SLOT and SLOT_FOR_SEED are inverses #{t_size}", ->
        _.each SLOT_FOR_SEED[t_size], (slot, seed) -> expect( SEED_FOR_SLOT[t_size][slot] ).toBe(seed)
        _.each SEED_FOR_SLOT[t_size], (seed, slot) -> expect( SLOT_FOR_SEED[t_size][seed] ).toBe(slot)
      it "SLOT_FOR_SEED lines up with MATCH_FOR_SEED #{t_size}", ->
        _.each [1..t_size], (seed) ->
          expect( MATCH_FOR_SEED[t_size][seed] ).toBe( Math.ceil(SLOT_FOR_SEED[t_size][seed] / 2) )
  it "lines up seeds correctly 16 sd 16", -> expect(MATCH_FOR_SEED[16][16]).toBe(1)
  it "lines up seeds correctly  8 sd  6", -> expect(MATCH_FOR_SEED[ 8][ 6]).toBe(4)
  it "lines up seeds correctly  8 sd  3", -> expect(MATCH_FOR_SEED[ 8][ 3]).toBe(4)
  it "lines up seeds correctly  8 sd  2", -> expect(MATCH_FOR_SEED[ 8][ 2]).toBe(3)
  it "lines up seeds correctly 32 sd  2", -> expect(MATCH_FOR_SEED[32][ 2]).toBe(9)

#
# Core extensions
#

describe "String", ->
  context "sprintf", ->
    it "decorates the String class", -> expect("".sprintf).toBeDefined()
    it "formats numbers", -> expect("%05d".sprintf(50)).toEqual('00050')
  context "to_i", ->
    it "parses zero",             -> expect("0".to_i()).toBe(0)
    it "coerces float-ish",       -> expect("5.9999".to_i()).toBe(5)
    it "is NaN for non-num-ish",  -> expect("YO".to_i()).toBeNaN

describe "Math", ->
  it "log2 function", -> expect(Math.log2(32)).toBe(5.0)


describe "first_present", ->
  stubby = null
  beforeEach ->
    stubby = jasmine.createStubObj('stubby', {
      name: "megatron", nice: false, friends: ((potential) -> []), form: 'gun', transform: (-> @form = 'robot') })
  it "returns null on no args",       -> expect(_.first_present()).toBeNull()
  it "returns null if all are blank", ->
    expect(_.first_present( null, [], 0, false, {}, (-> null), false )).toBeNull()
  it "returns true on first non-blank", ->
    expect(_.first_present( null, 'yes sir', 'no sir')).toBe('yes sir')
  it "calls functions", ->
    expect(_.first_present( stubby.nice, stubby.friends, stubby.friends(['bumblebee']), 'guard')).toBe('guard')
    expect(stubby.friends).toHaveBeenCalledWith()
    expect(stubby.friends).toHaveBeenCalledWith(['bumblebee'])
  it "doesn't accept empty DOM selectors", ->
    expect( _.first_present($('ze_goggles_zey_do_nussing'), $('#i_am_here')) ).toBe('#i_am_here')

describe "rubyish", ->
  context "present", ->
    it_is_true  "for non-zero numbers",   -> _.present(5)
    it_is_true  "for non-empty arrays",   -> _.present([1,2,3])
    it_is_true  "for non-empty strings",  -> _.present("LOQUITOR ERGO SUM")
    it_is_true  "for non-empty objects",  -> _.present({ n_problems: 99 })
    it_is_true  "for non-empty objects",  -> _.present({ bitch_problems: true })
    it_is_true  "if length property > 0", -> _.present({ length: 1 })
    it_is_true  "for regexes",            -> _.present(/^$/)
    it_is_true  "for dates",              -> _.present(new Date)
    it_is_true  "for functions",          -> _.present(-> null)
    it_is_true  "for non-empty DOM selector", -> _.present($('#i_am_here'))
    it_is_true  "for non-empty DOM selector", -> _.present($('.i_am_here'))
    it_is_true  "for non-empty DOM selector", -> _.present($('div'))


    it_is_false "for zero",                -> _.present(0)
    it_is_false "for null",                -> _.present(null)
    it_is_false "for false",               -> _.present(false)
    it_is_false "for NaN",                 -> _.present(NaN)
    it_is_false "for undefined",           -> _.present(undefined)
    it_is_false "for []",                  -> _.present([])
    it_is_false "for {}",                  -> _.present({})
    it_is_false "if length property <= 0", -> _.present({ length: 0.0 })
    it_is_false "if length property <= 0", -> _.present({ length: 0 })
    it_is_false "for empty DOM selector",  -> _.present($('ze_goggles_zey_do_nussing'))
    it_is_false "for empty DOM selectors (when length is not hasOwnProperty)", ->
      _.present( $("#i_am_not_here") )

  context "blank", ->
    it "is the opposite of present", ->
      spyOn(_, 'present')
      expect(_.blank(5)).toBe(true)
      expect(_.present).toHaveBeenCalledWith(5)
    it "is the opposite of present", ->
      spyOn(_, 'present')
      expect(_.blank(null)).toBe(true)
      expect(_.present).toHaveBeenCalledWith(null)

# ===========================================================================
#
#
#

# tournament = new Tournament(16, [
#   new Contestant("The Beatles")
#   new Contestant("Elvis Presley")
#   new Contestant("U2")
#   ])
# tournament.title = 'Test Tournament'
#
# describe "Tournament", ->
#   context 'constructor', ->
#     it 'normal', ->
#       expect(tournament.contestants.length).toBe(3)
#       expect(tournament.contestants[2].name).toBe("U2")
#     it 'raises if size is bad', ->
#       expect( -> new Tournament(69) ).toThrow("Size must be a nice round power of two (not 69)")
#       expect( -> new Tournament(4)  ).toThrow("Size must be eight or more (not 4)")
#     it 'creates rounds', ->
#       expect( tournament.rounds.length ).toBe(4)
#       expectEvery(tournament.rounds, (el) -> el instanceof TRound)
#       expectEvery(tournament.rounds, (el) -> el.tournament is tournament)
#   it 'title', ->
#     expect( tournament.title ).toBe('Test Tournament')
#
# describe 'TRound', ->
#   it 'n_matches', ->
#     expect(tournament.rounds[0].n_matches()).toBe(8)
#   context 'relationships', ->
#     it 'knows what its previous round was', ->
#       1

#
# Run the tests
#
jasmineEnv = jasmine.getEnv();
jasmineEnv.updateInterval = 1000;
jasmineEnv.addReporter(new self.jasmine.HtmlReporter());
jasmineEnv.execute();
