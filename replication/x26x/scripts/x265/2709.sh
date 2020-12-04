#!/bin/sh

numb='2710'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 0 --keyint 200 --lookahead-threads 3 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.0,1.4,1.1,1.0,0.6,0.6,0.0,0,0,12,0,200,3,23,40,3,2,65,48,2,2000,-2:-2,umh,show,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"