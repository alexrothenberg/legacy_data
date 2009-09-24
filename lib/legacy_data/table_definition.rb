module LegacyData
  class TableDefinition
    attr_accessor :class_name, :table_name, :columns, :primary_key, :relations, :constraints

    def initialize(options)
      options.each {|key, value| self.send("#{key}=", value) }
    end
    
    def [] key
      self.send(key)
    end
    
    def to_hash
      hash = {}
      [:class_name, :table_name, :columns, :primary_key, :relations, :constraints].each {|field| hash[field] = self.send(field) }
      hash
    end
    
    def join_table?
      (columns.size == 2) and relations[:belongs_to] and (relations[:belongs_to].values.map(&:to_s) == columns)
    end
    
    def belongs_to_relations
      return {} if relations.nil? or relations[:belongs_to].nil?
      relations[:belongs_to]
    end

    def belongs_to_tables
      return [] if belongs_to_relations == {}
      belongs_to_relations.keys
    end
    
    def convert_has_many_to_habtm(join_table)
      other_table_name = join_table.belongs_to_tables.detect {|table_name| table_name != self.table_name}
      relations[:has_and_belongs_to_many][other_table_name] = { :foreign_key            =>join_table.belongs_to_relations[table_name], 
                                                                :association_foreign_key=>join_table.belongs_to_relations[other_table_name],
                                                                :join_table             =>join_table.table_name.to_sym }
      relations[:has_some].delete(join_table.table_name)                                                          
    end
  end
end