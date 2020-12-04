#!/bin/sh

numb='1628'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 20 --keyint 270 --lookahead-threads 0 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.0,1.0,1.2,3.0,0.2,0.7,0.0,2,1,6,20,270,0,30,40,5,0,62,38,3,1000,1:1,umh,crop,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"