#!/bin/sh

numb='1045'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 40 --keyint 270 --lookahead-threads 1 --min-keyint 23 --qp 0 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.5,1.4,1.2,4.2,0.5,0.8,0.5,2,1,2,40,270,1,23,0,5,4,62,28,2,1000,-2:-2,umh,crop,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"