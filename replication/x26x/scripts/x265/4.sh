#!/bin/sh

numb='5'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 0 --keyint 270 --lookahead-threads 1 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.6,1.3,4.4,0.4,0.8,0.1,2,0,0,0,270,1,24,40,3,2,66,28,3,1000,-2:-2,dia,show,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"