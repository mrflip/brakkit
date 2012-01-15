#
# Fake out just enough ActiveRecord::Base to get by.
#
class SimpleModel
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  extend  ActiveModel::Callbacks

  class_attribute :column_names
  self.column_names = []

  # include Read
  # include Write
  # include BeforeTypeCast
  # include Query
  # include PrimaryKey
  # include TimeZoneConversion
  # include Dirty
  # include Serialization
  # include DeprecatedUnderscoreRead

  def initialize(attributes = nil, options = {})
    assign_attributes(attributes, options) if attributes
    yield self if block_given?
    # run_callbacks :initialize
  end

  def self.has_attribute(attr, opts={})
    self.column_names += [attr.to_s]
    attr_accessor(attr)
  end

  def attributes
    Hash[ self.class.column_names.zip(values) ]
  end

  def values
    self.class.column_names.map{|attr| read_attribute(attr) }
  end

  def attributes=(new_attributes)
    return unless new_attributes.is_a?(Hash)
    assign_attributes(new_attributes)
  end

  def assign_attributes(new_attributes)
    new_attributes.each do |attr, val|
      write_attribute(attr, val)
    end
  end

  # Returns the contents of the record as a nicely formatted string.
  def inspect
    inspection = self.class.column_names.map{|name|
      "#{name}: #{attribute_for_inspect(name)}" if has_attribute?(name)
    }.compact.join(", ")
    "#<#{self.class} #{inspection}>"
  end

  def persisted?
    false
  end

  def self.attribute_names
    column_names
  end

  # Returns an array of names for the attributes available on this object.
  def attribute_names
    self.class.attribute_names
  end

  # Returns true if the given attribute is in the attributes hash
  def has_attribute?(attr_name)
    attribute_names.has_key?(attr_name.to_s)
  end

  # Returns an <tt>#inspect</tt>-like string for the value of the
  # attribute +attr_name+. String attributes are truncated upto 50
  # characters, and Date and Time attributes are returned in the
  # <tt>:db</tt> format. Other attributes return the value of
  # <tt>#inspect</tt> without modification.
  #
  #   person = Person.create!(:name => "David Heinemeier Hansson " * 3)
  #
  #   person.attribute_for_inspect(:name)
  #   # => '"David Heinemeier Hansson David Heinemeier Hansson D..."'
  #
  #   person.attribute_for_inspect(:created_at)
  #   # => '"2009-01-12 04:48:57"'
  def attribute_for_inspect(attr_name)
    value = read_attribute(attr_name)

    if value.is_a?(String) && value.length > 50
      "#{value[0..50]}...".inspect
    elsif value.is_a?(Date) || value.is_a?(Time)
      %("#{value.to_s(:db)}")
    else
      value.inspect
    end
  end

  # Returns true if the specified +attribute+ has been set by the user or by a database load and is neither
  # nil nor empty? (the latter only applies to objects that respond to empty?, most notably Strings).
  def attribute_present?(attribute)
    value = read_attribute(attribute)
    !value.nil? || (value.respond_to?(:empty?) && !value.empty?)
  end

protected

  def read_attribute(attr)
    self.send(attr)
  end

  def write_attribute(attr, val)
    self.send("#{attr}=", val)
  end

  def clone_attributes(reader_method = :read_attribute, attributes = {})
    attribute_names.each do |name|
      attributes[name] = clone_attribute_value(reader_method, name)
    end
    attributes
  end

  def clone_attribute_value(reader_method, attribute_name)
    value = send(reader_method, attribute_name)
    value.duplicable? ? value.clone : value
  rescue TypeError, NoMethodError
    value
  end

  def attribute_method?(attr_name)
    attr_name == 'id' || (defined?(@attributes) && @attributes.include?(attr_name))
  end

public

  # Returns the value of the attribute identified by <tt>attr_name</tt> after it has been typecast (for example,
  # "2004-12-12" in a data column is cast to a date object, like Date.new(2004, 12, 12)).
  # (Alias for the protected read_attribute method).
  alias [] read_attribute

  # Updates the attribute identified by <tt>attr_name</tt> with the specified +value+.
  # (Alias for the protected write_attribute method).
  alias []= write_attribute

end
