#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby 
$KCODE = 'U'

=begin

DESCRIPTION
-----------
Cf. le manuel

=end
BASE = File.dirname(File.expand_path(__FILE__))
require 'fileutils'
require "#{BASE}/lib/functions"


# Définir le file à traiter et analyse les options
# 
analyze_args

# Définir les fichiers à traiter
# 
set_file_list

# Traiter les fichiers à traiter
# 
traite_files encode = true
