class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, :hidden_field_tag, :check_box_tag, :radio_button_tag, :link_to, :to => :@template

  def error_messages
    if object.errors.full_messages.any?
      content_tag(:div, :class => 'alert-message block-message error') do
        link_to('&times;'.html_safe, '#', :class => 'close') +
        content_tag(:p, "<strong>Oh no! The robots are angry!</strong> Fix the errors below and try again.".html_safe) +
        content_tag(:ul) do
          object.errors.full_messages.map do |message|
            content_tag(:li, message)
          end.join('').html_safe
        end
      end
    else
      '' # return empty string
    end
  end

  %w(collection_select select email_field file_field number_field password_field phone_field radio_button range_field search_field telephone_field text_area text_field url_field).each do |method_name|
    define_method(method_name) do |name, *args, &block|
      @name = name
      @options = args.extract_options!
      @args = args

      form_input_div do
        label_field + input_div do
          extras{ super(name, *args, @options) }
        end
      end
    end
  end

  def display_field(name, *args, &block)
    @name = name
    @options = args.extract_options!
    @args = args

    form_input_div do
      content_tag(:div, (@options[:label] || @name.to_s.humanize), :class => 'form-spacer') +
        input_div do
        extras{ content_tag(:span, object.send(@name), :class => html_class('display-field')) }
      end
    end
  end

  %w(check_box).each do |method_name|
    define_method(method_name) do |name, *args, &block|
      @name = name
      @options = args.extract_options!
      @args = args

      form_input_div do
        input_div do
          content_tag(:ul, :class => html_class('inputs-list')) do
            content_tag(:li) do
              label_field do
                extras{ super(name, *args, @options) } + content_tag(:span, (options[:label] || @name.to_s.humanize))
              end
            end
          end
        end
      end
    end
  end

  def collection_check_boxes(attribute, records, record_id, record_name, *args)
    @name = attribute
    @options = args.extract_options!
    @args = args

    form_input_div do
      label_field + input_div do
        extras do
          content_tag(:ul, :class => html_class('inputs-list')) do
            records.collect do |record|
              element_id = "#{object_name}_#{attribute}_#{record.send(record_id)}"
              checkbox = check_box_tag("#{object_name}[#{attribute}][]", record.send(record_id), object.send(attribute).include?(record.send(record_id)), :id => element_id)

              content_tag(:li) do
                content_tag(:label) do
                  checkbox + content_tag(:span, record.send(record_name))
                end
              end
            end.join('').html_safe
          end
        end
      end + hidden_field_tag("#{object_name}[#{attribute}][]")
    end
  end

  def collection_radio_buttons(attribute, records, record_id, record_name, *args)
    @name = attribute
    @options = args.extract_options!
    @args = args

    form_input_div do
      label_field + input_div do
        extras do
          content_tag(:ul, :class => html_class('inputs-list')) do
            records.collect do |record|
              element_id = "#{object_name}_#{attribute}_#{record.send(record_id)}"
              radiobutton = radio_button_tag("#{object_name}[#{attribute}][]", record.send(record_id), object.send(attribute) == record.send(record_id), :id => element_id)

              content_tag(:li) do
                content_tag(:label) do
                  radiobutton + content_tag(:span, record.send(record_name))
                end
              end
            end.join('').html_safe
          end
        end
      end
    end
  end

  def uneditable_field(name, *args)
    @name = name
    @options = args.extract_options!
    @args = args

    form_input_div do
      label_field + input_div do
        extras do
          content_tag(:span, :class => html_class('uneditable-input')) do
            @options[:value] || object.send(@name.to_sym)
          end
        end
      end
    end
  end

  def submit(name = nil, *args)
    @name = name
    @options = args.extract_options!
    @args = args

    @options[:class] = 'btn primary'

    super(name, *args << @options) + ' ' + link_to('Cancel', :back, :class => 'btn')
  end

private

  def html_class(classes, options={})
    [classes, options[:class]].flatten.compact.join(" ")
  end

  def form_input_div(&block)
    @options[:error] = object.errors[@name].collect{|e| "#{@options[:label] || @name} #{e}".humanize}.join(', ') unless object.errors[@name].empty?

    hclasses = ['form_input']
    hclasses << 'error' if @options[:error]
    hclasses << 'success' if @options[:success]
    hclasses << 'warning' if @options[:warning]
    hclass = html_class(hclasses)

    content_tag(:div, :class => hclass, &block)
  end

  def input_div(&block)
    content_tag(:div, :class => html_class('input')) do
      if @options[:append] || @options[:prepend]
        hclass = 'input-prepend' if @options[:prepend]
        hclass = 'input-append' if @options[:append]
        content_tag(:div, :class => hclass, &block)
      else
        yield if block_given?
      end
    end
  end

  def label_field(&block)
    required = object.class.validators_on(@name).any?{|v| v.kind_of? ActiveModel::Validations::PresenceValidator }
    label(* [@name, @options[:label], :class => ('required' if required)].compact, &block)
  end

  %w(help_inline advice help_right error success warning help_block append prepend).each do |method_name|
    define_method(method_name) do |*args|
      return '' unless value = @options[method_name.to_sym]
      hclass = 'help-inline'
      hclass = 'help-advice'            if method_name == 'advice'
      hclass = 'help-block'             if method_name == 'help_block'
      hclass = 'help-block align-right' if method_name == 'help_right'
      hclass = 'add-on' if method_name == 'append' || method_name == 'prepend'
      content_tag(:span, value, :class => hclass)
    end
  end

  def extras(&block)
    [prepend, (yield if block_given?), append, error, success, warning, help_inline, advice, help_block, help_right].join('').html_safe
  end

  def objectify_options(options)
    super.except(:label, :error, :success, :warning, :help_inline, :advice, :help_block, :help_right, :prepend, :append)
  end
end
