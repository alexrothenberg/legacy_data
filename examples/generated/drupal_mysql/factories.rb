Factory.define :url_alias do |u|
  u.src      'some string'
  u.dst      'some string'
  u.language 'some string'
end

Factory.define :session do |s|
  s.uid       7
  s.hostname  'some string'
  s.timestamp 7
  s.cache     7
end

Factory.define :node_comment_statistic do |n|
  n.last_comment_timestamp 7
  n.last_comment_uid       7
  n.comment_count          7
end

Factory.define :action do |a|
  a.type        'some string'
  a.callback    'some string'
  a.parameters  'some text value'
  a.description 'some string'
end

Factory.define :node_type do |n|
  n.name           'some string'
  n.module         'some string'
  n.description    'some text value'
  n.help           'some text value'
  n.has_title      7
  n.title_label    'some string'
  n.has_body       7
  n.body_label     'some string'
  n.min_word_count 7
  n.custom         7
  n.modified       7
  n.locked         7
  n.orig_type      'some string'
end

Factory.define :node_access do |n|
  n.nid          7
  n.gid          7
  n.realm        'some string'
  n.grant_view   7
  n.grant_update 7
  n.grant_delete 7
end

Factory.define :flood do |f|
  f.event     'some string'
  f.hostname  'some string'
  f.timestamp 7
end

Factory.define :uploaded_files do |u|
  u.uid       7
  u.filename  'some string'
  u.filepath  'some string'
  u.filemime  'some string'
  u.filesize  7
  u.status    7
  u.timestamp 7
end

Factory.define :cache_page do |c|
  c.expire     7
  c.created    7
  c.serialized 7
end

Factory.define :cache_form do |c|
  c.expire     7
  c.created    7
  c.serialized 7
end

Factory.define :watchdog do |w|
  w.uid       7
  w.type      'some string'
  w.message   'some text value'
  w.variables 'some text value'
  w.severity  7
  w.link      'some string'
  w.location  'some text value'
  w.hostname  'some string'
  w.timestamp 7
end

Factory.define :node_counter do |n|
  n.totalcount 7
  n.daycount   7
  n.timestamp  7
end

Factory.define :node do |n|
  n.vid       7
  n.type      'some string'
  n.language  'some string'
  n.title     'some string'
  n.uid       7
  n.status    7
  n.created   7
  n.changed   7
  n.comment   7
  n.promote   7
  n.moderate  7
  n.sticky    7
  n.tnid      7
  n.translate 7
end

Factory.define :history do |h|
  h.uid       7
  h.nid       7
  h.timestamp 7
end

Factory.define :comment do |c|
  c.pid       7
  c.nid       7
  c.uid       7
  c.subject   'some string'
  c.comment   'some text value'
  c.hostname  'some string'
  c.timestamp 7
  c.status    7
  c.format    7
  c.thread    'some string'
end

Factory.define :cache do |c|
  c.expire     7
  c.created    7
  c.serialized 7
end

Factory.define :vocabulary_node_type do |v|
  v.vid  7
  v.type 'some string'
end

Factory.define :cache_filter do |c|
  c.expire     7
  c.created    7
  c.serialized 7
end

Factory.define :box do |b|
  b.info   'some string'
  b.format 7
end

Factory.define :system do |s|
  s.name           'some string'
  s.type           'some string'
  s.owner          'some string'
  s.status         7
  s.throttle       7
  s.bootstrap      7
  s.schema_version 7
  s.weight         7
end

Factory.define :role do |r|
  r.name 'some string'
end

Factory.define :permission do |p|
  p.rid  7
  p.tid  7
end

Factory.define :blocks_role do |b|
  b.module 'some string'
  b.delta  'some string'
  b.rid    7
end

Factory.define :actions_aid do |a|
end

Factory.define :node_revision do |n|
  n.nid       7
  n.uid       7
  n.title     'some string'
  n.body      'some text value'
  n.teaser    'some text value'
  n.log       'some text value'
  n.timestamp 7
  n.format    7
end

Factory.define :filter do |f|
  f.format 7
  f.module 'some string'
  f.delta  7
  f.weight 7
end

Factory.define :cache_block do |c|
  c.expire     7
  c.created    7
  c.serialized 7
end

Factory.define :term_hierarchy do |t|
  t.tid    7
  t.parent 7
end

Factory.define :menu_custom do |m|
  m.title       'some string'
end

Factory.define :cache_update do |c|
  c.expire     7
  c.created    7
  c.serialized 7
end

Factory.define :term_data do |t|
  t.vid         7
  t.name        'some string'
  t.weight      7
end

Factory.define :menu_link do |m|
  m.menu_name    'some string'
  m.plid         7
  m.link_path    'some string'
  m.router_path  'some string'
  m.link_title   'some string'
  m.module       'some string'
  m.hidden       7
  m.external     7
  m.has_children 7
  m.expanded     7
  m.weight       7
  m.depth        7
  m.customized   7
  m.p1           7
  m.p2           7
  m.p3           7
  m.p4           7
  m.p5           7
  m.p6           7
  m.p7           7
  m.p8           7
  m.p9           7
  m.updated      7
end

Factory.define :user do |u|
  u.name             'some string'
  u.pass             'some string'
  u.mode             7
  u.theme            'some string'
  u.signature        'some string'
  u.signature_format 7
  u.created          7
  u.access           7
  u.login            7
  u.status           7
  u.language         'some string'
  u.picture          'some string'
end

Factory.define :term_synonym do |t|
  t.tid  7
  t.name 'some string'
end

Factory.define :term_relation do |t|
  t.tid1 7
  t.tid2 7
end

Factory.define :batch do |b|
  b.token     'some string'
  b.timestamp 7
end

Factory.define :access do |a|
  a.mask   'some string'
  a.type   'some string'
  a.status 7
end

Factory.define :menu_router do |m|
  m.load_functions   'some text value'
  m.to_arg_functions 'some text value'
  m.access_callback  'some string'
  m.page_callback    'some string'
  m.fit              7
  m.number_parts     7
  m.tab_parent       'some string'
  m.tab_root         'some string'
  m.title            'some string'
  m.title_callback   'some string'
  m.title_arguments  'some string'
  m.type             7
  m.block_callback   'some string'
  m.description      'some text value'
  m.position         'some string'
  m.weight           7
end

Factory.define :authmap do |a|
  a.uid      7
  a.authname 'some string'
  a.module   'some string'
end

Factory.define :vocabulary do |v|
  v.name        'some string'
  v.help        'some string'
  v.relations   7
  v.hierarchy   7
  v.multiple    7
  v.required    7
  v.tags        7
  v.module      'some string'
  v.weight      7
end

Factory.define :variable do |v|
  v.value 'some text value'
end

Factory.define :users_role do |u|
  u.uid 7
  u.rid 7
end

Factory.define :term_node do |t|
  t.nid 7
  t.vid 7
  t.tid 7
end

Factory.define :filter_format do |f|
  f.name   'some string'
  f.roles  'some string'
  f.cache  7
end

Factory.define :cache_menu do |c|
  c.expire     7
  c.created    7
  c.serialized 7
end

Factory.define :block do |b|
  b.module     'some string'
  b.delta      'some string'
  b.theme      'some string'
  b.status     7
  b.weight     7
  b.region     'some string'
  b.custom     7
  b.throttle   7
  b.visibility 7
  b.pages      'some text value'
  b.title      'some string'
  b.cache      7
end

