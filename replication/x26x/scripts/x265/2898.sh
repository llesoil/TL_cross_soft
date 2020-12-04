#!/bin/sh

numb='2899'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 30 --keyint 270 --lookahead-threads 3 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.1,1.4,3.8,0.4,0.9,0.4,0,1,8,30,270,3,30,30,4,2,60,18,5,1000,-1:-1,umh,show,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"