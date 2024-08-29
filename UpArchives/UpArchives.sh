#!/bin/bash

source $(dirname $0)/.uparchives.cfg

date
rsync -av --protocol=29 $HOME/RMS_data/ArchivedFiles/*.tar.bz2 $SERVER:/home/srmn/archives/$ID
#rsync -av #HOME/RMS_data/ArchivedFiles/*.tar.bz2 $SERVER:/home/srmn/archives/$ID
rsync -av $HOME/RMS_data/*_fits_counts.txt $SERVER:/home/srmn/reports

