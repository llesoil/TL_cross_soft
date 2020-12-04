#!/bin/sh

numb='2797'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 3.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 50 --keyint 270 --lookahead-threads 4 --min-keyint 28 --qp 30 --qpstep 5 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.5,1.1,1.0,3.0,0.3,0.9,0.6,0,1,6,50,270,4,28,30,5,2,62,18,4,2000,1:1,hex,show,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"