LOG_PATH = "#{BASE}/log.txt"
OPTIONS  = {
  :original_file          => nil,
  :destination_file       => nil,
  :destination_is_folder  => false,
  :verbose                => false,
  :extensions             => nil,
  :kill                   => false,
  :file_list              => nil,
  :deep                   => true,
} 

$char_to_entity = { }
File.open("#{BASE}/entities.txt").read.scan(/^(\d+)\t(.+)$/) do |key, value|
  $char_to_entity[[key.to_i].pack('U')] = value
end

$entity_to_char = { }
File.open("#{BASE}/entities.txt").read.scan(/^(\d+)\t(.+)$/) do |key, value|
  $entity_to_char[value] = [key.to_i].pack('U')
end

def traite_files encode
  OPTIONS[:file_list].each do |path|
    next if File.directory? path
    next if path.end_with? '-original'
    log "-> Treat file: #{path}"
    code = 
    if encode
      encode_html_entities_in(File.read path)
    else
      decode_html_entities_in(File.read path)
    end
    destination_path = define_destination_path path
    if OPTIONS[:kill]
      File.unlink path if File.exists? path
    elsif destination_path == path
      FileUtils.mv path, "#{path}-original"
    end
    File.open(destination_path,'wb'){ |f| f.write code }
  end
end


def encode_html_entities_in code
  # text.gsub(/[^\x00-\x7F]|["'<>&]/) do |ch|
  code.gsub(/[^\x00-\x7F]/) do |ch|
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

# Détermine le path du fichier de destination
# 
def define_destination_path path
  if OPTIONS[:destination_is_folder]
    File.join(OPTIONS[:destination_file], File.basename(path))
  elsif OPTIONS[:destination_file]
    OPTIONS[:destination_file]
  else
    path
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
  log "=== ENCODE/DECODE HTML #{Time.now.strftime('%d %m %Y - %H:%M')} ===\n"
end

# Liste des fichiers à traiter
def set_file_list
  OPTIONS[:file_list] = 
  if File.directory? OPTIONS[:original_file]
    exts  = OPTIONS[:extensions].nil? ? "" : ".{#{OPTIONS[:extensions]}}"
    depth = OPTIONS[:deep] ? "**/" : ""
    Dir["#{OPTIONS[:original_file]}/#{depth}*#{exts}"]
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
      if OPTIONS[:original_file].nil?
        OPTIONS[:original_file] = arg
      else
        OPTIONS[:destination_file]      = arg
        OPTIONS[:destination_is_folder] = File.directory? arg
      end
    end
  end
  log "OPTIONS : #{OPTIONS.inspect}"
end

def analyze_arg_as_option arg
  arg = arg[1..-1]
  oneletter, args = 
  if arg[0..0] == '-'
    arg = arg[1..-1]
      case arg
      when 'verbose'  then ['v', nil]
      when 'kill'     then ['k', nil]
      when 'ext'      then arg.split('=')
      when 'deep'
        a, v = arg.split('=')
        ['d', v == "false"]
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
  when 'd' then OPTIONS[:deep] = !(args == false || args == "false")
  when 'e'
    OPTIONS[:extensions] = args
    log "Extension filter: #{OPTIONS[:extensions]}"
  end  
end