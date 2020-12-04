#!/bin/sh

numb='1926'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 25 --keyint 230 --lookahead-threads 0 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.5,1.0,0.4,0.3,0.9,0.1,2,0,2,25,230,0,25,50,4,1,66,28,2,1000,-2:-2,hex,show,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"