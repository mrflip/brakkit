String::sprintf  = (args...) -> vsprintf(this, args)
String::vsprintf = (args)    -> vsprintf(this, args)

Math.log2 = (num) -> Math.log(num) / Math.LN2


String::underscore = ->
  this.
  replace(/\W+/g, "_").
  replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2').
  replace(/([a-z\d])([A-Z])/g,     '$1_$2').
  replace(/_+/g, "_").
  toLowerCase()

String::to_i = ->
  parseInt(this)

#

_.present = (obj) ->
  return false if not obj                  # falsy  is not present
  return (obj.length > 0) if _.isArray(obj) or _.isString(obj) # not present if length 0
  return true if  $.type(obj) != 'object'  # dates, numbers, regexps etc are present
  return (obj.length > 0) if obj.length?   # not present if object with obj.length 0
  return true for own key of obj           # an object with keys is present
  false                                    # otherwise, not present

# _.present_orig = _.present
# _.present = (obj) ->
#   res = _.present_orig(obj)
#   window.fiddle = obj
#   console.log( {
#     _me: obj, _res: res, bool: (not obj), type: $.type(obj),
#     len_0_a:    (obj.length is 0 if obj and obj.hasOwnProperty('length')),
#     is_obj:     ($.type(obj) == 'object'),
#     obj_w_len:  (($.type(obj) == 'object') and ('length' in obj)),
#     obj_w_len2: ('selector' in obj),
#     a: obj['selector'],
#     b: obj['length'],
#     len: obj.length,
#     len_0_b:    (obj.length is 0 if (($.type(obj) == 'object') and ('length' in obj))),
#     obj_own_prop: (prop for own prop of obj)
#     obj_all_prop: (prop for prop of obj)
#     }) if obj
#   res

_.blank = (val) -> not _.present(val)

#
# Return the first non-emp
_.first_nonblank = (args...) ->
  result = null
  _.each args, (fn, index, list) ->
    val = if _.isFunction(fn) then do(fn) else fn
    if _.present(val) then (result = val ; _.breakLoop())
  result


SEED_FOR_SLOT_ARR = {
  64: [ 0, 1, 64, 32, 33, 16, 49, 17, 48,  8, 57, 25, 40,  9, 56, 24, 41,  4, 61, 29, 36, 13, 52, 20, 45,  5, 60, 28, 37, 12, 53, 21, 44,  2, 63, 31, 34, 15, 50, 18, 47,  7, 58, 26, 39, 10, 55, 23, 42,  3, 62, 30, 35, 14, 51, 19, 46,  6, 59, 27, 38, 11, 54, 22, 43]
  32: [ 0, 1, 32, 16, 17,  8, 25,  9, 24,  4, 29, 13, 20,  5, 28, 12, 21,  2, 31, 15, 18,  7, 26, 10, 23,  3, 30, 14, 19,  6, 27, 11, 22]
  16: [ 0, 1, 16,  8,  9,  4, 13,  5, 12,  2, 15,  7, 10,  3, 14,  6, 11 ]
  8:  [ 0, 1,  8,  4,  5,  2,  7,  3,  6,  ]
  4:  [ 0, 1,  4,  2,  3, ]
  2:  [ 0, 1,  2,  ]
}
window.SEED_FOR_SLOT  = {}
window.MATCH_FOR_SEED = {}
window.SLOT_FOR_SEED  = {}

for t_size, seed_for_slot of SEED_FOR_SLOT_ARR
  MATCH_FOR_SEED[t_size] = [] ; SLOT_FOR_SEED[t_size] = []; SEED_FOR_SLOT[t_size] = []
  for seed, slot in seed_for_slot
    continue if seed is 0
    SEED_FOR_SLOT[ t_size][slot] = seed
    SLOT_FOR_SEED[ t_size][seed] = slot
    MATCH_FOR_SEED[t_size][seed] = Math.ceil(slot / 2)

console.log( MATCH_FOR_SEED, SLOT_FOR_SEED, SEED_FOR_SLOT )
