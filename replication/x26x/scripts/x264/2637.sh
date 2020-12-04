#!/bin/sh

numb='2638'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 15 --keyint 290 --lookahead-threads 4 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.5,1.2,1.2,1.6,0.4,0.9,0.8,0,0,12,15,290,4,27,20,3,2,63,18,2,1000,-1:-1,hex,show,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"