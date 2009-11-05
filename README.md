# Legacy Data

The canonical way to start a Rails project is outside-in starting with the UI and working your way down through the controller and model until you create actual database tables with a migration.  That's great when you're starting from scratch but what can you do when you've already got an existing database you need to build an application on top of?  

The `models_from_tables` generator in the `legacy_data` gem can help!  This generator will look into your existing database to understand the information encoded in there then generate models for those tables.

## How to use it

- To generate an ActiveRecord model for each table in the database just type

  `script/generate script/generate models_from_tables`

- If you don't want all tables in the database tell it which table to model
 
  `script/generate script/generate models_from_tables --table-name comments`
  
  This uses any foreign_key constraints in the database to spider the database and model the comments table and all associated tables.
  
- If you *really* only want the comments table tell it not to follow any foreign_keys

  `script/generate script/generate models_from_tables --table-name comments --skip-associated`

(You do need to install the plugin `gem install legacy_data` as long as http://gemcutter.org is one of your gem sources)

### Examples

Several examples come with the gem source in the [examples](http://github.com/alexrothenberg/legacy_data/tree/master/examples/) folder.  These include 

- A simple blog database tested with MySQL and Sqlite3
- The Drupal 6.14 database tested with MySQL
- The J2EE Petstore example tested with MySQL, Sqlite3 and Oracle

## What kind of information can it extract from the database?

### Associations

If the database contains foreign_key constraints it uses them to build `has_many` or `belongs_to` associations
in your ActiveRecord models

### Validation constraints

It will generate the following types of validation constraints in your models

- **validates_uniqueness_of**   - For columns where the database has an index that enforces uniqueness
- **validates_presence_of**     - When the database column is non-nullable
- **validates_inclusion_of**    - For non-nullable boolean columns and custom constraints with a SQL rule "flag IN ('Y', 'N')"
- **validates_numericality_of** - For integer columns (nullable and non-nullable)
- **custom validation**         - For custom SQL validation rules in the database it puts a placeholder in your model with the original SQL for you to translate into Ruby

###Non-Rails naming conventions

Since the database is existing it's likely that it doesn't follow Rails naming conventions.  Not to worry as the generator will 
put the non-standard name into the generated models if it needs to.  

What kinds of non-standard names can it generate?

Let's look at a sample output

<pre><code>
class Post < ActiveRecord::Base

  set_table_name  :tbpost
  set_primary_key :postid
  
  # Relationships
  has_many :comments, :foreign_key => :postid

  # Constraints
  validates_presence_of :title, :body
  
end
</code></pre>

- **Class Names**  - It named the model *Post* instead of the Rails convention *Tbpost*. The generator could not do this itself but knowing the conventions will often not apply to legacy databases it pauses after spidering the database giving you a chance to override the table to class name mapping.  It generates a yaml file `app/models/table_mappings.yml` where you can verify or change any class name before  proceeding to generate the models. 
- **Table Names**  - It overrode the table name since the actual name *tbpost* does not match the Rails naming convention *posts*
- **Primary Keys** - It overrode the primary key since the actual column *postid* does not match the Rails naming convention *id*
- **Foreign Keys** - It overrode the foreign key on the comment table to be *postid* instead of the Rails naming convention *id*


# Copyright

Copyright (c) 2009 Alex Rothenberg. See LICENSE for details.
