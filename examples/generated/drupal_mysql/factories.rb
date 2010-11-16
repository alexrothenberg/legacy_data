Factory.define :access do |access|
  access.mask   'some string'
  access.type   'some string'
  access.status 7
end

Factory.define :action do |action|
  action.type        'some string'
  action.callback    'some string'
  action.parameters  'some text value'
  action.description 'some string'
end

Factory.define :actions_aid do |actions_aid|
end

Factory.define :authmap do |authmap|
  authmap.uid      7
  authmap.authname 'some string'
  authmap.module   'some string'
end

Factory.define :batch do |batch|
  batch.token     'some string'
  batch.timestamp 7
end

Factory.define :block do |block|
  block.module     'some string'
  block.delta      'some string'
  block.theme      'some string'
  block.status     7
  block.weight     7
  block.region     'some string'
  block.custom     7
  block.throttle   7
  block.visibility 7
  block.pages      'some text value'
  block.title      'some string'
  block.cache      7
end

Factory.define :blocks_role do |blocks_role|
  blocks_role.module 'some string'
  blocks_role.delta  'some string'
  blocks_role.rid    7
end

Factory.define :box do |box|
  box.info   'some string'
  box.format 7
end

Factory.define :cache do |cache|
  cache.expire     7
  cache.created    7
  cache.serialized 7
end

Factory.define :cache_block do |cache_block|
  cache_block.expire     7
  cache_block.created    7
  cache_block.serialized 7
end

Factory.define :cache_filter do |cache_filter|
  cache_filter.expire     7
  cache_filter.created    7
  cache_filter.serialized 7
end

Factory.define :cache_form do |cache_form|
  cache_form.expire     7
  cache_form.created    7
  cache_form.serialized 7
end

Factory.define :cache_menu do |cache_menu|
  cache_menu.expire     7
  cache_menu.created    7
  cache_menu.serialized 7
end

Factory.define :cache_page do |cache_page|
  cache_page.expire     7
  cache_page.created    7
  cache_page.serialized 7
end

Factory.define :cache_update do |cache_update|
  cache_update.expire     7
  cache_update.created    7
  cache_update.serialized 7
end

Factory.define :comment do |comment|
  comment.pid       7
  comment.nid       7
  comment.uid       7
  comment.subject   'some string'
  comment.comment   'some text value'
  comment.hostname  'some string'
  comment.timestamp 7
  comment.status    7
  comment.format    7
  comment.thread    'some string'
end

Factory.define :uploaded_files do |uploaded_files|
  uploaded_files.uid       7
  uploaded_files.filename  'some string'
  uploaded_files.filepath  'some string'
  uploaded_files.filemime  'some string'
  uploaded_files.filesize  7
  uploaded_files.status    7
  uploaded_files.timestamp 7
end

Factory.define :filter_format do |filter_format|
  filter_format.name   'some string'
  filter_format.roles  'some string'
  filter_format.cache  7
end

Factory.define :filter do |filter|
  filter.format 7
  filter.module 'some string'
  filter.delta  7
  filter.weight 7
end

Factory.define :flood do |flood|
  flood.event     'some string'
  flood.hostname  'some string'
  flood.timestamp 7
end

Factory.define :history do |history|
  history.uid       7
  history.nid       7
  history.timestamp 7
end

Factory.define :menu_custom do |menu_custom|
  menu_custom.title       'some string'
end

Factory.define :menu_link do |menu_link|
  menu_link.menu_name    'some string'
  menu_link.plid         7
  menu_link.link_path    'some string'
  menu_link.router_path  'some string'
  menu_link.link_title   'some string'
  menu_link.module       'some string'
  menu_link.hidden       7
  menu_link.external     7
  menu_link.has_children 7
  menu_link.expanded     7
  menu_link.weight       7
  menu_link.depth        7
  menu_link.customized   7
  menu_link.p1           7
  menu_link.p2           7
  menu_link.p3           7
  menu_link.p4           7
  menu_link.p5           7
  menu_link.p6           7
  menu_link.p7           7
  menu_link.p8           7
  menu_link.p9           7
  menu_link.updated      7
end

Factory.define :menu_router do |menu_router|
  menu_router.load_functions   'some text value'
  menu_router.to_arg_functions 'some text value'
  menu_router.access_callback  'some string'
  menu_router.page_callback    'some string'
  menu_router.fit              7
  menu_router.number_parts     7
  menu_router.tab_parent       'some string'
  menu_router.tab_root         'some string'
  menu_router.title            'some string'
  menu_router.title_callback   'some string'
  menu_router.title_arguments  'some string'
  menu_router.type             7
  menu_router.block_callback   'some string'
  menu_router.description      'some text value'
  menu_router.position         'some string'
  menu_router.weight           7
end

Factory.define :node do |node|
  node.vid       7
  node.type      'some string'
  node.language  'some string'
  node.title     'some string'
  node.uid       7
  node.status    7
  node.created   7
  node.changed   7
  node.comment   7
  node.promote   7
  node.moderate  7
  node.sticky    7
  node.tnid      7
  node.translate 7
end

Factory.define :node_access do |node_access|
  node_access.nid          7
  node_access.gid          7
  node_access.realm        'some string'
  node_access.grant_view   7
  node_access.grant_update 7
  node_access.grant_delete 7
end

Factory.define :node_comment_statistic do |node_comment_statistic|
  node_comment_statistic.last_comment_timestamp 7
  node_comment_statistic.last_comment_uid       7
  node_comment_statistic.comment_count          7
end

Factory.define :node_counter do |node_counter|
  node_counter.totalcount 7
  node_counter.daycount   7
  node_counter.timestamp  7
end

Factory.define :node_revision do |node_revision|
  node_revision.nid       7
  node_revision.uid       7
  node_revision.title     'some string'
  node_revision.body      'some text value'
  node_revision.teaser    'some text value'
  node_revision.log       'some text value'
  node_revision.timestamp 7
  node_revision.format    7
end

Factory.define :node_type do |node_type|
  node_type.name           'some string'
  node_type.module         'some string'
  node_type.description    'some text value'
  node_type.help           'some text value'
  node_type.has_title      7
  node_type.title_label    'some string'
  node_type.has_body       7
  node_type.body_label     'some string'
  node_type.min_word_count 7
  node_type.custom         7
  node_type.modified       7
  node_type.locked         7
  node_type.orig_type      'some string'
end

Factory.define :permission do |permission|
  permission.rid  7
  permission.tid  7
end

Factory.define :role do |role|
  role.name 'some string'
end

Factory.define :session do |session|
  session.uid       7
  session.hostname  'some string'
  session.timestamp 7
  session.cache     7
end

Factory.define :system do |system|
  system.name           'some string'
  system.type           'some string'
  system.owner          'some string'
  system.status         7
  system.throttle       7
  system.bootstrap      7
  system.schema_version 7
  system.weight         7
end

Factory.define :term_data do |term_data|
  term_data.vid         7
  term_data.name        'some string'
  term_data.weight      7
end

Factory.define :term_hierarchy do |term_hierarchy|
  term_hierarchy.tid    7
  term_hierarchy.parent 7
end

Factory.define :term_node do |term_node|
  term_node.nid 7
  term_node.vid 7
  term_node.tid 7
end

Factory.define :term_relation do |term_relation|
  term_relation.tid1 7
  term_relation.tid2 7
end

Factory.define :term_synonym do |term_synonym|
  term_synonym.tid  7
  term_synonym.name 'some string'
end

Factory.define :url_alias do |url_alias|
  url_alias.src      'some string'
  url_alias.dst      'some string'
  url_alias.language 'some string'
end

Factory.define :user do |user|
  user.name             'some string'
  user.pass             'some string'
  user.mode             7
  user.theme            'some string'
  user.signature        'some string'
  user.signature_format 7
  user.created          7
  user.access           7
  user.login            7
  user.status           7
  user.language         'some string'
  user.picture          'some string'
end

Factory.define :users_role do |users_role|
  users_role.uid 7
  users_role.rid 7
end

Factory.define :variable do |variable|
  variable.value 'some text value'
end

Factory.define :vocabulary do |vocabulary|
  vocabulary.name        'some string'
  vocabulary.help        'some string'
  vocabulary.relations   7
  vocabulary.hierarchy   7
  vocabulary.multiple    7
  vocabulary.required    7
  vocabulary.tags        7
  vocabulary.module      'some string'
  vocabulary.weight      7
end

Factory.define :vocabulary_node_type do |vocabulary_node_type|
  vocabulary_node_type.vid  7
  vocabulary_node_type.type 'some string'
end

Factory.define :watchdog do |watchdog|
  watchdog.uid       7
  watchdog.type      'some string'
  watchdog.message   'some text value'
  watchdog.variables 'some text value'
  watchdog.severity  7
  watchdog.link      'some string'
  watchdog.location  'some text value'
  watchdog.hostname  'some string'
  watchdog.timestamp 7
end

