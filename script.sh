#!/bin/bash


path='/home/mohamed/Bureau/'
file_path='/home/mohamed/Bureau/SFTP/README.md'


# On va simplifier les commandes avec du -sh * | sort -n | awk '{print $1}'


# IMPORTANT JE VIENS DE le remarquer IL FAUT FAIRE UNE VARIABLE DE LA FONCTION QUi prendra des nouvelles valeurs des qu elle passe dans un case

#test if the path is a file or a folder 





# RAPPEL DES CONSIGNES 

# Sans argument, il affichera un tableau indiquant la taille du répertoire courant et de ses sous-dossiers directs .

#	-d <dossier>` permettra de cibler un autre dossier que le répertoire courant
#	-h affichera les tailles des différents dossiers de manière lisible pour un être humain (Ko, Mo, Go...)
#	-s triera les résultats obtenus par ordre décroissant d’espace disque utilisé
#	-r <regex>` ciblera uniquement les éléments correspondant à l’expression régulière passée en paramètre
#	-f affichera également les fichiers du dossier ciblé, en plus de ses sous-dossiers directs
#	-a prendra en compte dans son affichage les fichiers et dossiers cachés
# 	-o <fichier>` renverra le résultat dans un fichier, en indiquant la date et l’heure du lancement du script

#	Les options sont cumulables entre elles, par exemple :

#	- dirstat.sh -h -s` affichera les tailles du répertoire courant et de ses sous-dossiers directs, de manière lisible pour un être humain, triées par ordre décroissant
#	- dirstat.sh -d ∼/Videos/ -f -r "unicorn"` affichera la taille du répertoire Videos et de ses fichiers et sous-dossiers directs dont le nom contient unicorn



#Début des fonctions

file_or_directory () {
	if [[ -f $1 ]]
	then
	    echo "$1 this is a file in the system."
	elif [[ -d $1 ]]
	then
	    echo "$1 this is a directory."
	else
	    echo "the type or the file is not good"

	fi


}
#file_or_directory $file_path ;




#test get all the file in an array and display their size

get_all () {
	test= `du -sh * | sort -n | awk 'NR==1{print $1}' ` ;
	count=0 ; 

	#myarray=`ls -Aa` ;

	myarray=`du -sh * | sort -n`
	myarray_size=("result") ;

	
	for str in ${myarray[@]}; do
		if [[ -f $str ]]
		then
		    myarray_size[${#myarray_size[@]}]=`du -sh $str` 
		    echo "The size of the file is:`du -sh $str` "
		    echo "--------------------------------------"
		elif [[ -d $str ]]
		then
		    myarray_size[${#myarray_size[@]}]=`du -sh $str` 
		    echo "The size of the folder is:`du -sh $str` "
		    echo "--------------------------------------"
		else 
		    myarray_size[${#myarray_size[@]}]=`du -sh $str` 
		    echo "The type is not recognize:`du -sh $str` "
		    echo "--------------------------------------"
		fi
	done

	for str in ${myarray_size[@]}; do
	    echo $str
	done

	for new in ${test[@]}; do
	    echo " value of the $new"
	done
}

#get_all 


#Display the size of a folder
size_folder () {
  variable="du -sh $1" ;
  $variable ;
}

#count number of folder
display_folder () {
	ls -a $1| sed 's/[^,]//g' | wc -c 
}


# realise a loop
loop() {
	for i in $(seq 1 $1)
	do
	
    		echo "iteration de la boucle" ;
	done
}

#count number of parameters
number () {
	echo $# ; 
}


# loop $# ;









function_display () {
	variable_local="";
	while getopts "d:h:s:r:f:a:o:" OPT; do
	case "${OPT}" in
	d)
	    d_p=${OPTARG};
	    $variable_local = `du -s $1 --max-depth=2 `  ; 
            ;;	
        *)
            $variable_local="Error: ${OPT} is not acceptable";;

    	esac
	done

	return $variable_local ;

} 

## PROBLEME PIP 

## ON SE RAPELLE --exclude="./.*" PERMET D'ENLEVER PAR DEFAUT LES FICHIERS CACHEES desactive si TIRET a. Et SI ON VEUT AFFICHER LES FICHIERS TOUS oN met -a


parameter () {

	path='Variable initiale a modifier en fonction des boucles' ;
	#echo $@ ; # $@ EST LA VALEUR DE TOUT CE QUI EST PASSE EN ARGUMENT
	local="no value";
	taille="--max-depth=2"
	global="no value for"
	#exclude="./.*"
	# TEST de exclude
	exclude="[\/]+[.]+"

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
	    exclude="" ;  
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
	    global=`du $h_p $f_p $d_p $taille | $s_p | grep $r_p` # ON CONTIENT LE REGEX ON ENLEVE
	  else 
	    #COMMANDE A METTRE
	    global=`du $h_p $f_p $d_p $taille | $s_p` # PAS DE REGEX
	  fi

	  #global=`du $h_p $d_p $taille | $s_p ` ## COMMANDE DE DEPART

	## PAS DE SORT PAS BESOIN DE TRIER
	else 
	  if [[ $@ == *"-r"* ]]; 
	  then
	    #COMMANDE A METTRE
	    global=`du $h_p $f_p $d_p $taille | grep $r_p` # ON CONTIENT LE REGEX
	  else 
	    #COMMANDE A METTRE
	    global=`du $h_p $f_p $d_p $taille` # PAS DE REGEX
	  fi
	  #global=`du $h_p $d_p $taille ` ## COMMANDE DE DEPART
	fi


	#REGEX GREP 
	#if [[ $@ == *"-r"* ]]; 
	#then
	#  global=`$global | grep $r_p`
	#fi



	#SAVE
	
	if [[ $@ == *"-o"* ]]; 
	then
	  echo "$global" > $o_p ;
	  # cat $o_p ;
	fi



	#global=`du $h_p $d_p $taille | $s_p`

	echo "value global"
	echo "$global"
	echo "end global"

	
	echo "Value of d  is : $d_p, Value of d_result is :"
	echo "value of local is"
	#echo "$local"


}

# parameter -s -d $path -h -o here.txt -r "Projet" ;
parameter -s -d $path -h -o here.txt -r "Projet" -f ;


# sudo apt-get install pv COMMANDE A FAIRE POUR INSTALLER PV

#TEST 



# du -ckh  pour afficher la taille de tous les sous dossiers/fichiers directs 
# du -cksh pour afficher la taille des sous dossier non cachées

# Modificaiton des conditions du get opts c est peut etre ca qui pourra nous poser probleme dans  le futur

