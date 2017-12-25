#!/bin/bash
# VERSION CODE
version=1.0.0
# Color settings
COLOR_hint="\033[1;33m"
COLOR_labyrinth="\033[0;32m"
COLOR_menuHeader="\033[0;32m"
COLOR_selection="\033[1;32m"
COLOR_reset="\033[0m"
# COLOR CODE CHEAT SHEET
# red="\033[0;31m"
# green="\033[0;32m"
# brown="\033[0;33m"
# blue="\033[0;34m"
# purple="\033[0;35m"
# cyan="\033[0;36m"
# lightgray="\033[0;37m"
# darkgray="\033[1;30m"
# lightred="\033[1;31m"
# lightgreen="\033[1;32m"
# yellow="\033[1;33m"
# lightblue="\033[1;34m"
# lightpurple="\033[1;35m"
# lightcyan="\033[1;36m"
# white="\033[1;37m"

# Executed when catching interrupt signal or clicking Exit
function exit_program {
  clear
  tput cnorm -- normal
  exit 1
}

##################################################### CHECK REQUIREMENTS
# Stuff to do pre-start like checking requirements
function pre_start {

  ## TEST GAME REQUIREMENTS
  local bash_version=$BASH_VERSION
  echo -e "\033[0;31m"
  if ! [ ${bash_version:0:1} -ge "4" ]
  then
    echo "You need BASH version 4+ to play this game!"
    exit 1
  fi
  # CHECK IF SED EXISTS (USED FOR SETTINGS MANAGEMENT)
  sed --help >/dev/null 2>&1
  if ! [ $? = 0 ]
  then
    echo "Could not find command 'sed'. Unable to start!"
    exit 1
  fi
  # CHECK IF FIND UTILS EXISTS (USED FOR MAP SELECTION)
  find --help >/dev/null 2>&1
  if ! [ $? = 0 ]
  then
    echo "Could not find command 'find'. Unable to start!"
    exit 1
  fi
  # CHECK IF GREP EXISTS (USED IN MAP SELECTION)
  grep --help >/dev/null 2>&1
  if ! [ $? = 0 ]
  then
    echo "Could not find command 'grep'. Unable to start!"
    exit 1
  fi
  # CHECK IF SETTINGS FILE EXISTS
  find settings.config >/dev/null 2>&1
  if ! [ $? = 0 ]
  then
    echo "The config file seems to be missing! Please re-download the game."
    exit 1
  fi
  echo -e "\033[0m"
  ## END OF TEST

  # Hide curser
  tput civis -- invisible

}

##################################################### LOAD SETTINGS
function query_options {

  # Query some stuff from the settings file
  OPTIONS_controls=$(sed -n 1p settings.config)
  OPTIONS_pauseKey=$(sed -n 2p settings.config)
  OPTIONS_map=$(sed -n 3p settings.config)
  OPTIONS_playerChar=$(sed -n 4p settings.config)
  OPTIONS_winChar=$(sed -n 5p settings.config)
  # The standard keys to move with
  if [ $OPTIONS_controls = "WASD" ]
  then
    KEY_right="d"
    KEY_left="a"
    KEY_down="s"
    KEY_up="w"
  else
    KEY_right="C"
    KEY_left="D"
    KEY_down="B"
    KEY_up="A"
  fi
  # PAUSE KEY
  KEY_escape=$OPTIONS_pauseKey
  # The default map file
  mapfile="maps/$OPTIONS_map"
  # The ASCII letter that's used to show the players location
  # This must correspond with an unique character on the map
  PLAYER_char="$OPTIONS_playerChar"
  # Character that implies the goal
  WIN_char="$OPTIONS_winChar"

}
# INSTANTLY START QUERYING THE OPTIONS
query_options

##################################################### MAP SELECTION THING
function select_map_mapSelection {

  while true
  do
    read -p " Your selection is: " mapSelection
    if ! [ "$mapSelection" = "" ]
    then
      grep "" "maps/$mapSelection" >/dev/null 2>&1
      if [ $? = 0 ]
      then
        return
      else
       echo -e " \033[0;31mUnknown map. Please retry...\033[0m"
       read -s -r -n1
      fi
    fi
  done
}

function select_map_playerChar {

  while true
  do
    read -p " What is the player character on this map: " playerChar
    if ! [ "$playerChar" = "" ]
    then
      grep "$playerChar" "maps/$mapSelection" >/dev/null 2>&1
      if [ $? = 0 ]
      then
       return
      else
        echo -e " \033[0;31mDid not find the player character on the map. Please retry...\033[0m"
        read -s -r -n1
      fi
    fi
  done
}

function select_map_goalChar {

  while true
  do
    read -p " What is the goal character on this map: " goalChar
    if ! [ "$goalChar" = "" ]
    then
      grep "$goalChar" "maps/$mapSelection" >/dev/null 2>&1
      if [ $? = 0 ]
      then
       return
      else
        echo -e " \033[0;31mDid not find the goal character on the map. Please retry...\033[0m"
        read -s -r -n1
      fi
    fi
  done
}

# select map to play
function select_map {

  while true
  do
      clear
      echo -e "\n\n${COLOR_menuHeader} [Map Selection]${COLOR_reset}"
      echo -e "\n${COLOR_hint} Select one of the following maps:\n"
      find maps/*.map -printf "  %f\n"
      echo -e "${COLOR_reset}"
      tput cnorm -- normal
      trap "tput civis -- invisible; trapped=yep ;return" SIGINT
      select_map_mapSelection
      select_map_playerChar
      select_map_goalChar
      if ! [ "$trapped" = "yep" ]
      then
        sed -i "3s/.*/$mapSelection/" settings.config
        sed -i "4s/.*/$playerChar/" settings.config
        sed -i "5s/.*/$goalChar/" settings.config
        echo -e "\n \033[0;32mSuccess! New default map has been saved.\033[0m"
      fi
      read -r -n1 -p " Press any key to continue..."
      tput civis -- invisible
      query_options
      return
  done

}


##################################################### OPTIONS MENU
# render menu
function render_options {

  clear
  echo -e "\n\n${COLOR_menuHeader} [Options]${COLOR_reset}"

  local color$SELECT_options="$COLOR_selection"

  echo -e "\n${color1} [+] Controls: $OPTIONS_controls${COLOR_reset}"
  echo -e "${color2} [+] PAUSE Key: '$OPTIONS_pauseKey'${COLOR_reset}"
  echo -e "\n${color3} [~] Return to menu ${COLOR_reset}"


}
# options menu functionality
function options {

  # Pre-select entry
  SELECT_options="1"

  while true
  do
    render_options
    trap "return" SIGINT
    read -s -n1 optionsInput
    case $optionsInput in
        A)
          if ! [ $SELECT_options = 1 ]
          then
            SELECT_options=$((SELECT_options - 1))
          fi;;
        B)
          if ! [ $SELECT_options = 3 ]
          then
            SELECT_options=$((SELECT_options + 1))
          fi;;
        "") # IF ENTER OR SPACE PRESSED
            case $SELECT_options in
                1)
                  if [ "$OPTIONS_controls" = "ARROWS" ]
                  then
                    sed -i '1s/.*/WASD/' settings.config
                  else
                    sed -i '1s/.*/ARROWS/' settings.config
                  fi;;
                2)
                  echo -e "\n"
                  tput cnorm -- normal
                  read -p $'\e[1;33m  # Enter your PAUSE key: \e[0m' pauseKey2Be
                  #echo -e "\033[0m"
                  tput civis -- invisible
                  if ! [ "$pauseKey2Be" = "" ]
                  then
                    sed -i "2s/.*/$pauseKey2Be/" settings.config
                  fi;;
                3)
                  # Return to main menu
                  return
            esac
            query_options
    esac
  done

}

##################################################### IN-GAME MENU
# render ingame menu
function render_ingamemenu {

  clear
  echo -e "\n\n${COLOR_menuHeader} [PAUSE]${COLOR_reset}"

  local color$SELECT_ingame="$COLOR_selection"

  echo -e "\n${color1} [*] Resume${COLOR_reset}"
  echo -e "\n${color2} [~] Exit${COLOR_reset}"

}
# In-Game Menu functionality
function ingamemenu {

  # Pre-select first menu entry
  SELECT_ingame="1"

  while true
  do

    render_ingamemenu
    trap "exit_program" SIGINT
    read -s -n1 menuInput
    case $menuInput in
        A)
          if ! [ $SELECT_ingame = 1 ]
          then
            SELECT_ingame=$((SELECT_ingame - 1))
          fi;;
        B)
          if ! [ $SELECT_ingame = 2 ]
          then
            SELECT_ingame=$((SELECT_ingame + 1))
          fi;;
        $KEY_escape) # PAUSE BEING PRESSED
          clear
          return;;
        "") # IF ENTER OR SPACE PRESSED
          case $SELECT_ingame in
              1) # RESUME
                return;;
              2) # EXIT
                ingamemenu_outcome="exit"
                return
          esac
    esac
  done

}

##################################################### MAIN MENU
# Render Main Menu
function render_mainmenu {

 clear
 echo -e "\n${COLOR_menuHeader} ASCIIrinth $version${COLOR_reset}\n\n"

 local color$SELECT_main="$COLOR_selection"

 echo -e "${color1} [*] Play${COLOR_reset}"
 echo -e "${color2} [*] Select Map${COLOR_reset}"
 echo -e "${color3} [*] Create Map${COLOR_reset}"
 echo -e "${color4} [*] Options${COLOR_reset}"
 echo -e "\n${color5} [~] Exit${COLOR_reset}"

}
# THIS MANAGES THE WHOLE GUI
function gui {

  pre_start
  # Pre-select first menu entry
  SELECT_main=1

  while true
  do

    render_mainmenu
    trap "exit_program" SIGINT
    read -s -n1 menuInput
    case $menuInput in
        A)
          if ! [ $SELECT_main = 1 ]
          then
            SELECT_main=$((SELECT_main - 1))
          fi;;
        B)
          if ! [ $SELECT_main = 5 ]
          then
            SELECT_main=$((SELECT_main + 1))
          fi;;
        "") # IF ENTER OR SPACE PRESSED
          case $SELECT_main in
              1)
                # START
                clear
                return;;
              2)
                # SELECT MAP
                select_map;;
              3)
                # CREATE NEW MAP
                source $(dirname $0)/map-maker.sh;;
              4)
                # GOTO OPTIONS
                options;;
              5)
                # EXIT
                exit_program
          esac
    esac
  done

}