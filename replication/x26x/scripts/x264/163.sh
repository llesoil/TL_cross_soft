#!/bin/sh

numb='164'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 15 --keyint 280 --lookahead-threads 4 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.4,1.1,1.8,0.6,0.9,0.0,3,1,10,15,280,4,25,50,3,1,67,48,2,1000,1:1,umh,crop,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"