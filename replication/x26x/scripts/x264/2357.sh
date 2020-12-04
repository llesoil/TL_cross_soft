#!/bin/sh

numb='2358'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 25 --keyint 250 --lookahead-threads 0 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.0,1.3,1.0,4.0,0.5,0.6,0.9,3,1,14,25,250,0,26,50,3,1,68,18,4,1000,-2:-2,hex,show,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"