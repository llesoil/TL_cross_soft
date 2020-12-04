#!/bin/sh

numb='729'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 35 --keyint 220 --lookahead-threads 0 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.1,1.1,4.8,0.5,0.9,0.9,0,1,12,35,220,0,25,40,5,3,69,28,5,1000,-2:-2,umh,crop,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"