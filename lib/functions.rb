LOG_PATH = './log.txt'
OPTIONS  = {
  :verbose        => false,
  :extensions     => nil,
  :original_file  => nil,
  :kill           => false,
  :file_list      => nil
} 

$char_to_entity = { }
File.open("./entities.txt").read.scan(/^(\d+)\t(.+)$/) do |key, value|
  $char_to_entity[[key.to_i].pack('U')] = value
end

$entity_to_char = { }
File.open("./entities.txt").read.scan(/^(\d+)\t(.+)$/) do |key, value|
  $entity_to_char[value] = [key.to_i].pack('U')
end


def encode_html_entities_in text
  # text.gsub(/[^\x00-\x7F]|["'<>&]/) do |ch|
  text.gsub(/[^\x00-\x7F]/) do |ch|
    ent = $char_to_entity[ch]
    ent ? "&#{ent};" : sprintf("&#x%02X;", ch.unpack("U")[0])
  end
end

def decode_html_entities_in code
  code.gsub(/&(?:([a-z0-9]+)|#([0-9]+)|#x([0-9A-F]+));/i) do |m|
    if $1 then
      $entity_to_char[$1] || m
    else
      [$2 ? $2.to_i : $3.hex].pack("U")
    end
  end
end


def log txt
  prepare_log if @reflog.nil?
  @reflog.write("#{txt}\n")
  puts txt if OPTIONS[:verbose]
end

def prepare_log
  File.unlink LOG_PATH if File.exists? LOG_PATH
  @reflog = File.open(LOG_PATH, 'a')
  log "=== #{Time.now.strftime('%d %m %Y - %H:%M')} ===\n"
end

# Liste des fichiers à traiter
def set_file_list
  OPTIONS[:file_list] = 
  if File.directory? OPTIONS[:original_file]
    exts = OPTIONS[:extensions].nil? ? "" : ".{#{OPTIONS[:extensions]}}"
    Dir["#{OPTIONS[:original_file]}/**/*#{exts}"]
  else
    [OPTIONS[:original_file]]
  end
end
# Analyse les arguments passés
# 
def analyze_args
  while arg = ARGV.shift
    if arg[0..0] == "-"
      analyze_arg_as_option arg
    else
      OPTIONS[:original_file] = arg
    end
  end
end

def analyze_arg_as_option arg
  arg = arg[1..-1]
  oneletter, args = 
  if arg[0..0] == '-'
    arg = arg[1..-1]
      case arg
      when 'verbose'  then ['v', nil]
      when 'kill'     then ['k', nil]
      else [nil, nil]
      end
  else
    arg.split('=')
  end
  
  traite_option_one_letter oneletter, args
end

def traite_option_one_letter letter, args
  case letter
  when 'v' then OPTIONS[:verbose]  = true
  when 'k' then OPTIONS[:kill]     = true
  when 'e'
    OPTIONS[:extensions] = args
    log "Extension filter: #{OPTIONS[:extensions]}"
  end  
end