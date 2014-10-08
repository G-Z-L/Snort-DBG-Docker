############################################################
# Dockerfile to build Snort image for debugging
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu:14.04

# File Author / Maintainer
MAINTAINER Guozhu.Luo@gmail.com

################## BEGIN INSTALLATION ######################
# Install snort based on xmodulo (with some minor modification)
# http://xmodulo.com/how-to-compile-and-install-snort-from-source-code-on-ubuntu.html

# Update the repository sources list and Install dependencies
RUN apt-get update && apt-get install -y \
	flex \
	bison \
	build-essential \
	libpcap-dev \
	libnet1-dev \
	libpcre3-dev \
	libmysqlclient15-dev \
	libnetfilter-queue-dev \
	iptables-dev \
	curl \
	gdb \
	wget \
	vim

# Install libdnet
WORKDIR /snort
RUN wget https://libdnet.googlecode.com/files/libdnet-1.12.tgz && \
	tar xf libdnet-1.12.tgz
WORKDIR libdnet-1.12
RUN ./configure "CFLAGS=-fPIC" && \
	make install && \
	ln -s /usr/local/lib/libdnet.1.0.1 /usr/lib/libdnet.1 

# Install daq
WORKDIR /snort
RUN wget https://www.snort.org/downloads/snort/daq-2.0.2.tar.gz && \
	tar xf daq-2.0.2.tar.gz
WORKDIR daq-2.0.2
RUN ./configure && \
	make install

# Install snort
WORKDIR /snort
RUN wget https://www.snort.org/downloads/snort/snort-2.9.6.2.tar.gz && \
	tar xf snort-2.9.6.2.tar.gz
WORKDIR snort-2.9.6.2
RUN ./configure --enable-debug --enable-debug-msgs --enable-gdb && \
	make install && \
	ln -s /usr/local/bin/snort /usr/sbin/snort

WORKDIR /snort
# ldconfig
RUN ldconfig -v

##################### INSTALLATION END #####################
CMD snort -v