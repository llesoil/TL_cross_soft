#!/bin/sh

numb='512'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 25 --keyint 290 --lookahead-threads 3 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.5,1.0,2.6,0.3,0.9,0.6,0,1,14,25,290,3,29,40,4,0,61,18,3,2000,1:1,dia,show,faster,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"