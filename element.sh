#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

RESULT() {
  # query variable values from properites and types
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM elements INNER JOIN properties USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")
  MP=$($PSQL "SELECT melting_point_celsius FROM elements INNER JOIN properties USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")
  BP=$($PSQL "SELECT boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number= $ATOMIC_NUMBER")
  # format info variables to remove spaces
  ATOMIC_NUMBER_FORMATTED=$(echo $ATOMIC_NUMBER | sed -E 's/^ *| *$//')
  SYMBOL_FORMATTED=$(echo $SYMBOL | sed -E 's/^ *| *$//')
  NAME_FORMATTED=$(echo $NAME | sed -E 's/^ *| *$//')
  ATOMIC_MASS_FORMATTED=$(echo $ATOMIC_MASS | sed -E 's/^ *| *$//')
  MP_FORMATTED=$(echo $MP | sed -E 's/^ *| *$//')
  BP_FORMATTED=$(echo $BP | sed -E 's/^ *| *$//')
  TYPE_FORMATTED=$(echo $TYPE | sed -E 's/^ *| *$//')
  # output info sentence
  echo "The element with atomic number $ATOMIC_NUMBER_FORMATTED is $NAME_FORMATTED ($SYMBOL_FORMATTED). It's a $TYPE_FORMATTED, with a mass of $ATOMIC_MASS_FORMATTED amu. $NAME_FORMATTED has a melting point of $MP_FORMATTED celsius and a boiling point of $BP_FORMATTED celsius."
}

# if no argument given
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."

# if argument is a digit
elif [[ $1 =~ ^[0-9]+$ ]]
  then
    # check if the digit is a valid atomic number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  # if it doesn't exist
  if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      # query the values for element symbol and name
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number= $ATOMIC_NUMBER")
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number= $ATOMIC_NUMBER")
      RESULT
  fi

#if argument is 1-2 alphabet characters
elif [[ $1 =~ ^[A-Z][a-z]{0,1}$ ]]
  then
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol= '$1' ")
  # if it doesn't exist
  if [[ -z $SYMBOL ]]
    then
      echo "I could not find that element in the database."
    else
      # query the values for element atomic number and name
      SYMBOL_FORMATTED=$(echo $SYMBOL | sed -E 's/^ *| *$//')
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL_FORMATTED'")
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$SYMBOL_FORMATTED'")
      RESULT
  fi

#if argument greater than 2 alphabet characters
elif [[ $1 =~ ^[A-Z][a-z]+$ ]]
  then
    NAME=$($PSQL "SELECT name FROM elements WHERE name= '$1' ")
  # if it doesn't exist
  if [[ -z $NAME ]]
    then
      echo "I could not find that element in the database."
    else
      # query the values for element atomic number and symbol
      NAME_FORMATTED=$(echo $NAME | sed -E 's/^ *| *$//')
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME_FORMATTED'")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$NAME_FORMATTED'")
      RESULT
  fi
  # catch for other stringes entered as the argument
  else 
    echo "I could not find that element in the database."
fi
