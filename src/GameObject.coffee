class GameObject

  constructor: ->
    @mesh = null
    @components = {}

  addComponent: (comp) =>
    comp.gameObject = this
    components[comp.name] = comp

  getComponent: (name) =>
    components[name]

  removeComponent: (name) =>
    components[name] = null

  broadcast: (args...) =>
    comp.receive(args...) for name, comp of components