#!/bin/sh

numb='2201'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 15 --keyint 260 --lookahead-threads 3 --min-keyint 28 --qp 50 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.3,1.0,4.4,0.5,0.7,0.1,3,1,4,15,260,3,28,50,5,1,65,28,3,2000,-1:-1,hex,crop,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"