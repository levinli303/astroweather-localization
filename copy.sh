#!/bin/bash

cd `dirname $0`
ANDROID_APP_DIR=$(pwd)/../astroweather-android/app/src/main/res
IOS_APP_DIR=../astroweather-ios

ANDROID_BASE_DIR=$(pwd)/Android
IOS_BASE_DIR=$(pwd)/iOS

copy()
{
  if [ "$3" = true ] ; then
    cp $2 $1
  else
    cp $1 $2
  fi
}

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

  if [ "$1" == "en" ] ; then
    DIR=$ANDROID_APP_DIR/values
  else
    DIR=$ANDROID_APP_DIR/values-$1
  fi
  make_dir_if_not_exists $DIR
  copy $2/strings.xml $DIR/strings.xml $3

  echo "Copying done"
}

copy_ios()
{
  echo "Copying iOS localization resources for $1"

  if [ "$1" == "en" ]; then
    DIR=$IOS_APP_DIR/Shared/Resources
    make_dir_if_not_exists $DIR
    copy $2/Shared/Localizable.xcstrings $DIR/Localizable.xcstrings $3
    echo "Copying shared done"
  fi

  if [ "$1" == "en" ]; then
    DIR=$IOS_APP_DIR/Astroweather
    make_dir_if_not_exists $DIR
    copy $2/App/InfoPlist.xcstrings $DIR/InfoPlist.xcstrings $3
    echo "Copying main done"
  fi

  DIR=$IOS_APP_DIR/AstroweatherWidget/$1.lproj
  make_dir_if_not_exists $DIR
  if [ "$1" != "en" ]
  then
    copy $2/AstroweatherWidget/AstroweatherWidget.strings $DIR/AstroweatherWidget.strings $3
  fi

  echo "Copying astroweather widget done"

  echo "Copying done"
}

SYNC=false
if [ "$1" = "sync" ] ; then
  echo "Syncing localization files"
  SYNC=true
fi

for FILE in $ANDROID_BASE_DIR/*
do
  if test -d $FILE
  then
    LANG=${FILE##*/}
    copy_android $LANG $FILE $SYNC
  fi
done

for FILE in $IOS_BASE_DIR/*
do
  if test -d $FILE
  then
    LANG=${FILE##*/}
    copy_ios $LANG $FILE $SYNC
  fi
done
