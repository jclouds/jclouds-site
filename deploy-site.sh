#!/bin/sh

jekyll build --safe
if [ ! -d "site-content" ]; then
  svn co https://svn.apache.org/repos/asf/jclouds/site-content
else
  svn up site-content
fi
cp -r _site/* site-content/
#jekyll copy site-content to _site so remove it
rm -rf site-content/site-content
rm site-content/deploy-site.sh
#add new files
cd site-content
svn status | awk '/^?/{print $2}' | \
    while read filename; do svn --no-auto-props add $filename; done
svn ci --no-auth-cache --username $1 --password $2 -m'deploy jclouds site content'
