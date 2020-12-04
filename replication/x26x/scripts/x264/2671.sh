#!/bin/sh

numb='2672'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 40 --keyint 210 --lookahead-threads 3 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.0,1.1,2.0,0.3,0.9,0.6,3,0,10,40,210,3,24,40,3,3,64,48,2,1000,-1:-1,umh,show,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"