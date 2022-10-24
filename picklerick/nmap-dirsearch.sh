#!/bin/bash
source ./nmap-dirsearch.lib
PATH_TO_DIRSEARCH="/home/jeff/tools/dirsearch-master"
getopts "m:" OPTION
MODE=$OPTARG
for i in "${@:$OPTIND:$#}"
do
    DOMAIN=$1
    DIRECTORY=${DOMAIN}_recon
    echo "Creating directory $DIRECTORY."
    mkdir $DIRECTORY
    case $MODE in
        nmap-only)
            nmap_scan
            ;;
        dirsearch-only)
            dirsearch_scan
            ;;
        *)
            nmap_scan
            dirsearch_scan
            ;;
    esac
    echo "Generating recon report for $DOMAIN..."
    TODAY=$(date)
    echo "This scan was created on $TODAY" > $DIRECTORY/report
    if [ -f $DIRECTORY/nmap ];then
        echo "Results for nmap:" >> $DIRECTORY/report
        cat $DIRECTORY/nmap >> $DIRECTORY/report
    fi
    if [ -f $DIRECTORY/dirsearch ];then
        echo "Results for dirsearch:" >>$DIRECTORY/report
        cat $DIRECTORY/dirsearch >> $DIRECTORY/report
    fi
done
