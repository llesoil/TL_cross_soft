#!/bin/sh

numb='498'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 0.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 40 --keyint 250 --lookahead-threads 4 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.5,1.5,1.4,0.4,0.4,0.6,0.1,1,0,12,40,250,4,27,30,3,4,66,38,5,2000,-2:-2,umh,crop,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"