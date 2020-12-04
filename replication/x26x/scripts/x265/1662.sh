#!/bin/sh

numb='1663'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 45 --keyint 250 --lookahead-threads 3 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,3.0,1.1,1.1,0.8,0.3,0.8,0.7,0,1,16,45,250,3,30,10,4,0,64,38,2,1000,-2:-2,umh,crop,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"