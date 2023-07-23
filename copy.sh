#!/bin/bash

cd `dirname $0`
ANDROID_APP_DIR=$(pwd)/../astroweather-android/app/src/main/res
IOS_APP_DIR=../astroweather-ios

ANDROID_BASE_DIR=$(pwd)/Android
IOS_BASE_DIR=$(pwd)/iOS

make_dir_if_not_exists()
{
  if [ ! -d $1 ]
  then
    mkdir -p $1
  fi
}

copy_android()
{
  echo "Copying Andorid localization resources for $1"

  DIR=$ANDROID_APP_DIR/values-$1
  make_dir_if_not_exists $DIR
  cp $2/strings.xml $DIR/strings.xml

  echo "Copying done"
}

copy_ios()
{
  echo "Copying iOS localization resources for $1"

  DIR=$IOS_APP_DIR/Shared/Resources/$1.lproj
  make_dir_if_not_exists $DIR
  cp $2/Shared/Localizable.strings $DIR/Localizable.strings

  echo "Copying shared done"

  if [ "$1" == "en" ]
  then
    DIR=$IOS_APP_DIR/Astroweather/Base.lproj
  else
    DIR=$IOS_APP_DIR/Astroweather/$1.lproj
  fi
  make_dir_if_not_exists $DIR
  cp $2/App/InfoPlist.strings $DIR/InfoPlist.strings

  echo "Copying main done"

  DIR=$IOS_APP_DIR/AstroweatherToday/$1.lproj
  make_dir_if_not_exists $DIR
  cp $2/AstroweatherToday/InfoPlist.strings $DIR/InfoPlist.strings
  if [ "$1" != "en" ]
  then
    cp $2/AstroweatherToday/MainInterface.strings $DIR/MainInterface.strings
  fi

  echo "Copying astroweather today done"

  DIR=$IOS_APP_DIR/AstroweatherWidget/$1.lproj
  make_dir_if_not_exists $DIR
  if [ "$1" != "en" ]
  then
    cp $2/AstroweatherWidget/AstroweatherWidget.strings $DIR/AstroweatherWidget.strings
  fi

  echo "Copying astroweather widget done"

  echo "Copying done"
}

for FILE in $ANDROID_BASE_DIR/*
do
  if test -d $FILE
  then
    LANG=${FILE##*/}
    copy_android $LANG $FILE
  fi
done

for FILE in $IOS_BASE_DIR/*
do
  if test -d $FILE
  then
    LANG=${FILE##*/}
    copy_ios $LANG $FILE
  fi
done
