class Request
  Dir["#{File.dirname(__FILE__)}/*.rb"].each {|f| require f}
  attr_accessor :uri, :method, :params, :valid

  def initialize(request = '')
    self.method = request[:method]
    self.uri = request[:uri] || '/'
    self.valid ||= false
    self.params = parse_params(request[:params])
  end

  def process
    require File.expand_path("app/controllers/#{self.params[:controller]}.rb")
    p Kernel.const_get(self.params[:controller].capitalize).new(self).response
  rescue LoadError
    raise NoControllerError.new(self.params[:controller])
  # rescue NameError
  #   raise ControllerNotDefinedError.new("app/controllers/#{self.params[:controller]}.rb")
  end

  private
  def parse_params(params)
    query_string, form_data = params

    parse_query_string(query_string).merge(parse_form_data(form_data))
  end

  def parse_query_string(query_string = nil)
    unless query_string.nil?
      query_string.split('&').map do |var|
        var = var.split('=')
        {var[0].to_sym => var[1].gsub('%20', ' ')}
      end.inject(&:merge)
    else
      {}
    end
  end

  def parse_form_data(form_data = nil)
    init_hash = lambda do |keys_arr, index, val|
      if keys_arr[index].nil?
        val.gsub('%20B', ' ')
      elsif keys_arr[index].is_integer?
        {keys_arr[index] => (init_hash.call(keys_arr, index + 1, val))}
      else
        {keys_arr[index] => (init_hash.call(keys_arr, index + 1, val))}
      end
    end
    unless form_data.nil?
      keys = form_data.scan(/name=["'](.*)["']/).map(&:first)
      vals = form_data.scan(/(.*)\n-/).map {|str| str[0].gsub("\r", '')}
      temp_params = Hash[keys.zip(vals)]
      form_params = {}
      temp_params.each do |key, val|
        key_elements = key.split('[').map {|k| k.gsub(']','')}
        form_params.recursive_merge!(init_hash.call(key_elements, 0, val))
      end
      form_params.recursive_to_array!.symbolize_keys_deep!
    else
      {}
    end
  end
end


class String
  def is_integer?
    self.to_i.to_s == self
  end
end

class Hash
  def recursive_merge!(other)
    other.keys.each do |k|
      if self[k].is_a?(Array) && other[k].is_a?(Array)
        self[k] += other[k]
      elsif self[k].is_a?(Hash) && other[k].is_a?(Hash)
        self[k].recursive_merge!(other[k])
      else
        self[k] = other[k]
      end
    end
    self
  end

  def recursive_to_array!
    self.keys.each do |k|
      if self[k].is_a?(Hash)
        if self[k].keys.reject(&:is_integer?).empty?
          self[k] = self[k].values
        else
          self[k] = self[k].recursive_to_array!
        end
      end
    end
    self
  end

  def symbolize_keys_deep!
    self.keys.each do |k|
      ks    = k.to_sym
      self[ks] = self.delete k
      self[ks].symbolize_keys_deep! if self[ks].kind_of?(Hash)
      self[ks] = self[ks].map(&:symbolize_keys_deep!) if self[ks].kind_of?(Array)
    end
    self
  end

end
