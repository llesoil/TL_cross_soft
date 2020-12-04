#!/bin/sh

numb='1072'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 3.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 35 --keyint 230 --lookahead-threads 3 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.5,1.0,1.3,3.8,0.6,0.8,0.3,3,1,4,35,230,3,29,0,5,0,61,18,6,1000,-1:-1,hex,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"