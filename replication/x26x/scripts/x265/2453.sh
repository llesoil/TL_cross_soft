#!/bin/sh

numb='2454'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 35 --keyint 290 --lookahead-threads 1 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.1,1.4,1.8,0.4,0.9,0.2,0,1,2,35,290,1,23,40,4,1,62,18,4,1000,-2:-2,dia,show,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"