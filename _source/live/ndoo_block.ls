/*
" --------------------------------------------------
"   FileName: ndoo.block.ls
"       Desc: ndoo.js block模块
"     Author: chenglf
"    Version: ndoo.js(v1.0b1)
" LastChange: 08/22/2015 00:05
" --------------------------------------------------
*/

"use strict"
_        = @[\_]
$        = @[\jQuery] || @[\Zepto]

@N = @ndoo ||= {}
_n = @ndoo

_vars    = _n.vars
_func    = _n.func
_stor    = _n.storage

/**
 * 检测是否存在指定block
 *
 * @method
 * @name hasBlock
 * @memberof ndoo
 * @param {string} namespace 名称空间
 * @param {string} name 名称
 */
_n.hasBlock = (namespace) ->
  if nsmatch = namespace.match /(.*?)(?:[/.]([^/.]+))$/
    [null, namespace, name] = nsmatch
  else
    [namespace, name] = [\_default, name]

  _n._blockData[\_exist]["block.#namespace.#name"]

/**
 * 标识指定block
 *
 * @method
 * @name setBlock
 * @memberof ndoo
 * @param {string} namespace 名称空间
 * @param {string} name 名称
 */
_n.setBlock = (namespace) ->
  if nsmatch = namespace.match /(.*?)(?:[/.]([^/.]+))$/
    [null, namespace, name] = nsmatch
  else
    [namespace, name] = [\_default, name]

  _n._blockData[\_exist]["block.#namespace.#name"] = true

/**
 * 添加block实现
 *
 * @method
 * @name block
 * @memberof ndoo
 * @param {string} namespace 名称空间
 * @param {string} name 名称
 */
_n.block = (namespace, block) ->
  if nsmatch = namespace.match /(.*?)(?:[/.]([^/.]+))$/
    [null, namespace, name] = nsmatch
  else
    [namespace, name] = [\_default, name]

  _n._block \block, namespace, name, block

_n.trigger \STATUS:NBLOCK_DEFINE

_n.on \NBLOCK_LOADED, (elem, namespace=\_default, name, params) ->
  if block = _n.block "#namespace.#name"
    if _.isFunction block
      block elem, params
    else if typeof block is 'object' and _.isObject(block) and block.init
      call = !->
        block.init elem, params

      if block.depend
        _n.require [].concat(block.depend), call, \Do
      else
        call!

/**
 * 初始化模块
 *
 * @method
 * @name initBlock
 * @memberof ndoo
 * @param {object} elem 初始化的元素
 */
_n.initBlock = (elem) !->
  blockId = $(elem).data \nblockId
  blockId = blockId.split /\s*,\s*|\s+/

  _call = (blockId) ->
    @.router.parse //
      ^(?:\/?)           # ^[/]
      (.*?)              # [:controller]
      (?:\/?([^/?#]+))   # /:action
      (?:\?(.*?))?       # [?:params]
      (?:\#(.*?))?$      # [#:hash]$
    //, blockId, (namespace = \_default, block, params) !~>
      pkg = "#namespace.#block"
      if @block pkg
        @trigger \NBLOCK_LOADED, elem, namespace, block, params
      else if _n.hasBlock pkg
        @require ["#namespace.#block"], !->
          _n.trigger \NBLOCK_LOADED, elem, namespace, block, params
        , \Do

  _.each blockId, (id) ->
    _call.call _n, id

_n.on \NBLOCK_INIT, !->
  blocks = $ '[data-nblock-id]'
  if blocks.length
    for block in blocks
      auto = $ block .data \nblockAuto
      if auto is undefined or auto.toString! isnt 'false'
        _n.initBlock block

# _n.initBlock('[data-nblock-id]')

/* vim: se ts=2 sts=2 sw=2 fdm=marker cc=80 et: */
