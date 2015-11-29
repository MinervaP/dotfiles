Pry.config.theme = "solarized"

def replace_image_binary(string)
  image_binary_regex = /(?<=")(\\x89PNG|GIF8[79]a|\\xFF\\xD8)((?!",).)*(?=")/
  string.gsub(image_binary_regex) do |s|
    "[Binary #{s.bytesize}]"
  end
end

if defined? PryByebug
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

if defined? AwesomePrint
  AwesomePrint.defaults={
    indent: 2,
  }
  Pry.print = proc { |output, value| output.puts value.is_a?(String) ? replace_image_binary(value) : value }
else
  Pry.print = proc { |output, value| output.puts value.is_a?(String) ? replace_image_binary(value) : value }
end
