#!/bin/sh

numb='1032'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 0 --keyint 300 --lookahead-threads 1 --min-keyint 26 --qp 10 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.3,1.2,2.6,0.2,0.8,0.2,1,2,2,0,300,1,26,10,5,0,65,18,3,2000,-1:-1,dia,crop,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"