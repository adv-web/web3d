class GameObject

  constructor: (@mesh)->
    @components = {}

  addComponent: (comp) =>
    comp.gameObject = this
    @components[comp.name] = comp
    if comp.update
      Game.instance().addScript(comp)

  getComponent: (name) =>
    @components[name]

  removeComponent: (name) =>
    @components[name] = null


  broadcast: (args...) =>
    comp.receive(args...) for name, comp of @components


window.GameObject = GameObject;