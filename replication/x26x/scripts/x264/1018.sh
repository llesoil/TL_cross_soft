#!/bin/sh

numb='1019'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 3.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 40 --keyint 250 --lookahead-threads 2 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.2,1.2,3.4,0.4,0.8,0.9,1,2,2,40,250,2,25,20,4,2,60,38,3,2000,1:1,umh,crop,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"