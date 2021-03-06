#!/bin/sh

numb='746'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 1.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 50 --keyint 220 --lookahead-threads 0 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 1 --qpmax 62 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.1,1.1,1.4,0.2,0.7,0.5,0,0,2,50,220,0,20,30,5,1,62,48,3,2000,-2:-2,hex,show,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"