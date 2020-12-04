#!/bin/sh

numb='387'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 5.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 10 --keyint 290 --lookahead-threads 0 --min-keyint 25 --qp 10 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.2,1.4,5.0,0.3,0.9,0.3,1,0,14,10,290,0,25,10,4,1,64,18,1,2000,-1:-1,umh,show,veryfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"