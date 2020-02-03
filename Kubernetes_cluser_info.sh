#!/bin/sh
show_menu(){
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    number=`echo "\033[33m"` #yellow
    bgred=`echo "\033[41m"`
    fgred=`echo "\033[31m"`
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${number} 1)${menu} Show running pods and namespace ${normal}\n"
    printf "${menu}**${number} 2)${menu} Show creation time details of pods  ${normal}\n"
    printf "${menu}**${number} 3)${menu} Tell count of number of pods running ${normal}\n"
    printf "${menu}**${number} 4)${menu} Check if your pod is running ${normal}\n"
    printf "${menu}*********************************************${normal}\n"
    printf "Please enter a menu option and enter OR ${fgred}x to exit from menu. ${normal}"
    read opt
}

option_picked(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal white
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}

clear
show_menu
while [ $opt != '' ]
    do
    if [ $opt = '' ]; then
      exit;
    else
      case $opt in
        1) clear;
            option_picked "Option 1 Picked";
	    kubectl get namespaces,pods --all-namespaces 
            show_menu;
        ;;
        2) clear;
            option_picked "Option 2 Picked";
            kubectl get pods --all-namespaces;
            kubectl get pods --all-namespaces --sort-by='.metadata.creationTimestamp' -o jsonpath='{range .items[*]}{.metadata.name}, {.metadata.creationTimestamp}{"\n"}{end}'
            show_menu;
        ;;
        3) clear;
            option_picked "Option 3 Picked";
            kubectl get pods --all-namespaces -o json | jq '.items[] | .spec.nodeName' -r | sort | uniq -c > out
            count=`cut -f 6 -d " " out`
            echo "Hey , count of pods running in cluster is $count "
            rm -rf out; 
            show_menu;
        ;;
	4) clear;
	   option_picked "Option 4 Picked";
	   printf "Please enter name of your pod --> ${normal}"
           read opt 
	   #printf "Your pod name is $opt \n"
	   kubectl get pods --all-namespaces > out
	   grep -i $opt out > out1
	   grep -i running out1
	   isInFile=$(cat out1 | grep -ic running)
	   if [ $isInFile -eq 0 ]; then
          	 printf "\n${fgred}Oops !! POD $opt is not running,Please check !! \n"
	   else
          	 printf "\n${number}Woww !! Your POD $opt is running \n"
	  	 #kubectl describe pod $opt > out2
	  	 #cat out2|grep -i namespace|rev| cut -d':' -f 1 | rev > out3
                 namespace=$(cat out1 | cut -f1 -d" ")
	  	 echo "Namespace for POD $opt is -> $namespace"
          	 rm -rf out1;
		 rm -rf out;
           fi           
           show_menu;
	;;
        x)exit;
        ;;
        \n)exit;
        ;;
        *)clear;
            option_picked "Pick an option from the menu";
            show_menu;
        ;;
      esac
    fi
done
