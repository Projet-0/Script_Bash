#!/bin/bash


path='/home/mohamed/Bureau/'
file_path='/home/mohamed/Bureau/SFTP/README.md'

parameter () {

	path='Variable initiale a modifier en fonction des boucles' ;
	#echo $@ ; # $@ EST LA VALEUR DE TOUT CE QUI EST PASSE EN ARGUMENT
	local="no value";
	taille="--max-depth=1"
	global="no value for"
	#exclude="./.*"
	# TEST de exclude
	#exclude="[\/]+[.]+"
	exclude="*/.*" 
	while getopts "d:fahsr:o:" OPT; do

	# Je récupère le texte associé à l'option
	case "${OPT}" in
	d) 
	    d_p=${OPTARG}; # dossier a cibler
	    local=`du $d_p $taille`

            ;;	
	h)
	    # h_p=${OPTARG}; # Lisible en Ko,Mo
	    h_p="-h";
	    local=`du $d_p $h_p $taille`
            ;;	
        s)
            #s_v=${OPTARG} # Tri par ordre decroissant
	    s_p="sort -hr "  
	    local=`du $d_p $h_p $taille | sort -nr `
	    ;;
	
	r)
            r_p="${OPTARG}" # utilise un regex
	    echo "$r_p" 
	    echo "je viens de mettre la valeur du regex"
	    ;;
	f)
            f_p="-a";; # On cible egalement les fichiers
	a)
            #a_v=${OPTARG}
	    exclude="()" ;  
	    echo "Je suis ici"
	    ;; # affiche les fichiers/dossiers caches
	o)
            #o_p=${OPTARG};; # ecrit dans un fichier
	#TEST 
	    o_p=${OPTARG}	
	    echo "$o_p"
	    ;;
        *)
            fourth="Error: ${OPT} is not acceptable";; # argument pas acceptanel

    	esac
	done


	## IL faut tout faire a la fin comme ca je peux faire une grande commande

	# JE VAIS METTRE LE REGEX DEDANS TOUT SIMPLEMENT	

	#SORT AND
	if [[ $@ == *"-s"* ]]; 
	then
	#ON CHECK LE REGEX 
	  if [[ $@ == *"-r"* ]]; 
	  then
	    #COMMANDE A METTRE
	    global=`du $h_p $f_p $d_p $taille --exclude=$exclude | $s_p | grep $r_p` # ON CONTIENT LE REGEX ON ENLEVE
	  else 
	    #COMMANDE A METTRE
	    global=`du $h_p $f_p $d_p $taille --exclude=$exclude | $s_p` # PAS DE REGEX
	  fi

	  #global=`du $h_p $d_p $taille | $s_p ` ## COMMANDE DE DEPART

	## PAS DE SORT PAS BESOIN DE TRIER
	else 
	  if [[ $@ == *"-r"* ]]; 
	  then
	    #COMMANDE A METTRE
	    global=`du $h_p $f_p $d_p $taille --exclude=$exclude | grep $r_p` # ON CONTIENT LE REGEX
	  else 
	    #COMMANDE A METTRE
	    global=`du $h_p $f_p $d_p $taille --exclude=$exclude ` # PAS DE REGEX
	  fi
	  #global=`du $h_p $d_p $taille ` ## COMMANDE DE DEPART
	fi



	#SAVE
	
	if [[ $@ == *"-o"* ]]; 
	then
	  echo "$global" > $o_p ;
	  sed -e 's/$/\n-------------------/' -i $o_p ;
	  cat $o_p ;
	  # cat $o_p ;
	  else 
	    echo "value global"
	    echo "$global"
	    echo "end global"
	fi



	#global=`du $h_p $d_p $taille | $s_p`

	#echo "value global"
	#echo "$global"
	#echo "end global"

	
	echo "Value of d  is : $d_p, Value of d_result is :"
	echo "value of local is"
	#echo "$local"


}

echo $@ ;
parameter $@ ;


