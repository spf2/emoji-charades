module Extensions
  include ActiveModel::Serialization
  
  def self.included(klass) 
    klass.class_eval do
      alias :as_json :as_json_no_nulls
    end
  end
  
  def as_json_no_nulls(options)
    # NOTE(spf): the null-stripping is only at the top level.
    hash = serializable_hash(options).reject {|key, value| value.nil? }
    hash = { self.class.model_name.underscore => hash } if include_root_in_json
    hash
  end      
end
