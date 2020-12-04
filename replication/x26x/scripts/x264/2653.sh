#!/bin/sh

numb='2654'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 5 --keyint 270 --lookahead-threads 0 --min-keyint 20 --qp 30 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.1,1.1,0.2,0.2,0.7,0.6,0,2,6,5,270,0,20,30,4,1,60,28,5,2000,-1:-1,dia,show,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"