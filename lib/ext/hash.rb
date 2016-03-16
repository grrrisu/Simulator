class Hash

  # Return a new hash with all keys converted by the block operation.
  # This includes the keys from the root hash and from all
  # nested hashes.
  #
  #  hash = { person: { name: 'Rob', age: '28' } }
  #
  #  hash.deep_transform_keys{ |key| key.to_s.upcase }
  #  # => { "PERSON" => { "NAME" => "Rob", "AGE" => "28" } }
  def deep_transform_keys(&block)
    result = {}
    each do |key, value|
      result[yield(key)] =  if value.is_a?(Hash)
                              value.deep_transform_keys(&block)
                            elsif value.is_a?(Array)
                              value.map {|v| v.is_a?(Hash) ? v.deep_transform_keys(&block) : v}
                            else
                              value
                            end
    end
    result
  end

  def symbolize_keys
    deep_transform_keys {|key| key.to_sym }
  end

end
