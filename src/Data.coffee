$ = require("jquery")

# manage the prefab file and other raw files like textures, audio and so on
class Data
  module.exports = this

  @MAJOR = 2  # vox, prefab

  # Start loading data.
  # @param onStart [Function] the function invoked when start
  # @param onUpdate [Function] the function invoked when loaded a new object
  # @param onReady [Function] the function invoked when all loaded
  @load: (onStart, onUpdate, onReady) ->
    Data._onUpdate = onUpdate
    Data._onReady = onReady
    onStart?()
    @_loadVox()
    @_loadPrefab()

  # 注意：这里没有处理 config 不存在时的情况。需要还原为 $.ajax 并在 error 回调中调用 checkGame
  # @private
  @_loadVox: ->
    $.getJSON "vox/config.json", (array) =>
      # if config.json exists
      voxParser = new vox.Parser()
      Data.vox ||= {}
      array.forEach (item) =>
        filename = "vox/" + (if item.filename then item.filename else item.name) + ".vox"
        voxParser.parse(filename).then (data) =>
          threeMesh = (new vox.MeshBuilder(data, {voxelSize: item.scale})).createMesh();
          Data.vox[item.name] = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material, 0)
          @_checkVox({type: "vox", major: 0, minorCount: array.length})

  # @private
  @_loadPrefab: ->
    $.getJSON "prefab/config.json", (array) =>
      Data.prefab ||= {}
      array.forEach (item) =>
        filename = "prefab/" + (if item.filename then item.filename else item.name) + ".prefab"
        $.getJSON filename, (prefab) =>
          Data.prefab[item.name] = prefab
          @_checkPrefab({type: "prefab", major: 1, minorCount: array.length})

  @_voxLoadCount = 0
  # @private
  @_checkVox: (data) ->
    data.minor = Data._voxLoadCount
    Data._onUpdate?(data)
    Data._voxLoadCount += 1
    @_checkGame() if Data._voxLoadCount == data.minorCount

  @_prefabLoadCount = 0
  # @private
  @_checkPrefab: (data) ->
    data.minor = Data._prefabLoadCount
    Data._onUpdate?(data)
    Data._prefabLoadCount += 1
    @_checkGame() if Data._prefabLoadCount == data.minorCount

  @_majorLoadCount = 0
  # @private
  @_checkGame: ->
    Data._majorLoadCount += 1
    Data._onReady?() if Data._majorLoadCount == Data.MAJOR


