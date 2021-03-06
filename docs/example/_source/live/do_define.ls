@N = @ndoo ||= {}
_n = @ndoo

libPathBase  = '../lib'
jsPathbase   = '../js'
currLibPath  = 'lib'
currJsPath   = 'js'
ndooPathBase = '../js'

Do.setConfig \autoLoad, false

Do.define 'jquery', do
  path: "#{jsPathbase}/jquery-2.1.1.min.js"
  type: \js

Do.setLoaded ['jquery']

Do.define 'ndoo.test', do
  path: "#{currJsPath}/ndoo.app.test.js"
  type: \js

_n.on 'NAPP_DEFINE', !->
  _n.setApp 'ndoo.test'

Do.define 'test.main', do
  path: "#{currJsPath}/ndoo.block.test.js"
  type: \js

_n.on 'NBLOCK_DEFINE', !->
  _n.setBlock 'test.main'
/* vim: se ts=2 sts=2 sw=2 fdm=marker cc=80 et: */
