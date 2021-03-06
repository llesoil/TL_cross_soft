#!/bin/sh

numb='2012'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 0.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 40 --keyint 260 --lookahead-threads 0 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.5,1.1,0.2,0.5,0.7,0.8,2,1,12,40,260,0,24,10,3,1,63,28,2,2000,1:1,umh,show,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"