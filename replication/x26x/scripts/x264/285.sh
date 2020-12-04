#!/bin/sh

numb='286'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 25 --keyint 300 --lookahead-threads 1 --min-keyint 26 --qp 30 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.2,1.2,0.4,0.6,0.6,0.9,3,0,4,25,300,1,26,30,3,2,60,38,3,1000,-2:-2,hex,crop,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"