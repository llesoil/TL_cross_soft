#!/bin/sh

numb='1773'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 15 --keyint 260 --lookahead-threads 2 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.3,1.0,2.2,0.5,0.6,0.8,3,2,6,15,260,2,24,20,4,3,68,48,5,2000,1:1,hex,show,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"