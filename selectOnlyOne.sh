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

loadStudents "$group"
removeEmptyLines "$group"
sort -R ./"$group"/students.list | head -n1
