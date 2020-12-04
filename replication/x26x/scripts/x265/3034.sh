#!/bin/sh

numb='3035'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 3.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 25 --keyint 270 --lookahead-threads 1 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.1,1.1,3.4,0.2,0.8,0.3,2,0,16,25,270,1,30,40,3,2,60,28,4,1000,-1:-1,umh,show,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"