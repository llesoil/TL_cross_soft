#!/bin/sh

numb='324'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 5 --keyint 230 --lookahead-threads 0 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.3,1.3,2.6,0.5,0.6,0.9,1,2,12,5,230,0,21,0,4,2,69,28,4,2000,-2:-2,hex,show,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"