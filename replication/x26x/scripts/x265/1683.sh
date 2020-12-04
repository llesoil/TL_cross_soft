#!/bin/sh

numb='1684'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 0 --keyint 270 --lookahead-threads 3 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 4 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.0,1.3,1.4,0.8,0.3,0.6,0.3,0,2,14,0,270,3,26,40,3,4,64,28,4,2000,-1:-1,hex,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"