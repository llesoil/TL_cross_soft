#!/bin/sh

numb='2663'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 3.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 25 --keyint 230 --lookahead-threads 2 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.1,1.0,3.2,0.5,0.9,0.9,0,1,6,25,230,2,24,20,4,3,63,38,3,1000,-2:-2,umh,show,superfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"