class RequestBuilder
  TYPES_MAP = {
      pk: "INT PRIMARY KEY AUTO_INCREMENT",
      int: "INTEGER",
      string: "VARCHAR(255)"
  }
  def convert_type(type)
    if TYPES_MAP.include? type.to_sym
      TYPES_MAP[type.to_sym]
    else
      raise FileStructureError, :invalid_column_type
    end
  end

  def create_table(name, columns)
    columns = columns.map {|k, v| "#{k} #{convert_type v}" }
    "CREATE TABLE IF NOT EXISTS #{name} (#{columns.join ','});"
  end

  def search(table, **args)
    where_conditions = args.map { |k,v| "#{k}='#{v}'"}
    "SELECT * FROM #{table} WHERE (#{where_conditions.join ','})"
  end

  def show_columns(table)
    "SHOW COLUMNS FROM #{table}"
  end
end