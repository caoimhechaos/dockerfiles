#!/bin/bash
set -x
cd /build
dnf --refresh builddep "$@"
if [[ "$@" == *rpm ]]
then
	exec su builder -c "/usr/bin/rpmbuild --rebuild $@"
else
	exec su builder -c "/usr/bin/rpmbuild -ba $@"
fi
