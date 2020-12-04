#!/bin/sh

numb='905'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 0.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 25 --keyint 210 --lookahead-threads 2 --min-keyint 23 --qp 50 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.2,1.0,0.4,0.2,0.8,0.4,2,1,0,25,210,2,23,50,4,2,69,28,1,2000,-1:-1,hex,crop,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"