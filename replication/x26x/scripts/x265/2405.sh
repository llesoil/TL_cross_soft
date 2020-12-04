#!/bin/sh

numb='2406'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 4.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 0 --keyint 270 --lookahead-threads 1 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 4 --qpmax 69 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.5,1.6,1.4,4.2,0.3,0.9,0.6,1,2,10,0,270,1,27,0,5,4,69,28,2,2000,-1:-1,umh,show,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"