#!/bin/sh

numb='1472'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 20 --keyint 300 --lookahead-threads 3 --min-keyint 28 --qp 30 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.2,1.3,3.0,0.5,0.7,0.8,3,1,0,20,300,3,28,30,5,3,69,28,2,2000,1:1,dia,show,faster,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"