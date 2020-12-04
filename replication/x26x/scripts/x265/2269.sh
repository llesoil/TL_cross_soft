#!/bin/sh

numb='2270'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 45 --keyint 210 --lookahead-threads 0 --min-keyint 22 --qp 10 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset slower --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.2,1.1,1.0,0.2,0.6,0.4,3,0,0,45,210,0,22,10,3,1,62,28,6,2000,1:1,hex,crop,slower,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"