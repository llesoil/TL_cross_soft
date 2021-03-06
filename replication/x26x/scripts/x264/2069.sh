#!/bin/sh

numb='2070'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 4.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 15 --keyint 280 --lookahead-threads 3 --min-keyint 25 --qp 0 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.0,1.0,4.2,0.3,0.7,0.2,3,2,6,15,280,3,25,0,4,0,62,28,1,2000,1:1,umh,show,fast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"