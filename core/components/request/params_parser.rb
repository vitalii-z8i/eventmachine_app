module ParamsParser

  def self.parse_params(query_string = '', form_data = '')
    parse_query_string(query_string).merge(parse_form_data(form_data))
  end

  def self.parse_query_string(data = '')
    unless data.nil? || data.empty?
      data = data.split('&')
      data.map {|param| {param.split('=')[0] => param.split('=')[1]} }.inject(&:merge) unless data.empty?
    end
  end

  def self.parse_form_data(data = '')
    {}
  end
end