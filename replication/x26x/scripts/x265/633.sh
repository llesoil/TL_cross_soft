#!/bin/sh

numb='634'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 4.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 50 --keyint 240 --lookahead-threads 2 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.3,1.4,4.2,0.3,0.8,0.1,1,2,6,50,240,2,28,10,3,0,66,18,1,1000,-1:-1,umh,crop,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"