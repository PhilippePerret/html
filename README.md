##Description

Encode/Décode les entités HTML dans un fichier ou les fichiers d'un dossier en ligne de commande.

`encode.rb` :

    é => &eacute;

`decode.rb` :

    &eacute; => é

##Usage

* S'assurer que `encode.rb` et `decode.rb` sont exécutable&nbsp;;
* Se placer dans ce dossier&nbsp;;
* Jouer la commande&nbsp;:

        $ ./encode.rb path/to/file/or/folder

##Pré-requis

Régler le BOM en entête des fichiers `encode.rb` et `decode.rb` (dans l'idéal, mettre `#!/urs/bin/env ruby`).

##Options

Liste des options utilisables en ligne de commande&nbsp;:

    -v, --verbose             Mode verbeux

    -e=<exts>, --ext=<exts>   Filtre par extensions de fichiers
                              Où <exts> est une liste d'extensions séparées par des
                              virgules SANS espace. P.e. `-e=rb,htm,erb`

    -k, --kill                Ne pas faire de copie de l'original. Sans cette extension
                              le programme produit une copie du fichier original, dans son
                              dossier, en ajoutant `-original` à la fin du nom.