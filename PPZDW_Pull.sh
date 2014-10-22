#!/bin/bash
# 
#  Poor Person's Zuora Data Warehouse - PPZDW
#
#  Using this script pull out from Zuora all the data sources needed
#  for the data warehouse - we'll use the aqua interface, in non-synchronous mode,
#  meaning multiple serial queries that may partially capture new incoming txns.
#
#  The aqua queries may take minutes, half hour or longer to complete if you have a
#  a lot of data. Be patient.
#
#  Have to feed in the tenant identifier (www or apisandbox), login and password.
#
#  richard.sawey@zuora.com
#
#  Written in bash, but only tested on a Mac running Mavericks, 10.9.5, your
#  mileage may vary.
#
#  Why bash? Because Ruby and Python are for wimps
#
#
if [ ! $# == 3 ]; then
  echo "Usage: Tenant Type (www or apisandbox) Zuora Login Zuora Password"
  echo "Usage example: ./PPZDW.sh apisandbox user@whatever.com mysecret"
  exit
fi

# Redirect stdout ( > ) into a named pipe ( >() ) running "tee"
exec > >(tee PPZDW.log)
exec 2>&1

USER_NAME=$2
PASSWORD=$3
TENANT=$1
BASE_URL="https://$TENANT.zuora.com/apps"
echo $BASE_URL
JOB_STATUS="pending"
SLEEP_PERIOD="5s"

#
#  Before we do anything useful let's define a function we'll use to check if the
#  aqua job is complete
#
job_ready() {
  JOBID=$1
  echo "============= Checking Job Id: $JOBID ===========" 
  curl -i -k -u $USER_NAME:$PASSWORD -H "Content-Type:application/json" -H "Accept:application/json" -X GET $BASE_URL/api/batch-query/jobs/$JOBID > file_ready_check.txt
  if grep 'HTTP/1.1 200 OK' file_ready_check.txt && ! grep 'errorCode' file_ready_check.txt 
  then
    #
    #  And what is going on below? we grep the results file looking for the id line that has the job id,
    #  then we have cut out the bit between the ':' and the ',' which has the job id surrounded
    #  by some white space (the first sed gets rid of all white space), and then by double quotes,
    #  so the second sed -e gets rid of the leading " and the last one the last ".
    #
    JOB_STATUS=`grep '"status" :' file_ready_check.txt | head -1 | cut -d : -f2 | cut -d , -f1 | sed -e 's/[[:space:]]//g' -e 's/^"//'  -e 's/"$//' `
    echo "Job Id: $JOBID has status $JOB_STATUS"
    if [ "$JOB_STATUS" == "aborted" ]
    then
      echo "File status of aborted reported! Review contents of file_ready_check.txt for clues"
    fi
  else
    echo "File ready check failed! review contents of file_ready_check.txt for clues"
    JOB_STATUS="fail"
  fi
}

#
#  And here is a function to go pull down one of the result files, this will be
#  called over and over file id by file id
#
#  GET https://www.zuora.com/apps/api/file/{fileId}
#
get_aqua_result_file() {
  FID=$1
  RFOLDER=$2
  echo "============= Getting Aqua Results File Id: $FID ===========" 
  curl -i -k -u $USER_NAME:$PASSWORD -H "Content-Type:application/json" -H "Accept:application/json" -X GET $BASE_URL/api/file/$FID > $RFOLDER/file_$FID.txt
  if grep 'HTTP/1.1 200 OK' $RFOLDER/file_$FID.txt && ! grep 'errorCode' $RFOLDER/file_$FID.txt 
  then
    echo "Got good stuff: $RFOLDER/file_$FID.txt"
    #
    #  And now it's time to post process the results file, they have a bunch of HTTP 
    #  header info in them that has to be stripped out, the tail -n+12 tails the entire
    #  file but starting at line 12 and the sed strips out any blank lines
    #
    tail -n+12 $RFOLDER/file_$FID.txt  | sed -e '/^[[:space:]]*$/d' > $RFOLDER/$FID.csv
  else
    mv $RFOLDER/file_$FID.txt $RFOLDER/file_$FID.fail
    echo "Aqua Results File $FID pull failed! Review contents of $RFOLDER/file_$FID.fail for clues"
  fi
}

#
#  ====================================================================================
#
#  Time to rumble, enough with the functions, let's do some work. First we will
#  fire up the aqua queries, check they worked and if they did pull the job id
#  that we need to test to see if the results are ready
#
#  ====================================================================================
#
echo "============= File up queries against $BASE_URL ===========" 

source curl_aqua.sh $BASE_URL $USER_NAME $PASSWORD > curl_aqua_results.txt
if grep 'HTTP/1.1 200 OK' curl_aqua_results.txt && ! grep 'errorCode' curl_aqua_results.txt 
then
  echo "Queries seemed to have been posted successfully"
  #
  #  And what is going on below? we grep the results file looking for the id line that has the job id,
  #  then we have cut out the bit between the ':' and the ',' which has the job id surrounded
  #  by some white space (the first sed -e gets rid of all white space), and then by double quotes,
  #  so the second sed -e gets rid of the leading " and the last one the last ".
  #
  JOBID=`grep '"id" :' curl_aqua_results.txt | tail -1 | cut -d : -f2 | cut -d , -f1 | sed -e 's/[[:space:]]//g' -e 's/^"//'  -e 's/"$//' `
  echo "Aqua Job Id: $JOBID"  
else
  echo "Problem found in curl_aqua_results.txt - check HTTP return code and errorCode"
  exit 1
fi

while [ "$JOB_STATUS" == "pending" ] || [ "$JOB_STATUS" == "executing"  ]; do
  sleep $SLEEP_PERIOD
  job_ready $JOBID
done

if [ "$JOB_STATUS" != "completed" ]
then
  exit 1
fi
#
#  Make a directory for the results files
#
mkdir "$JOBID"
mv curl_aqua_results.txt $JOBID/curl_aqua_results.txt
mv file_ready_check.txt $JOBID/file_ready_check.txt

#
#  Time to grab the file ids and then the files, the grep parses out and grabs the 
#  file ids and sticks them in file_ids.txt
#  
grep fileId $JOBID/file_ready_check.txt | cut -d : -f2 | cut -d , -f1 | sed -e 's/[[:space:]]//g' -e 's/^"//'  -e 's/"$//' > $JOBID/file_ids.txt
#
#
#  This while loop grabs a file each time round from file_ids.txt and sticks the results in a folder
#  named after the Aqua JOB ID - ergo there will always be a unique folder name
#
while read RFILEID; do get_aqua_result_file $RFILEID $JOBID; done < $JOBID/file_ids.txt

#
#  Time to actually build the data warehouse, the first column is used to determine the table
#  name (the data source name with no spaces)
#  Everything is going to be built in the sub-directory where we placed the 
#  downloaded result files. This includes the actual database file itself, PPZDW.sqlite
#
#  So each time you run this file you'll get a new Job Id, a new sub directory and a
#  a new database - so this will soak up all your disk space if you ignore this and
#  never clean up.
#

/bin/rm -f $JOBID/load_files.txt
ls $JOBID/*.csv > $JOBID/load_files.txt
#
#  Remove any previous database
#
/bin/rm -f $JOBID/PPZDW.sqlite
/bin/rm -f $JOBID/PPZDW.sql

#
#  PPZDW is going to contain the sqlite commands to import the csv files. We'll
#  take advantage of the sqlite .import feature, we just have to make sure the column headers in the
#  first line of the csv file are what we want, this means changing the 'Contact:
#  First Name' crap to just 'FirstName'
#
#  And if you are wondering why I build the table first and I don't take advantage of
#  the documented feature where you can both create and load the table from a csv file?
#  That feature simply doesn't work. 
#
# 
#  Let's open and start building our new database build file
DBBUILDFILE=$JOBID/PPZDW.sql
echo ".mode csv" > $DBBUILDFILE

#
#  For each csv file, edit first line so the column names are correct and write the 
#  rest of the file to an appropriately named csv file,
#  'appropriately named' means a file that contains the table name
#
#  Change separator to a comma so we can parse out the columns headers
IFS=','
#
#  Now loop through each csv file
#
while read RFNAME; do 
  echo "found $RFNAME"
  # delete all leading blank lines at top of file
  cat $RFNAME | sed '/./,$!d' > $RFNAME.tmp
  /bin/rm -f $RFNAME
  /bin/mv $RFNAME.tmp $RFNAME
  
  TABLENAME=`head -1 $RFNAME | cut -d : -f1 | sed -e 's/[[:space:]]//g' -e 's/^"//' -e 's/"$//'`
  echo "Table $TABLENAME with columns "

  TARGET=`head -1 $RFNAME | cut -d : -f1`  
  COLNAMES=`head -1 $RFNAME | sed -e "s/$TARGET://g" -e 's/[[:space:]]//g' -e 's/\///' -e 's/^"//' -e 's/"$//'`
  echo "create table $TABLENAME($COLNAMES);"
  echo "create table $TABLENAME($COLNAMES);" >> $DBBUILDFILE
  echo ".import $TABLENAME.sql $TABLENAME"  >> $DBBUILDFILE

  /bin/rm -f $JOBID/$TABLENAME.sql
  tail -n+2 $RFNAME > $JOBID/$TABLENAME.sql

done < $JOBID/load_files.txt
unset IFS

echo "Change to $JOBID  and run sqlite3 PPZDW.sqlite < PPZDW.sql "
