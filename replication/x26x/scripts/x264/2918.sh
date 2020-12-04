#!/bin/sh

numb='2919'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 1.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 20 --keyint 290 --lookahead-threads 2 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.0,1.2,1.0,0.4,0.6,0.1,3,2,10,20,290,2,25,0,3,3,67,28,3,1000,-1:-1,dia,show,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"