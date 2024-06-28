#!/bin/bash
# Script to query periodic table elements from PostgreSQL database

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if argument is provided and query database accordingly
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  # Query the database based on argument type
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  # Readable query logic
    QUERY_RESULT=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $1")
  else
    QUERY_RESULT=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$1' OR elements.name = '$1'")
  fi

  if [[ -z $QUERY_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< $QUERY_RESULT
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
