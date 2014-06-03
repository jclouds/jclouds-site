#!/bin/bash

set -o errexit

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
JAVA_VERSION=`mvn --version | grep "Java version" | awk '{print $3}' | sed 's/,//' | cut -c 3`

if [ "$JAVA_VERSION" -lt "7" ]; then
  echo "Use Java 1.7+ to generate the Javadoc."
  exit 1
fi

if [ -z "$1" ]; then
  echo "Usage: $0 <JCLOUDS_VERSION>"
  exit 1
fi

JCLOUDS_VERSION=$1
JCLOUDS_VERSION_X=`echo $JCLOUDS_VERSION | cut -c 1-3 | awk '{print $1".x"}'`

cd $TMPDIR

for name in jclouds jclouds-labs-openstack; do
  rm -rf ${name}
  git clone https://github.com/jclouds/${name}.git
  cd ${name}
  git checkout ${JCLOUDS_VERSION_X}
  git reset --hard ${name}-${JCLOUDS_VERSION}
  cd ..
done

apis="openstack-glance openstack-neutron openstack-swift openstack-marconi rackspace-autoscale rackspace-cloudfiles"

for api in ${apis}; do
  mv jclouds-labs-openstack/${api} jclouds/apis/
  sed -i "" "s#<module>route53</module>#<module>route53</module><module>${api}</module>#g" jclouds/apis/pom.xml
done

providers="rackspace-autoscale-us rackspace-cloudqueues-us rackspace-cloudqueues-uk rackspace-cloudfiles-uk rackspace-cloudfiles-us"

for provider in ${providers}; do
  mv jclouds-labs-openstack/${provider} jclouds/providers/
  sed -i "" "s#<module>dynect</module>#<module>dynect</module><module>${provider}</module>#g" jclouds/providers/pom.xml
done

cd jclouds
mvn clean javadoc:aggregate -Dnotimestamp=true -DadditionalJOption=-J-Xmx512m

cd $DIR

mkdir -p reference/javadoc/$JCLOUDS_VERSION_X/
rsync -r --ignore-times $TMPDIR/jclouds/target/site/apidocs/ reference/javadoc/$JCLOUDS_VERSION_X/

cd site-content

svn status | awk '/^\?/{print $2}' | \
    while read filename; do svn --no-auto-props add $filename; done

if [ -z "$(svn status)" ]; then
    echo "No modified files in svn"
else
    echo "Modified files in svn:"

    svn status

    read -p "Are you sure you want to deploy the above changes? (y|n) " -n 1 -r
    echo

    svn commit --message 'deploy jclouds javadoc site content'
fi
