#!/bin/sh

numb='1494'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 0.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 35 --keyint 270 --lookahead-threads 1 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.0,1.2,1.3,0.2,0.5,0.9,0.8,2,2,2,35,270,1,21,0,4,0,61,38,3,1000,1:1,dia,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"