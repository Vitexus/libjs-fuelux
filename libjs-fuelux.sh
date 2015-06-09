#!/bin/bash
if [ -d "fuelux" ]; then
  cd fuelux
  git pull
else
  git clone https://github.com/ExactTarget/fuelux/
  cd fuelux
fi

npm install
npm run build
npm run dist


if [ -e "../build" ]; then
  BUILD=`cat  ../build | perl -ne 'chomp; print join(".", splice(@{[split/\./,$_]}, 0, -1), map {++$_} pop @{[split/\./,$_]}), "\n";'`
else
  BUILD="1";
fi
echo $BUILD > ../build

VERSION=`cat package.json | grep '"version":' | awk -F'"' '{ print $4 }'`

#CHANGES=`cat CHANGELOG.md | awk -vRS="##" 'NR<=2' ORS="##" | grep -v "##"`
#dch -v $VERSION-$BUILD --package libjs-twitter-fuelux $CHANGES
cd ..

dch -v $VERSION-$BUILD --package libjs-fuelux 

debuild -i -us -uc -b

cd ..
#~/bin/publish-deb-packages.sh
