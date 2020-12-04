#!/bin/sh

numb='2153'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 1.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 0 --crf 10 --keyint 270 --lookahead-threads 2 --min-keyint 27 --qp 50 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.4,1.0,1.8,0.3,0.6,0.0,0,0,0,10,270,2,27,50,4,3,65,38,3,1000,1:1,hex,crop,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"