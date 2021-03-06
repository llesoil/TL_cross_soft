#!/bin/sh

numb='1880'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 20 --keyint 280 --lookahead-threads 4 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.1,1.3,3.2,0.6,0.8,0.0,0,2,14,20,280,4,26,40,3,0,61,38,3,2000,-2:-2,umh,show,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"