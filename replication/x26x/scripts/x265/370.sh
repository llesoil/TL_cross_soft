#!/bin/sh

numb='371'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 45 --keyint 290 --lookahead-threads 4 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.3,1.2,2.4,0.6,0.8,0.6,0,2,16,45,290,4,26,10,4,4,61,48,5,1000,1:1,umh,show,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"