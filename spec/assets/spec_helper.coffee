window.context  = window.describe;
window.xcontext = window.xdescribe;

window.expectEvery = (arr, fn) -> expect( arr.every(fn) ).toBe(true)

window.it_is_true  = (msg, fn) ->  it "is true  #{msg}", -> expect(do(fn)).toBe(true)
window.it_is_false = (msg, fn) ->  it "is false #{msg}", -> expect(do(fn)).toBe(false)
