#!/bin/sh

numb='648'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 15 --keyint 210 --lookahead-threads 0 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.5,1.2,1.3,2.6,0.2,0.6,0.7,1,2,2,15,210,0,22,20,3,4,64,38,5,1000,-1:-1,dia,show,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"