#!/bin/sh

numb='581'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 0.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 40 --keyint 300 --lookahead-threads 0 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,3.0,1.5,1.1,0.8,0.2,0.7,0.5,0,1,8,40,300,0,27,40,4,2,62,48,1,1000,-2:-2,dia,crop,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"