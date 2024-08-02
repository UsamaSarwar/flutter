#!/bin/sh

##? Create Flutter package to publish it at pub.dev
# flutter create --template=package --org=usama.dev unique_package_name

##? Dry run before publishing to pub.dev
# flutter pub publish --dry-run

##? Publish to pub.dev
# flutter pub publish

##? Forcefully publish package to pub.dev
# flutter pub publish --force

##? Get dependencies
# flutter pub get

##? Upgrade dependencies
# flutter pub upgrade

##? Deps command to check for dependencies
# flutter pub deps

##? Global command to run a package globally
# flutter pub global activate <package_name>

##? Global command to deactivate a package
# flutter pub global deactivate <package_name>

##? Global command to list all active packages
# flutter pub global list

##? Global command to run a script from a package
# flutter pub global run <package_name>

##? Global command to add a package to the system path
# flutter pub global add <package_name>

##? Global command to remove a package from the system path
# flutter pub global remove <package_name>

##? Cache command to repair cache
# flutter pub cache repair

##? Cache command to list all cached packages
# flutter pub cache list

##? Cache command to add a package to the cache
# flutter pub cache add <package_name>

##? Cache command to remove a package from the cache
# flutter pub cache remove <package_name>

##? Cache command to clear the cache
# flutter pub cache clear