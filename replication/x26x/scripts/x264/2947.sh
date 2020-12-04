#!/bin/sh

numb='2948'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 2.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 15 --keyint 300 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.2,1.2,2.0,0.5,0.9,0.4,0,2,10,15,300,0,30,0,5,1,61,48,3,2000,-2:-2,hex,crop,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"