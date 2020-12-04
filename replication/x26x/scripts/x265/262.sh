#!/bin/sh

numb='263'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 1.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 15 --keyint 300 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 0 --qpmax 61 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.2,1.0,1.4,0.6,0.7,0.6,2,1,2,15,300,4,27,40,5,0,61,38,2,2000,-1:-1,umh,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"