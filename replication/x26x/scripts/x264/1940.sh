#!/bin/sh

numb='1941'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 40 --keyint 200 --lookahead-threads 3 --min-keyint 22 --qp 50 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.6,1.0,1.8,0.4,0.8,0.7,1,0,6,40,200,3,22,50,3,4,69,18,6,2000,1:1,dia,show,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"