#!/bin/sh

numb='2704'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 3.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 25 --keyint 260 --lookahead-threads 3 --min-keyint 24 --qp 40 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.5,1.0,3.2,0.2,0.9,0.2,2,2,10,25,260,3,24,40,5,3,62,38,2,1000,1:1,umh,show,ultrafast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"