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

  def save(table, primary_key, **args)
    values = args.values.map {|v| "'#{v}'"}.join ','
    update_attributes = args.reject { |el,| el.eql? primary_key }
    #"INSERT INTO #{table} (#{args.keys.join ','}) VALUES (#{values}) ON DUPLICATE UPDATE #{ update_attributes.map {|k,v| "#{k}='#{v}'"}.join ','}"
    "INSERT INTO #{table} (#{args.keys.join ','}) VALUES (#{values}) ON DUPLICATE KEY UPDATE #{ update_attributes.map {|k,v| "#{k}='#{v}'"}.join ','};"
  end

  def last_insert_id(table)
    "SELECT LAST_INSERT_ID();"
  end
end