#!/bin/sh

numb='3086'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 25 --keyint 210 --lookahead-threads 1 --min-keyint 27 --qp 0 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.3,1.0,1.8,0.2,0.7,0.8,3,1,12,25,210,1,27,0,4,0,61,28,1,2000,1:1,hex,crop,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"