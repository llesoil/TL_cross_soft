#!/bin/sh

numb='2439'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 1.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 35 --keyint 300 --lookahead-threads 0 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.1,1.3,1.4,0.3,0.6,0.7,1,0,12,35,300,0,30,30,5,0,68,28,6,1000,-1:-1,umh,crop,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"