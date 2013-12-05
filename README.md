##Description

Encode/Décode les entités HTML dans un fichier ou les fichiers d'un dossier en ligne de commande.

##Usage

* S'assurer que `encode.rb` et `decode.rb` sont exécutable&nbsp;;
* Se placer dans ce dossier&nbsp;;
* Jouer la commande&nbsp;:

$ ./encode.rb path/to/file/or/folder

##Options

Liste des options utilisables en ligne de commande&nbsp;:

    -v, --verbose             Mode verbeux

    -e=<exts>, --ext=<exts>   Filtre par extensions de fichiers
                              Où <exts> est une liste d'extensions séparées par des
                              virgules SANS espace. P.e. `-e=rb,htm,erb`

    -k, --kill                Ne pas faire de copie de l'original. Sans cette extension
                              le programme produit une copie du fichier original, dans son
                              dossier, en ajoutant `-original` à la fin du nom.