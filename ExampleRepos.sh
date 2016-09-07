#!/bin/bash

# Author:  clif-s
# Course:  ICT Skills - HDip in Computer Science 2016
# Subject: Computer Systems - Shell Programming Assignment

# Program Description:

# This is an example of a function repository for the shell programming assignment and
# it is to illustrate a method of calling/importing scripts from other files. While the
# code has similar structure, it can not be compressed easily as each option has slightly
# different content.

# animation:        This is used in the main menu closing animation and may be utilised
#                   in other sections if appropriate.

# search_customer:  This is utilised in FindCust.

# remove_customer:  This is utilised in RemCust.

# email_customer:   This is utilised in FindCust.

function animation ()
{
    local i an m
    an='/-\|'                           # The variable of "an"
    m=${#an}
    printf ' '
    while sleep 0.12; do                # The loop that alternates the "an" variable every
        printf "%s\b" "${an:i++%m:1}"   # 0.12 seconds while using backspace to clear the
    done                                # previous.
}

function search_customer () 
{   
    unset word
    unset sel
    # Loops until input is not blank or Esc
    while [[ "$word" != *? && "$word" != $'\e' ]]; do
        if [[ "$returning" != Y ]]; then                # Facilitates simply printing the search bar
            clear                                       # when returning to narrow an existing search.
            echo "$(tput setaf 2)$(tput bold)Search Customer$(tput sgr 0) - Please enter a full or partial search word"
            echo "[Esc] key to return"
        fi
        unset returning
        echo ""
        echo -n "      Search: "
        read word
        case $word in
            $'\e')      echo    ""
                        echo -n "      Returning to previous menu... "
                        sleep 1.92
                        ;;
            # Restricts searching to single words.
            *?" "*?)    echo    ""
                        echo    "You can not search for two words!"
                        echo    ""
                        echo -n "Press [enter] key to search again "
                        unset word
                        read enterKey
                        ;;
            *?)         echo "$word"
                        unset linecount
                        linecount=$(grep -i -c $word CustomerDetails)   # Stores the number of line matches.
                        if [[ $linecount -eq 1 ]]; then                 # Returns result if a single match. 
                            clear
                            echo    "Search results for: $word"
                            echo    ""
                            echo    "$linecount result found!"
                            echo    ""
                            echo    "<E-mail>                  <Name>               <Alias>    <Address>            <Phone>"
                            grep -i $word CustomerDetails;
                            echo    ""
                            echo -n "Press [enter] key to return to previous menu..."
                            read enterKey
                        elif [[ $linecount -gt 1 ]]; then               # Returns result of multiple matches
                            clear                                       # and futher options.
                            echo    "Search results for: $word"
                            echo    ""
                            echo    "$linecount results found!"
                            echo    ""
                            echo    "<E-mail>                  <Name>               <Alias>    <Address>            <Phone>"
                            grep -i $word CustomerDetails;              # Prints matches.
                            echo    ""
                            echo    "Would you like to narrow the search?"
                            echo -n "Enter [Y / N] "
                            unset yn
                            while [[ ! $yn =~ [y|Y|n|N] ]]; do          # Loops until input is Y/N
                                read yn
                                case $yn in
                                    y | Y)  unset word                  # Allows loop back to search
                                            returning="Y"               # field without the header.
                                            ;;                          
                                    n | N)  sleep 0.96
                                            echo    ""
                                            echo -n "      Returning to previous menu... "
                                            sleep 1.92
                                            ;;
                                    *)      echo    ""
                                            echo -n "$yn is invalid. Please select [Y / N] "
                                            ;;
                                esac
                            done
                        else
                            clear
                            echo    "Search results for: $word"
                            echo    ""
                            echo    "$linecount results found"  # Linecount will return 0.
                            echo    ""
                            echo -n "Press [enter] key to search again"
                            unset word
                            read enterKey
                        fi
                        ;;
                        # Prevents blank input and returns message
            *)          clear
                        word="nothing?!"
                        echo    "Search results for: $word"
                        echo    ""
                        echo    "You can not search for nothing!"
                        echo    ""
                        echo -n "Press [enter] key to search again "
                        unset word
                        read enterKey
                        ;;
        esac
    done
}

function remove_customer () 
{   
    unset word
    unset sel
    # Loops until input is not blank or Esc
    while [[ "$word" != *? && "$word" != $'\e' ]]; do
        if [[ "$returning" != Y ]]; then                # Facilitates simply printing the search bar
            clear                                       # when returning to narrow an existing search.
            echo "$(tput setaf 2)$(tput bold)Remove Customer$(tput sgr 0) - Please enter a full or partial search word"
            echo "[Esc] key to return"
        fi
        unset returning
        echo ""
        echo -n "      Search: "
        read word
        case $word in
            $'\e')      echo    ""
                        echo -n "      Returning to previous menu...  "
                        sleep 1.92
                        ;;
            # Restricts searching to single words.
            *?" "*?)    echo    ""
                        echo    "You can not search for two words!"
                        echo    ""
                        echo -n "Press [enter] key to search again "
                        unset word
                        read enterKey
                        ;;
            *?)         echo "$word"
                        unset linecount
                        linecount=$(grep -i -c $word CustomerDetails)   # Stores the number of line matches.
                        if [[ $linecount -eq 1 ]]; then                 # Returns result if a single match
                            clear                                       # and futher options.
                            echo    "Search results for: $word"
                            echo    ""
                            echo    "$linecount result found!"
                            echo    ""
                            echo    "<E-mail>                  <Name>               <Alias>    <Address>            <Phone>"
                            grep -i $word CustomerDetails;              # Prints matches.
                            echo    ""
                            echo    "Would you like to remove this customer?"
                            echo -n "Enter [Y / N] "
                            unset yn
                            while [[ ! $yn =~ [y|Y|n|N] ]]; do          # Loops until input is Y/N 
                                read yn
                                case $yn in
                                    y | Y)  echo    ""
                                            echo    "Please confirm"
                                            echo -n "Enter [Y / N]"
                                            unset yn
                                            while [[ ! $yn =~ [y|Y|n|N] ]]; do          # Loops until input is Y/N
                                                read yn
                                                case $yn in
                                                    y | Y)  grep -i -v $word CustomerDetails > CustomerTemp
                                                            mv CustomerTemp CustomerDetails
                                                            sleep 0.96
                                                            echo    ""
                                                            echo    "      Customer removed! "
                                                            sleep 1.92
                                                            echo    ""
                                                            echo -n "      Returning to previous menu...  "
                                                            sleep 1.92
                                                            ;;
                                                    n | N)  sleep 0.96
                                                            echo    ""
                                                            echo    "      Cancelling! "
                                                            sleep 1.92
                                                            echo    ""
                                                            echo -n "      Returning to previous menu...  "
                                                            sleep 1.92
                                                            ;;
                                                    *)      echo    ""
                                                            echo -n "$yn is invalid. Please select [Y / N] "
                                                            ;;
                                                esac
                                            done
                                            ;;
                                    n | N)  sleep 0.96
                                            echo    ""
                                            echo    "      Cancelling "
                                            sleep 1.92
                                            echo    ""
                                            echo -n "      Returning to previous menu...  "
                                            sleep 1.92
                                            ;;
                                    *)      echo    ""
                                            echo -n "$yn is invalid. Please select [Y / N] "
                                            ;;
                                esac
                            done
                            unset yn
                        elif [[ $linecount -gt 1 ]]; then               # Returns result of multiple matches
                            clear                                       # and futher options.
                            echo    "Search results for: $word"
                            echo    ""
                            echo    "$linecount results found!"
                            echo    ""
                            echo    "<E-mail>                  <Name>               <Alias>    <Address>            <Phone>"
                            grep -i $word CustomerDetails;              # Prints matches.
                            echo    ""
                            echo    "Would you like to narrow the search?"
                            echo -n "Enter [Y / N] "
                            unset yn
                            while [[ ! $yn =~ [y|Y|n|N] ]]; do          # Loops until input is Y/N
                                read yn
                                case $yn in
                                    y | Y)  unset word                  # Allows loop back to search
                                            returning="Y"               # field without the header.
                                            ;;
                                    n | N)  sleep 0.96
                                            echo    ""
                                            echo -n "      Returning to previous menu...  "
                                            sleep 1.92
                                            ;;
                                    *)      echo    ""
                                            echo -n "$yn is invalid. Please select [Y / N] "
                                            ;;
                                esac
                            done
                        else
                            clear
                            echo    "Search results for: $word"
                            echo    ""
                            echo    "$linecount results found"  # Linecount will return 0.
                            echo    ""
                            echo -n "Press [enter] key to search again"
                            unset word
                            read enterKey
                        fi
                        ;;
                        # Prevents blank input and returns message
            *)          clear
                        word="nothing?!"
                        echo    "Search results for: $word"
                        echo    ""
                        echo    "You can not search for nothing!"
                        echo    ""
                        echo -n "Press [enter] key to search again "
                        unset word
                        read enterKey
                        ;;
        esac
    done
}

function email_customer () 
{   
    unset word
    unset sel
    # Loops until input is not blank or Esc
    while [[ $word != *? && "$word" != $'\e' ]]; do
        if [[ "$returning" != Y ]]; then                # Facilitates simply printing the search bar
            clear                                       # when returning to narrow an existing search.
            echo "$(tput setaf 2)$(tput bold)E-mail Customer$(tput sgr 0) - Please enter a full or partial search word"
            echo "[Esc] key to return"
        fi
        unset returning
        echo ""
        echo -n "      Search: "
        read word
        case $word in
            $'\e')      echo    ""
                        echo -n "      Returning to previous menu... "
                        sleep 1.92
                        ;;
            # Restricts searching to single words.
            *?" "*?)    echo    ""
                        echo    "You can not search for two words!"
                        echo    ""
                        echo -n "Press [enter] key to search again "
                        unset word
                        read enterKey
                        ;;
            *?)         echo "$word"
                        linecount=$(grep -i -c $word CustomerDetails)   # Stores the number of line matches.
                        if [[ $linecount -eq 1 ]]; then                 # Returns result if a single match
                            clear                                       # and futher options.
                            echo    "Search results for: $word"
                            echo    ""
                            echo    "$linecount result found!"
                            echo    ""
                            echo    "<E-mail>                  <Name>               <Alias>    <Address>            <Phone>"
                            grep -i $word CustomerDetails;              # Prints matches.
                            echo    ""
                            echo    "Would you like to E-mail this customer?"
                            echo -n "Enter [Y / N] "
                            unset yn
                            while [[ ! $yn =~ [y|Y|n|N] ]]; do          # Loops until input is Y/N
                                read yn
                                case $yn in
                                    y | Y)  unset subject message
                                            emailaddr=`grep -i $word CustomerDetails | awk '{print $1}'` # Stores the E-mail Address of customer.
                                            echo    ""
                                            echo -n "      Subject:          "
                                            while [[ "$subject" != *? && "$subject" != $'\e' ]]; do      # Loops until input is not blank
                                                read subject
                                                case $subject in
                                                    $'\e')  echo    ""
                                                            echo -n "      Returning to previous menu... "
                                                            sleep 1.92
                                                            ./EmailCust
                                                            exit 1
                                                            ;;
                                                    *?)     ;;
                                                    *)      echo    ""
                                                            echo    "Subject can not be blank - Please enter a Subject"
                                                            echo    "or enter [Esc key] to return to previous menu"
                                                            echo    ""
                                                            echo -n "      Subject:          "
                                                            ;;
                                                esac
                                            done

                                            echo    ""
                                            echo -n "      Message:          "
                                            while [[ "$message" != *? ]]; do                             # Loops until input is not blank
                                                read message
                                                case $message in
                                                    $'\e')  echo    ""
                                                            echo -n "      Returning to previous menu... "
                                                            sleep 1.92
                                                            ./EmailCust
                                                            exit 1
                                                            ;;
                                                    *?)     ;;
                                                    *)      echo    ""
                                                            echo    "Message can not be blank - Please enter a Message"
                                                            echo    "or enter [Esc key] to return to previous menu"
                                                            echo    ""
                                                            echo -n "      Message:          "
                                                            ;;
                                                esac
                                            done

                                            echo    "$message" | mail -s "$subject" "$emailaddr"         # Uses mail to send E-mail to emailaddr
                                            sleep 0.96                                                   # with the message and subject fields.
                                            echo    ""
                                            echo    "The E-mail has been sent to $emailaddr"
                                            sleep 0.96
                                            echo    ""
                                            echo -n "Press [enter] key to return to previous menu..."
                                            read enterKey
                                            sleep 1.92
                                            echo    ""
                                            echo -n "      Returning to previous menu...  "
                                            sleep 1.92
                                            ;;
                                    n | N)  sleep 0.96
                                            echo    ""
                                            echo    "      Cancelling! "
                                            sleep 1.92
                                            echo    ""
                                            echo -n "      Returning to previous menu...  "
                                            sleep 1.92
                                            ;;
                                    *)      echo    ""
                                            echo -n "$yn is invalid. Please select [Y / N] "
                                            ;;
                                esac
                            done
                        elif [[ $linecount -gt 1 ]]; then               # Returns result of multiple matches
                            clear                                       # and futher options.
                            echo    "Search results for: $word"
                            echo    ""
                            echo    "$linecount results found!"
                            echo    ""
                            echo    "<E-mail>                  <Name>               <Alias>    <Address>            <Phone>"
                            grep -i $word CustomerDetails;              # Prints matches.
                            echo    ""
                            echo    "Would you like to narrow the search?"
                            echo -n "Enter [Y / N] "
                            unset yn
                            while [[ ! $yn =~ [y|Y|n|N] ]]; do          # Loops until input is Y/N
                                read yn
                                case $yn in
                                    y | Y)  unset word                  # Allows loop back to search
                                            returning="Y"               # field without the header.
                                            ;;
                                    n | N)  sleep 0.96
                                            echo    ""
                                            echo -n "      Returning to previous menu... "
                                            sleep 1.92
                                            ;;
                                    *)      echo    ""
                                            echo -n "$yn is invalid. Please select [Y / N] "
                                            ;;
                                esac
                            done
                        else
                            clear
                            echo    "Search results for: $word"
                            echo    ""
                            echo    "$linecount results found"  # Linecount will return 0. 
                            echo    ""
                            echo -n "Press [enter] key to search again"
                            unset word
                            read enterKey
                        fi
                        ;;
                        # Prevents blank input and returns message
            *)          clear
                        word="nothing?!"
                        echo    "Search results for: $word"
                        echo    ""
                        echo    "You can not search for nothing!"
                        echo    ""
                        echo -n "Press [enter] key to search again "
                        unset word
                        read enterKey
                        ;;
        esac
    done
}