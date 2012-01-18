class window.Brak
  constructor: (@class_name, @parent, my_id_parts) ->
    @id_parts = _.compact(_.flatten([@parent?.id_parts, my_id_parts]))
    @id = "#{@class_name}_#{@id_parts.join('_')}"
    @visual   = $("##{@id}")
    @visual.data('model', this)

#
# collection of Contestants and Rounds that define a bracket-style showdown.
#
class window.Tournament extends Brak
  title: ""
  constructor: (@size = 16, contestant_names = []) ->
    super('tournament', null, 1)
    @$wing       = @visual.find('.wing')
    @pool        = new Pool(this, 1)
    @contestants = (new Contestant(this, name, i+1) for name, i in contestant_names)
    @_initialize_rounds()
    console.log this

  round: (idx) -> @rounds[idx - 1] if idx >= 1

  $initial_match_for: (seed) ->
    return null if seed > @size
    match_idx = MATCH_FOR_SEED[@size][seed]
    $("#tmatch_#{@id_parts[0]}_1_1_#{match_idx}")

  $initial_slot_for: (seed) ->
    $("#tmslot_#{@id_parts[0]}_1_1_#{seed}")

  # build the initial set of rounds
  _initialize_rounds: ->
    @n_rounds = Math.log2(@size)
    throw "Size must be eight or more, and a nice round power of two (not #{@size})" unless (Math.pow(2, @n_rounds) == @size) && (4 <= @size)
    # assemble the rounds
    @rounds   = ( new Tround(this, rd_idx, @size/Math.pow(2, rd_idx)) for rd_idx in [1 .. @n_rounds] )
    @rounds.push( new WinnerRound(this, @n_rounds+1, 1) )
    # populate all the result fields
    _.each(@round(1).tmatches, (tmatch) -> tmatch.update())

#
# The sorting pool
#
class window.Pool extends Brak
  constructor: (@tournament) ->
    super('pools', @tournament, null)
    @_make_droppable(@visual.find('.slot'))

  # on drop into a slot,
  # * notify the previous occupant to go elsewhere,
  # * tell the new occupant about its new home
  on_slot_drop: (event, ui) ->
    $(this).children('.contestant').each (i, el) ->
      $(el).data('model')?.boot() unless ($(el).data('model') is ui.draggable.data('model'))
    ui.draggable.data('model').update_seed($(this).data('seed'))

  $slot_for: (seed) ->
    _.first_nonblank(
      $("#slot_#{@id_parts[0]}_#{seed}"),
      => @$first_empty_bubble_slot() )

  $first_empty_bubble_slot: ->
    _.first_nonblank(
      @visual.find('.bubble .slot').not(':has(.contestant)'),
      =>
        idx = 1 + @visual.find('.bubble .slot').length + @tournament.size
        @visual.find('.bubble').append("<li id='slot_1_#{idx}' class='slot'><span class='seed'>#{idx}</span></li>")
        @_make_droppable( @visual.find('.bubble .slot').not(':has(.contestant)') ).first() )

  # Set up the slots to be droppable. Also mixed into Tround. chains.
  _make_droppable: (elts) ->
    elts.
      each((i, elt) -> $(elt).data('seed', elt.id.replace(/.*_/,'').to_i())).
      droppable({ drop: @on_slot_drop, scope: @tournament.id, hoverClass: 'drophover', })

#
# set of matches in a tournament
#
class window.Tround extends Brak
  constructor: (@tournament, @rd_idx, @size) ->
    super('tround', @tournament, [1, @rd_idx])
    @_initialize_matches()
    @_make_droppable(@visual.find('.slot')) if rd_idx is 1

  n_matches:  -> @tournament.size / Math.pow(2, @rd_idx)
  prev_round: -> @tournament.round(@rd_idx - 1)
  next_round: -> @tournament.round(@rd_idx + 1)
  tmatch: (idx) -> @tmatches[idx-1]

  _initialize_matches: ->
    @tmatches = (new TMatch(this, match_idx) for match_idx in [1 .. @size])

  _make_droppable: Pool.prototype._make_droppable
  on_slot_drop:    Pool.prototype.on_slot_drop

  $slot_for: (seed) ->
    $("#tmslot_#{@id_parts.join('_')}_#{seed}")

# a winner round has only the one weird match
class window.WinnerRound extends Tround
  _initialize_matches: ->
    @tmatches = [new WinnerMatch(this, 1)]

#
# Tournament match
#
class window.TMatch extends Brak
  constructor: (@tround, @match_idx) ->
    super('tmatch', @tround, @match_idx)
    @dependent = @tround.rd_idx > 1

  next_match:   -> @tround.next_round()?.tmatch( Math.ceil(@match_idx / 2.0) )
  prev_match_a: -> @tround.prev_round()?.tmatch( @match_idx * 2 - 1 )
  prev_match_b: -> @tround.prev_round()?.tmatch( @match_idx * 2 )

  winner:       -> @contestant_a

  $slot_a:      -> @visual.children('.part_a')
  $slot_b:      -> @visual.children('.part_b')

  _update_slot: ($slot, contestant) ->
    $contestant = $slot.children('.contestant')
    if $contestant.data('model') != contestant
      $contestant.html(contestant?.name ? "").attr('class', "contestant #{contestant?.id}").data('model', contestant)
      $contestant.effect('highlight') if contestant

  update: ->
    console.log( this, @dependent, @prev_match_a() )
    if @dependent
      @contestant_a = @prev_match_a()?.winner() ? null
      @contestant_b = @prev_match_b()?.winner() ? null
      @_update_slot(@$slot_a(), @contestant_a)
      @_update_slot(@$slot_b(), @contestant_b)
    else
      @contestant_a = @$slot_a().children('.contestant').data('model')
      @contestant_b = @$slot_b().children('.contestant').data('model')
    @next_match()?.update()

class window.WinnerMatch extends TMatch

#
# A single contestant
#
# every contestant has two ui elements:
# * the one that lives in pool, whether ranked or on the bubble
# * the one that lives in bracket, whether in tround 1 or the (invisible) bubble
#
# drag/drop and other things just record *where* those should go; the contestant
# has sole responsibility to idempotently update them to their new slots.
#
class window.Contestant extends Brak
  constructor: (@tournament, @name, @seed) ->
    @handle = "_#{@name.underscore()}"
    super('contestant', @tournament, @handle)
    @$pool_entry = @_make_visual(@$pool_slot(), 'pcont')
    @$trnd_entry = @_make_visual(@$trnd_slot(), 'tcont')
    @$pool_entry.bind('dblclick touchhold.start', (event, ui) => @_beg_editing())
    @update_seed(@seed)

  $pool_slot: ->
    @tournament.pool.$slot_for(@seed)
  $trnd_slot: ->
    @tournament.$initial_slot_for(@seed)
  _make_visual: ($target, type) ->
    if $target.children('.contestant').length > 0
      $target.children('.contestant').replaceWith(@_normal_element(type))
    else
      $target.append(@_normal_element(type))
    $visual = $target.children('.contestant')
    $visual.data('model', this)
    $visual.draggable({
      snap: '.slot', snapMode: 'inner', scope: @tournament.id, revert: 'invalid', opacity: 0.8, zIndex: 2700, containment: @tournament.visual
    }).disableSelection()
    $visual

  _normal_element:   (type) -> "<span  id='#{type}_#{@id}' class='contestant #{@id}'>#{@name}</span>"
  _editable_element: (type) -> "<input id='#{type}_#{@id}' class='contestant #{@id}' type='text' value='#{@name}'></input>"
  _beg_editing:    ->
    @$pool_entry.replaceWith(@_editable_element('pcont'))
    @$pool_entry = @$pool_slot().children('.contestant').first()
    @$pool_entry.data('model', this)
    @$pool_entry.bind('change blur submit', (event, ui) => @_end_editing())
  _end_editing:    ->
    @$pool_entry.unbind('change blur submit')
    if @$pool_entry.val()
      @name = @$pool_entry.val()
      $('.'+@id).html(@name)
    @$pool_entry = @_make_visual(@$pool_slot(), 'pcont')
    @$pool_entry.bind('dblclick touchhold.start', (event, ui) => @_beg_editing())
    @initial_tmatch?.update()

  boot: ->
    @update_seed( @tournament.pool.$first_empty_bubble_slot().data('seed') )

  initial_tmatch: ->
    return null if @on_bubble()
    @tournament.$initial_match_for(@seed)?.data('model')

  on_bubble: -> (@seed > @tournament.size)

  update_seed: (seed) ->
    orig_tmatch = @initial_tmatch()
    orig_seed   = @seed
    @seed       = seed
    @$pool_entry.appendTo(@$pool_slot()).css({top: '', left: '', opacity: 1})
    @$trnd_entry.appendTo(@$trnd_slot()).css({top: '', left: '', opacity: 1})
    @initial_tmatch()?.update()
    if (@seed != orig_seed)
      @$pool_entry.effect('highlight') ; @$trnd_entry.effect('highlight')
      orig_tmatch?.update()

window.tournament = new Tournament(8, [
  "Beatles", "Rolling Stones", "Elvis", "U2",
  "Stevie Wonder",  "Prince", "Frank Sinatra", "Police",
  "The Clash", "The Beastie Boys", "Velvet Underground", "Led Zeppelin",
  # "Bob Dylan", "The Beach Boys", "Blondie", "New Order",
  ])
window.tournament.title = 'Test Tournament'


# "<div class='contestant'>",
# "  <span class='text'>#{@name}</span>",
# "  <span class='drag_handle'><span class='ui-icon ui-icon-carat-2-n-s'></span></span>",
# "</div>"
# <li class="contestant"><input class="text sd01" value="Beatles" type="text"></input><span class="drag_handle"><span class="ui-icon ui-icon-carat-2-n-s"></span></span></li>
