#!/bin/sh

numb='3008'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 25 --keyint 210 --lookahead-threads 0 --min-keyint 28 --qp 50 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.3,1.0,2.2,0.6,0.6,0.8,1,1,12,25,210,0,28,50,3,4,63,18,3,2000,1:1,dia,show,slower,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"