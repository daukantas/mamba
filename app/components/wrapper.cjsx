React = require 'react'


class ComponentWrapper

  constructor: (@_component) ->
    @_rendered = false

  @wrap: (component) ->
    unless React.isValidElement(component)
      throw new Error "Expected ReactComponent, got #{component.toString()}"
    new ComponentWrapper(component)

  Object.defineProperty @::, '_html_element',
    enumerable: false
    writable: true

  mount: (html_element) ->
    unless html_element instanceof HTMLElement
      throw new Error "#{html_element.toString()} isn't an HTMLElement"
    @_html_element = html_element
    @

  render: ->
    if !@_html_element?
      throw new Error(".mount(HTMLElement html_element) before rendering!")
    else if @_rendered
      throw new Error("Component's already been rendered!")
    React.render @_component, @_html_element
    @_rendered = true
    @


module.exports =

  wrap: ComponentWrapper.wrap.bind(ComponentWrapper)

