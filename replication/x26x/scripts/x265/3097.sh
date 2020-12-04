#!/bin/sh

numb='3098'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 1.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 50 --keyint 200 --lookahead-threads 4 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.4,1.4,1.8,0.3,0.6,0.3,0,0,6,50,200,4,21,30,3,4,67,38,5,2000,1:1,umh,crop,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"