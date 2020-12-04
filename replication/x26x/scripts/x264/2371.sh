#!/bin/sh

numb='2372'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 15 --keyint 240 --lookahead-threads 3 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 3 --qpmax 68 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.4,1.2,4.0,0.6,0.9,0.0,0,2,14,15,240,3,22,20,3,3,68,48,6,2000,-1:-1,hex,show,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"