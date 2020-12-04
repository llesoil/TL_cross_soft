#!/bin/sh

numb='2565'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 0.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 40 --keyint 240 --lookahead-threads 3 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.5,1.5,1.3,0.6,0.2,0.8,0.2,1,1,6,40,240,3,23,0,3,2,64,18,2,2000,1:1,umh,crop,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"