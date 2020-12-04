#!/bin/sh

numb='2361'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 50 --keyint 300 --lookahead-threads 3 --min-keyint 22 --qp 30 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.5,1.2,1.1,1.2,0.2,0.6,0.3,3,0,0,50,300,3,22,30,5,3,61,38,5,2000,-2:-2,dia,show,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"