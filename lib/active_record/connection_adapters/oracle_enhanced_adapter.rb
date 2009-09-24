module OracleEnhancedAdapterConstraintsMethods

  def foreign_keys_for(table_name)
    (owner, table_name) = @connection.describe(table_name)

    # RSI: changed select from all_constraints to user_constraints - much faster in large data dictionaries
    fks = select_rows(<<-SQL, 'Foreign Keys')
      select parent_c.table_name, cc.column_name
        from user_constraints c, user_constraints parent_c, user_cons_columns cc
      where c.owner = '#{owner}'
        and c.table_name = '#{table_name}'
        and c.r_constraint_name = parent_c.constraint_name
        and c.constraint_type = 'R'
        and cc.owner = c.owner
        and cc.constraint_name = c.constraint_name
    SQL
  end
  def foreign_keys_of(table_name)
    (owner, table_name) = @connection.describe(table_name)

    # RSI: changed select from all_constraints to user_constraints - much faster in large data dictionaries
    fks = select_rows(<<-SQL, 'Remote Foriegn Keys')
      select c.table_name, cc.column_name, c.delete_rule 
        from user_constraints c, user_constraints parent_c, user_cons_columns cc
      where c.owner = '#{owner}'
        and parent_c.table_name = '#{table_name}'
        and c.r_constraint_name = parent_c.constraint_name
        and c.constraint_type = 'R'
        and cc.owner = c.owner
        and cc.constraint_name = c.constraint_name
    SQL
    fks.map do |row| 
      dependent = case row[3] 
        when 'CASCADE'
          :destroy
        when 'SET NULL'
          :nullify
        end
      options = {:to_table => row[0].downcase, :foreign_key =>row[1].downcase.to_sym }
      options[:dependent] = dependent unless dependent.nil?
      options
    end
  end

  def constraints(table_name)
    (owner, table_name) = @connection.describe(table_name)

    # RSI: changed select from all_constraints to user_constraints - much faster in large data dictionaries
    fks = select_rows(<<-SQL, 'User Contraints')
      select c.constraint_name, c.search_condition
        from user_constraints c
      where c.owner = '#{owner}'
        and c.table_name = '#{table_name}'
        and c.constraint_type = 'C'
        and c.generated = 'USER NAME'
        and c.status = 'ENABLED'
    SQL
  end
end

ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.send(:include, OracleEnhancedAdapterConstraintsMethods) if defined? ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter
