#!/bin/bash

numb='5'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 4.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 5 --keyint 300 --lookahead-threads 3 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/real//; s/,/./' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps// ; s/frames// ; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.1,1.0,4.6,0.3,0.8,0.9,3,2,16,5,300,3,20,10,3,2,62,18,3,2000,-2:-2,umh,crop,slower,40,psnr,"
csvLine+="$size,$time,$persec"
echo "$csvLine"