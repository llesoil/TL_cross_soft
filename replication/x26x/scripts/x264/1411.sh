#!/bin/sh

numb='1412'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 50 --keyint 240 --lookahead-threads 2 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.5,1.3,4.8,0.5,0.6,0.6,2,0,0,50,240,2,23,20,3,3,61,28,4,2000,-1:-1,umh,crop,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"