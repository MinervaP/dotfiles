def replace_image_binary(string)
  image_binary_regex = /(?<=")(\\x89PNG|GIF8[79]a|\\xFF\\xD8)((?!",).)*(?=")/
  string.gsub(image_binary_regex) do |s|
    "[Binary #{s.bytesize}]"
  end
end

if defined? Hirb
  Hirb.enable
end

if defined? PryByebug
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

if defined? AwesomePrint
  Pry.print = proc { |output, value| output.puts replace_image_binary(value.ai) }
else
  Pry.print = proc { |output, value| output.puts replace_image_binary(value) }
end
