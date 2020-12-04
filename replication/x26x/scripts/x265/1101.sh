#!/bin/sh

numb='1102'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 4.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 25 --keyint 220 --lookahead-threads 2 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.1,1.0,4.8,0.5,0.8,0.2,2,0,16,25,220,2,23,40,3,3,64,28,6,1000,1:1,hex,crop,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"