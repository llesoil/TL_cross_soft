#!/bin/sh

numb='2190'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 50 --keyint 260 --lookahead-threads 0 --min-keyint 29 --qp 40 --qpstep 3 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.5,1.4,1.3,4.6,0.5,0.8,0.8,2,2,8,50,260,0,29,40,3,0,60,18,3,2000,1:1,dia,show,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"