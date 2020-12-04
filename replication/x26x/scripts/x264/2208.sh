#!/bin/sh

numb='2209'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 50 --keyint 250 --lookahead-threads 0 --min-keyint 26 --qp 50 --qpstep 5 --qpmin 1 --qpmax 66 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.4,1.0,2.8,0.3,0.9,0.9,0,2,8,50,250,0,26,50,5,1,66,48,3,1000,-2:-2,dia,show,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"