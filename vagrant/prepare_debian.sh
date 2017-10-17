#!/bin/sh
#
# Install Git if not present
#
which git || apt-get update && apt-get install -y git
