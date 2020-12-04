#!/bin/sh

numb='2805'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 30 --keyint 290 --lookahead-threads 1 --min-keyint 22 --qp 30 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.0,1.6,1.0,2.6,0.6,0.8,0.4,2,1,14,30,290,1,22,30,5,1,69,48,6,2000,-1:-1,dia,show,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"