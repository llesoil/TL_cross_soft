#!/bin/sh

numb='556'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 5 --keyint 240 --lookahead-threads 3 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.4,1.3,3.8,0.3,0.8,0.5,0,0,6,5,240,3,30,20,5,2,63,38,4,1000,-1:-1,umh,show,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"