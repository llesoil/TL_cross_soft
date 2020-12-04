#!/bin/sh

numb='3029'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --intra-refresh --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 35 --keyint 240 --lookahead-threads 4 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,None,--slow-firstpass,--no-weightb,2.5,1.6,1.3,3.6,0.3,0.7,0.6,1,2,2,35,240,4,29,50,4,0,62,48,1,1000,-1:-1,hex,crop,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"