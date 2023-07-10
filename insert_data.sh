#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams; ")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do 
  if [[ $WINNER != 'winner' ]]
  then
#Get winner ID 
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ")
#IF not found 
    if [[ -z $WINNER_ID ]]
    then
#ADD winner id
    INSERT_WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ $INSERT_WINNER_ID == "INSERT 0 1" ]]
      then
      echo Inserted into teams $WINNER
      fi
#Get new winner id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ")
    fi

  fi
  
  if [[ $OPPONENT != 'opponent' ]]
  then
#Get opponent ID 
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT' ")
#IF not found 
    if [[ -z $OPPONENT_ID ]]
    then
#ADD opponent id
    INSERT_OPPONENT_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      if [[ $INSERT_OPPONENT_ID == "INSERT 0 1" ]]
      then
      echo Inserted into teams $OPPONENT
      fi
#Get new opponent id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT' ")
    fi

  fi
  #ADD ROW TO GAMES TABLES 
  INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,winner_goals,opponent_goals,opponent_id) VALUES($YEAR,'$ROUND',$WINNER_ID,$WINNER_GOALS,$OPPONENT_GOALS,$OPPONENT_ID);")
     
done
