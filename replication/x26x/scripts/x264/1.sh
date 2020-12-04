#!/bin/bash

numb='2'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 15 --keyint 250 --lookahead-threads 0 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/real//; s/,/./' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps// ; s/frames// ; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.0,1.4,1.1,4.6,0.5,0.9,0.7,0,0,4,15,250,0,26,20,3,3,62,38,2,2000,1:1,umh,crop,placebo,0,psnr,"
csvLine+="$size,$time,$persec"
echo "$csvLine"