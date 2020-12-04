#!/bin/sh

numb='3042'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 1.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 40 --keyint 280 --lookahead-threads 0 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.6,1.1,1.6,0.6,0.7,0.2,2,2,6,40,280,0,24,50,3,3,66,38,3,2000,-1:-1,umh,show,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"