#!/bin/sh

numb='2031'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 45 --keyint 280 --lookahead-threads 3 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.0,1.2,0.6,0.2,0.9,0.4,0,0,14,45,280,3,29,40,4,3,64,48,6,1000,-2:-2,umh,show,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"