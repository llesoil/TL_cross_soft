#!/bin/sh

numb='576'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 5.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 15 --keyint 260 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.1,1.4,5.0,0.5,0.8,0.9,3,2,0,15,260,2,28,20,5,3,61,18,4,1000,-1:-1,umh,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"