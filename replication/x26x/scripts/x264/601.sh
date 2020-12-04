#!/bin/sh

numb='602'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 40 --keyint 240 --lookahead-threads 3 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.5,1.2,3.6,0.6,0.7,0.9,3,0,6,40,240,3,30,30,3,4,67,48,1,2000,-2:-2,dia,show,placebo,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"