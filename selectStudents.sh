#!/bin/bash
read -p "Enter a group: " group


function removeEmptyLines {
  gp=$1
  grep . ./"$gp"/students.list > ./"$gp"/students-cleared.list
  rm ./"$gp"/students.list
  mv ./"$gp"/students-cleared.list ./"$gp"/students.list
}

function loadStudents {
  gp=$1
  rm -rf "$gp"
  mkdir "$gp"
  wget https://raw.githubusercontent.com/KPI-FICT-ASU/2019-1/"$gp"/students.list -P ./"$gp"
}

function selectStudents {
  gp=$1
  count=$2
  mark=$3
  input=./"$gp"/students.list
  cat ./"$gp"/students.list | grep -v "\!" > ./"$gp"/temp.list
  sort -R ./"$gp"/temp.list | head -n"$count" > ./"$gp"/temp-selected.list

  while IFS= read -r line
  do
    count=$(grep "$line" ./"$gp"/temp-selected.list | wc -l)
    if [ $count == 0 ]
    then
      echo "$line" >> ./"$gp"/students-new.list
    else
      echo "!$line ($mark)" >> ./"$gp"/students-new.list
    fi
  done < "$input"

  rm ./"$gp"/temp.list
  rm ./"$gp"/temp-selected.list
  rm ./"$gp"/students.list
  mv ./"$gp"/students-new.list ./"$gp"/students.list

}

loadStudents "$group"
removeEmptyLines "$group"

studentsCount=$(wc -l ./"$gp"/students.list | awk '{ print $1 }')
# echo $studentsCount

selectStudents "$group" 1 "B1"
selectStudents "$group" 1 "B2"
selectStudents "$group" 1 "B3"

lCount=$(echo "$studentsCount*9/100" | bc -l )
lCount=$(echo $lCount | awk '{print int($1+0.5)}')
selectStudents "$group" $lCount "L"

r5Count=$(echo "$studentsCount*9/100" | bc -l )
r5Count=$(echo $r5Count | awk '{print int($1+0.5)}')
selectStudents "$group" $r5Count "R5"

r2Count=$(echo "$studentsCount*14/100" | bc -l )
r2Count=$(echo $r2Count | awk '{print int($1+0.5)}')
selectStudents "$group" $r2Count "R2"

cat ./"$group"/students.list
