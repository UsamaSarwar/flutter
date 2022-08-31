#!/bin/sh
##? Create Flutter package to publish it at pub.dev
flutter create --template = package --org=usama.dev unique_package_name

##? Dry run before publishing to to pub.dev
flutter pub publish --dry-run

##? Publish to pub.dev
flutter pub publish

##? Forecefully publish package to pub.dev
flutter pub publish --force