# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{legacy_data}
  s.version = "0.1.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Rothenberg"]
  s.date = %q{2010-03-05}
  s.description = %q{Create ActiveRecord models from an existing database}
  s.email = %q{alex@alexrothenberg.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "History.txt",
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "examples/README",
     "examples/blog_migration.rb",
     "examples/create_j2ee_petstore.sql",
     "examples/delete_j2ee_petstore.sql",
     "examples/drupal_6_14.sql",
     "examples/generated/blog_mysql/comment.rb",
     "examples/generated/blog_mysql/factories.rb",
     "examples/generated/blog_mysql/post.rb",
     "examples/generated/blog_mysql/tag.rb",
     "examples/generated/blog_sqlite3/comment.rb",
     "examples/generated/blog_sqlite3/factories.rb",
     "examples/generated/blog_sqlite3/post.rb",
     "examples/generated/blog_sqlite3/tag.rb",
     "examples/generated/drupal_mysql/access.rb",
     "examples/generated/drupal_mysql/action.rb",
     "examples/generated/drupal_mysql/actions_aid.rb",
     "examples/generated/drupal_mysql/authmap.rb",
     "examples/generated/drupal_mysql/batch.rb",
     "examples/generated/drupal_mysql/block.rb",
     "examples/generated/drupal_mysql/blocks_role.rb",
     "examples/generated/drupal_mysql/box.rb",
     "examples/generated/drupal_mysql/cache.rb",
     "examples/generated/drupal_mysql/cache_block.rb",
     "examples/generated/drupal_mysql/cache_filter.rb",
     "examples/generated/drupal_mysql/cache_form.rb",
     "examples/generated/drupal_mysql/cache_menu.rb",
     "examples/generated/drupal_mysql/cache_page.rb",
     "examples/generated/drupal_mysql/cache_update.rb",
     "examples/generated/drupal_mysql/comment.rb",
     "examples/generated/drupal_mysql/factories.rb",
     "examples/generated/drupal_mysql/filter.rb",
     "examples/generated/drupal_mysql/filter_format.rb",
     "examples/generated/drupal_mysql/flood.rb",
     "examples/generated/drupal_mysql/history.rb",
     "examples/generated/drupal_mysql/menu_custom.rb",
     "examples/generated/drupal_mysql/menu_link.rb",
     "examples/generated/drupal_mysql/menu_router.rb",
     "examples/generated/drupal_mysql/node.rb",
     "examples/generated/drupal_mysql/node_access.rb",
     "examples/generated/drupal_mysql/node_comment_statistic.rb",
     "examples/generated/drupal_mysql/node_counter.rb",
     "examples/generated/drupal_mysql/node_revision.rb",
     "examples/generated/drupal_mysql/node_type.rb",
     "examples/generated/drupal_mysql/permission.rb",
     "examples/generated/drupal_mysql/role.rb",
     "examples/generated/drupal_mysql/session.rb",
     "examples/generated/drupal_mysql/system.rb",
     "examples/generated/drupal_mysql/term_data.rb",
     "examples/generated/drupal_mysql/term_hierarchy.rb",
     "examples/generated/drupal_mysql/term_node.rb",
     "examples/generated/drupal_mysql/term_relation.rb",
     "examples/generated/drupal_mysql/term_synonym.rb",
     "examples/generated/drupal_mysql/uploaded_files.rb",
     "examples/generated/drupal_mysql/url_alias.rb",
     "examples/generated/drupal_mysql/user.rb",
     "examples/generated/drupal_mysql/users_role.rb",
     "examples/generated/drupal_mysql/variable.rb",
     "examples/generated/drupal_mysql/vocabulary.rb",
     "examples/generated/drupal_mysql/vocabulary_node_type.rb",
     "examples/generated/drupal_mysql/watchdog.rb",
     "examples/generated/j2ee_petstore_mysql/address.rb",
     "examples/generated/j2ee_petstore_mysql/category.rb",
     "examples/generated/j2ee_petstore_mysql/factories.rb",
     "examples/generated/j2ee_petstore_mysql/id_gen.rb",
     "examples/generated/j2ee_petstore_mysql/item.rb",
     "examples/generated/j2ee_petstore_mysql/product.rb",
     "examples/generated/j2ee_petstore_mysql/seller_contact_info.rb",
     "examples/generated/j2ee_petstore_mysql/tag.rb",
     "examples/generated/j2ee_petstore_mysql/tag_item.rb",
     "examples/generated/j2ee_petstore_mysql/ziplocation.rb",
     "examples/generated/j2ee_petstore_oracle/address.rb",
     "examples/generated/j2ee_petstore_oracle/category.rb",
     "examples/generated/j2ee_petstore_oracle/factories.rb",
     "examples/generated/j2ee_petstore_oracle/id_gen.rb",
     "examples/generated/j2ee_petstore_oracle/item.rb",
     "examples/generated/j2ee_petstore_oracle/product.rb",
     "examples/generated/j2ee_petstore_oracle/sellercontactinfo.rb",
     "examples/generated/j2ee_petstore_oracle/tag.rb",
     "examples/generated/j2ee_petstore_oracle/ziplocation.rb",
     "examples/generated/j2ee_petstore_sqlite3/address.rb",
     "examples/generated/j2ee_petstore_sqlite3/category.rb",
     "examples/generated/j2ee_petstore_sqlite3/factories.rb",
     "examples/generated/j2ee_petstore_sqlite3/id_gen.rb",
     "examples/generated/j2ee_petstore_sqlite3/item.rb",
     "examples/generated/j2ee_petstore_sqlite3/product.rb",
     "examples/generated/j2ee_petstore_sqlite3/seller_contact_info.rb",
     "examples/generated/j2ee_petstore_sqlite3/tag.rb",
     "examples/generated/j2ee_petstore_sqlite3/tag_item.rb",
     "examples/generated/j2ee_petstore_sqlite3/ziplocation.rb",
     "generators/models_from_tables/USAGE",
     "generators/models_from_tables/models_from_tables_generator.rb",
     "generators/models_from_tables/templates/model.rb",
     "legacy_data.gemspec",
     "lib/active_record/connection_adapters/oracleenhanced_adapter.rb",
     "lib/legacy_data.rb",
     "lib/legacy_data/schema.rb",
     "lib/legacy_data/table_class_name_mapper.rb",
     "lib/legacy_data/table_definition.rb",
     "spec/expected/factories.rb",
     "spec/expected/post.rb",
     "spec/functional/blog_adapterspec.rb",
     "spec/functional/database.yml",
     "spec/functional/drupal_adapterspec.rb",
     "spec/functional/functional_spec_helper.rb",
     "spec/functional/j2ee_petstore_adapterspec.rb",
     "spec/legacy_data/schema_spec.rb",
     "spec/legacy_data/table_class_name_mapper_spec.rb",
     "spec/legacy_data/table_definition_spec.rb",
     "spec/models_from_tables_generator_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/alexrothenberg/legacy_data}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Create ActiveRecord models from an existing database}
  s.test_files = [
    "spec/expected/factories.rb",
     "spec/expected/post.rb",
     "spec/functional/blog_adapterspec.rb",
     "spec/functional/drupal_adapterspec.rb",
     "spec/functional/functional_spec_helper.rb",
     "spec/functional/j2ee_petstore_adapterspec.rb",
     "spec/legacy_data/schema_spec.rb",
     "spec/legacy_data/table_class_name_mapper_spec.rb",
     "spec/legacy_data/table_definition_spec.rb",
     "spec/models_from_tables_generator_spec.rb",
     "spec/spec_helper.rb",
     "examples/blog_migration.rb",
     "examples/generated/blog_mysql/comment.rb",
     "examples/generated/blog_mysql/factories.rb",
     "examples/generated/blog_mysql/post.rb",
     "examples/generated/blog_mysql/tag.rb",
     "examples/generated/blog_sqlite3/comment.rb",
     "examples/generated/blog_sqlite3/factories.rb",
     "examples/generated/blog_sqlite3/post.rb",
     "examples/generated/blog_sqlite3/tag.rb",
     "examples/generated/drupal_mysql/access.rb",
     "examples/generated/drupal_mysql/action.rb",
     "examples/generated/drupal_mysql/actions_aid.rb",
     "examples/generated/drupal_mysql/authmap.rb",
     "examples/generated/drupal_mysql/batch.rb",
     "examples/generated/drupal_mysql/block.rb",
     "examples/generated/drupal_mysql/blocks_role.rb",
     "examples/generated/drupal_mysql/box.rb",
     "examples/generated/drupal_mysql/cache.rb",
     "examples/generated/drupal_mysql/cache_block.rb",
     "examples/generated/drupal_mysql/cache_filter.rb",
     "examples/generated/drupal_mysql/cache_form.rb",
     "examples/generated/drupal_mysql/cache_menu.rb",
     "examples/generated/drupal_mysql/cache_page.rb",
     "examples/generated/drupal_mysql/cache_update.rb",
     "examples/generated/drupal_mysql/comment.rb",
     "examples/generated/drupal_mysql/factories.rb",
     "examples/generated/drupal_mysql/filter.rb",
     "examples/generated/drupal_mysql/filter_format.rb",
     "examples/generated/drupal_mysql/flood.rb",
     "examples/generated/drupal_mysql/history.rb",
     "examples/generated/drupal_mysql/menu_custom.rb",
     "examples/generated/drupal_mysql/menu_link.rb",
     "examples/generated/drupal_mysql/menu_router.rb",
     "examples/generated/drupal_mysql/node.rb",
     "examples/generated/drupal_mysql/node_access.rb",
     "examples/generated/drupal_mysql/node_comment_statistic.rb",
     "examples/generated/drupal_mysql/node_counter.rb",
     "examples/generated/drupal_mysql/node_revision.rb",
     "examples/generated/drupal_mysql/node_type.rb",
     "examples/generated/drupal_mysql/permission.rb",
     "examples/generated/drupal_mysql/role.rb",
     "examples/generated/drupal_mysql/session.rb",
     "examples/generated/drupal_mysql/system.rb",
     "examples/generated/drupal_mysql/term_data.rb",
     "examples/generated/drupal_mysql/term_hierarchy.rb",
     "examples/generated/drupal_mysql/term_node.rb",
     "examples/generated/drupal_mysql/term_relation.rb",
     "examples/generated/drupal_mysql/term_synonym.rb",
     "examples/generated/drupal_mysql/uploaded_files.rb",
     "examples/generated/drupal_mysql/url_alias.rb",
     "examples/generated/drupal_mysql/user.rb",
     "examples/generated/drupal_mysql/users_role.rb",
     "examples/generated/drupal_mysql/variable.rb",
     "examples/generated/drupal_mysql/vocabulary.rb",
     "examples/generated/drupal_mysql/vocabulary_node_type.rb",
     "examples/generated/drupal_mysql/watchdog.rb",
     "examples/generated/j2ee_petstore_mysql/address.rb",
     "examples/generated/j2ee_petstore_mysql/category.rb",
     "examples/generated/j2ee_petstore_mysql/factories.rb",
     "examples/generated/j2ee_petstore_mysql/id_gen.rb",
     "examples/generated/j2ee_petstore_mysql/item.rb",
     "examples/generated/j2ee_petstore_mysql/product.rb",
     "examples/generated/j2ee_petstore_mysql/seller_contact_info.rb",
     "examples/generated/j2ee_petstore_mysql/tag.rb",
     "examples/generated/j2ee_petstore_mysql/tag_item.rb",
     "examples/generated/j2ee_petstore_mysql/ziplocation.rb",
     "examples/generated/j2ee_petstore_oracle/address.rb",
     "examples/generated/j2ee_petstore_oracle/category.rb",
     "examples/generated/j2ee_petstore_oracle/factories.rb",
     "examples/generated/j2ee_petstore_oracle/id_gen.rb",
     "examples/generated/j2ee_petstore_oracle/item.rb",
     "examples/generated/j2ee_petstore_oracle/product.rb",
     "examples/generated/j2ee_petstore_oracle/sellercontactinfo.rb",
     "examples/generated/j2ee_petstore_oracle/tag.rb",
     "examples/generated/j2ee_petstore_oracle/ziplocation.rb",
     "examples/generated/j2ee_petstore_sqlite3/address.rb",
     "examples/generated/j2ee_petstore_sqlite3/category.rb",
     "examples/generated/j2ee_petstore_sqlite3/factories.rb",
     "examples/generated/j2ee_petstore_sqlite3/id_gen.rb",
     "examples/generated/j2ee_petstore_sqlite3/item.rb",
     "examples/generated/j2ee_petstore_sqlite3/product.rb",
     "examples/generated/j2ee_petstore_sqlite3/seller_contact_info.rb",
     "examples/generated/j2ee_petstore_sqlite3/tag.rb",
     "examples/generated/j2ee_petstore_sqlite3/tag_item.rb",
     "examples/generated/j2ee_petstore_sqlite3/ziplocation.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<matthuhiggins-foreigner>, [">= 0.2.1"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<matthuhiggins-foreigner>, [">= 0.2.1"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<matthuhiggins-foreigner>, [">= 0.2.1"])
  end
end
