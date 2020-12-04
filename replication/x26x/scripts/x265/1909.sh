#!/bin/sh

numb='1910'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 2.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 20 --keyint 250 --lookahead-threads 1 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.3,1.4,2.0,0.4,0.9,0.8,2,2,14,20,250,1,23,10,3,4,62,38,5,1000,-2:-2,umh,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"