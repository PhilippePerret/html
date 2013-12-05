#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby 
$KCODE = 'U'

=begin

DESCRIPTION
-----------
Reçoit un fichier ou un dossier et transforme toutes les caractères spéciaux 
en entités HTML.

USAGE
-----

# Se placer dans le dossier de ce fichier

    $ ./encode.rb [options] path/to/file/or/folder

# Par exemple (pour filtrer des extensions et se mettre en mode verbeux)

    $ ./encode.rb -v -e=rb,html ~/Sites/essai/dossier_des_textes


OPTIONS
-------

  -v,       --verbose     Verbose
  -k,       --kill        Ne conserve pas le fichier original. False par défaut,
                          une copie est conservée, de nom <nom original>-original
  -e=<ext>, --ext=<ext>   Liste des extensions de fichiers à traiter
                          <ext> est une liste d'extensions séparées par des virgules
                                SANS espace. P.e. : -e=rb,htm,html

NOTES
-----
Ne transforme pas les `&', `<' et `>' (pour pouvoir envoyer un texte balisé)

=end

require 'fileutils'
require './lib/functions'


# Définir le file à traiter et analyse les options
# 
analyze_args

# Définir les fichiers à traiter
# 
set_file_list

# Traiter les fichiers à traiter
# 
OPTIONS[:file_list].each do |path|
  log "-> File: #{path}"
  code = encode_html_entities_in(File.read path)
  if OPTIONS[:kill]
    File.unlink path if File.exists? path
  else
    FileUtils.mv path, "#{path}-original"
  end
  File.open(path,'wb'){ |f| f.write code }
end
