# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{legacy_data}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Rothenberg"]
  s.date = %q{2009-09-29}
  s.description = %q{Create ActiveRecord models from an existing database}
  s.email = %q{alex@alexrothenberg.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "generators/models_from_tables/USAGE",
     "generators/models_from_tables/models_from_tables_generator.rb",
     "generators/models_from_tables/templates/model.rb",
     "legacy_data.gemspec",
     "lib/active_record/connection_adapters/oracle_enhanced_adapter.rb",
     "lib/legacy_data.rb",
     "lib/legacy_data/schema.rb",
     "lib/legacy_data/table_class_name_mapper.rb",
     "lib/legacy_data/table_definition.rb",
     "spec/legacy_data/schema_spec.rb",
     "spec/legacy_data/table_class_name_mapper_spec.rb",
     "spec/legacy_data/table_definition_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/alexrothenberg/legacy_data}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Create ActiveRecord models from an existing database}
  s.test_files = [
    "spec/legacy_data/schema_spec.rb",
     "spec/legacy_data/table_class_name_mapper_spec.rb",
     "spec/legacy_data/table_definition_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
  end
end
