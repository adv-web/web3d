# The static class that listens to key events.
class Input
  module.exports = this

  # @nodoc
  @_keyBitmap: []

  # @private
  @_onKeyDown: (event) ->
    Input._keyBitmap[event.keyCode] = true
    # console.log("keydown")

  # @private
  @_onKeyUp: (event) ->
    Input._keyBitmap[event.keyCode] = false
    # console.log("keyup")

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

  document.addEventListener('keydown', @_onKeyDown, false);
  document.addEventListener('keyup', @_onKeyUp, false);
