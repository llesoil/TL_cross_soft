#!/bin/sh

numb='2395'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 0 --keyint 210 --lookahead-threads 2 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 3 --qpmax 61 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.5,1.2,4.6,0.6,0.8,0.5,2,2,0,0,210,2,25,30,3,3,61,18,2,1000,-2:-2,umh,show,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"