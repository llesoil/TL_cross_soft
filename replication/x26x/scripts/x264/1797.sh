#!/bin/sh

numb='1798'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 15 --keyint 230 --lookahead-threads 1 --min-keyint 23 --qp 50 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.1,1.1,4.6,0.2,0.9,0.6,0,2,12,15,230,1,23,50,3,3,62,38,3,2000,-2:-2,hex,crop,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"