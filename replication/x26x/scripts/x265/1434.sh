#!/bin/sh

numb='1435'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 35 --keyint 270 --lookahead-threads 1 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset ultrafast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.4,1.8,0.4,0.9,0.7,3,1,12,35,270,1,23,40,4,3,69,18,1,1000,-2:-2,hex,crop,ultrafast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"