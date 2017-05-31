# The static class that listens to key events.
class Input
  module.exports = this

  # store function that will response to click event
  # @nodoc
  @_clickResponses = []

  # @nodoc
  @_keyBitmap: []

  # @private
  # @nodoc
  @_canMove = true

  # @property [Object] all axises
  @axis =
    vertical: "vertical",
    horizontal: "horizontal"

  # @private
  @_onKeyDown: (event) ->
    Input._keyBitmap[event.keyCode] = true

  # @private
  @_onKeyUp: (event) ->
    Input._keyBitmap[event.keyCode] = false

  # @overload isPressed(keyCode)
  #   Tell whether the key of given key code is pressed.
  #   @param keyCode [number] the given key code, if refer to a letter, use upper case
  #   @return [boolean] the key is pressed or not
  #
  # @overload isPressed(key)
  #   Tell whether the key is pressed.
  #   @param key [String] the given key, e.g. 'A' or 'a' both OK
  #   @return [boolean] the key is pressed or not
  @isPressed: (arg) ->
    code = if isNaN(arg) then arg.toUpperCase().charCodeAt(0) else arg
    return !!Input._keyBitmap[code]

  # Returns the value of the virtual axis identified by axisName.
  # The value will be in the range -1 or 0 or 1 for keyboard input.
  # @param [String] axis vertical or horizontal
  # @return [Integer] the velocity
  @getAxis: (axis) =>
    num = 0

    switch axis
      when @axis.vertical
        if @isPressed('S')
          num += 1
        if @isPressed('W')
          num -= 1
      when @axis.horizontal
        if @isPressed('D')
          num += 1
        if @isPressed('A')
          num -= 1

    return if @_canMove then num else -num

  # let the player stop move
  # @nodoc
  @_stopMove: =>
    @_canMove = false

  # let the player start move
  # @nodoc
  @activeMove: =>
    @_canMove = true

  # @private
  @_onclick: () =>
    for res in @_clickResponses
      res()

  # add response to click event
  # @param [Function] res a callback function that response to click event
  @registerClickResponse: (res) =>
    @_clickResponses.push(res)

  # add response to click event
  # @param [Function] res a callback function that had been registered before
  @removeClickResponse: (res) =>
    @_clickResponses.remove(res)

  document.addEventListener('keydown', @_onKeyDown, false)
  document.addEventListener('keyup', @_onKeyUp, false)
  document.body.onclick = @_onclick
