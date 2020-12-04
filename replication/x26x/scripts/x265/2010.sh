#!/bin/sh

numb='2011'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 4.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 50 --keyint 270 --lookahead-threads 3 --min-keyint 28 --qp 50 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.3,1.3,4.8,0.3,0.6,0.4,1,0,0,50,270,3,28,50,3,3,65,18,3,2000,1:1,dia,crop,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"