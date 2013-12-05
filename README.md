##Description

Encode/Décode les entités HTML dans un fichier ou les fichiers d'un dossier en ligne de commande.

`encode.rb` :

    é => &eacute;

`decode.rb` :

    &eacute; => é

##Usage

* S'assurer que `encode.rb` et `decode.rb` sont exécutables&nbsp;;
* Se placer dans ce dossier `html`&nbsp;;
* Jouer la commande&nbsp;:

        $ ./encode.rb path/to/file/or/folder

###Syntaxe complète

    $ ./[encode|decode].rb [options] path/to/file/or/folder [path/to/destination]

`path/to/destination` peut être un dossier dans lequel seront mis tous les fichiers traités. Si `path/to/file/or/folder` est un fichier unique, `path/to_destination`
peut être le path (exact) du fichier destination.

**Exemples**

    $ ./decode.rb ~/Sites/essai
    # Décode (`decode.rb`) tous les fichiers du dossier `~/Sites/essai` (et
    # ses sous-dossiers) sans filtre d'extension, en mode silencieux et en 
    # faisant une copie du fichier original.
    
    $ ./encode.rb -v -e=rb,htm -k --deep=false ~/Sites/essai
    # Encode (encode.rb) tous les fichiers du dossier `Sites/essai`, sans traiter
    # ses sous-dossiers (`--deep=false`) en ne traitant que les fichiers d'extension `rb` 
    # ou `htm`, en mode verbose (`-v`) et sans faire de copie du fichier original (`-k`)

    $ ./encode.rb ~/Sites/essai/mon_fichier.txt ~/Sites/essai/mon_fichier.html
    # Encode le fichier `mon_fichier.txt` dans le fichier `mon_fichier.html`
    
    $ ./decode.rb -d=false ~/Sites/essai ~/Sites/html_files
    # Note: `~/Sites/html_files` est un dossier EXISTANT
    # Décode tous les fichiers du dossier `essai` et les met dans le dossier
    # `html_files`
    
##Pré-requis

Régler le BOM en entête des fichiers `encode.rb` et `decode.rb` (dans l'idéal, mettre `#!/usr/bin/env ruby`).

##Options

Liste des options utilisables en ligne de commande&nbsp;:

    -v, --verbose             Mode verbeux

    -e=<exts>, --ext=<exts>   Filtre par extensions de fichiers
                              Où <exts> est une liste d'extensions séparées par des
                              virgules SANS espace. P.e. `-e=rb,htm,erb`
    -d=<val>, --deep=<val>    Mode “deep”. Par défaut, les scripts traitent les dossiers
                              en profondeur (dossier et sous-dossiers). Mettre `<val>` à
                              false pour ne traiter que le dossier donné en argument.
    -k, --kill                Ne pas faire de copie de l'original. Sans cette extension
                              le programme produit une copie du fichier original, dans son
                              dossier, en ajoutant `-original` à la fin du nom.
                              
##Notes

Ne transforme pas les caractères `&`, `<` et `>`, pour pouvoir traiter les fichiers déjà balisés.