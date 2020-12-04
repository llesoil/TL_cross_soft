#!/bin/sh

numb='2963'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 20 --keyint 210 --lookahead-threads 2 --min-keyint 26 --qp 0 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.6,1.0,1.2,0.6,0.7,0.6,1,0,10,20,210,2,26,0,3,1,60,38,2,1000,-1:-1,hex,show,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"