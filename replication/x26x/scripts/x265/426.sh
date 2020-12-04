#!/bin/sh

numb='427'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 25 --keyint 200 --lookahead-threads 1 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.0,1.2,2.2,0.6,0.6,0.2,2,0,16,25,200,1,23,30,4,3,69,38,1,2000,-2:-2,dia,crop,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"