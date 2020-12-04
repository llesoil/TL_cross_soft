#!/bin/sh

numb='1389'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 40 --keyint 300 --lookahead-threads 0 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.6,1.2,4.6,0.2,0.7,0.8,2,2,14,40,300,0,20,30,5,3,67,18,5,2000,-1:-1,hex,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"