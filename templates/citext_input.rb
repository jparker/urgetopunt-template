# Placeholder class to tell SimpleForm to treat citext columns as strings
class CitextInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_html_classes << 'form-control' << 'string'
    @builder.text_field attribute_name, input_html_options
  end
end
