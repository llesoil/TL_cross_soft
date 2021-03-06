#!/bin/sh

numb='897'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 5 --keyint 270 --lookahead-threads 0 --min-keyint 24 --qp 20 --qpstep 3 --qpmin 1 --qpmax 64 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,2.5,1.1,1.3,4.8,0.6,0.7,0.3,1,2,12,5,270,0,24,20,3,1,64,18,4,1000,-1:-1,hex,crop,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"