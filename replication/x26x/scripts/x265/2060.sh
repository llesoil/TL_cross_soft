#!/bin/sh

numb='2061'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 5 --keyint 210 --lookahead-threads 3 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.5,1.5,1.2,3.2,0.3,0.7,0.2,3,0,0,5,210,3,29,10,5,0,64,28,2,2000,1:1,umh,show,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"