#!/bin/sh

numb='1915'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 30 --keyint 300 --lookahead-threads 1 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.4,1.4,4.0,0.2,0.6,0.2,2,1,12,30,300,1,28,20,5,0,62,38,3,2000,-2:-2,hex,crop,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"