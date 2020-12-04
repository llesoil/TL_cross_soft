#!/bin/sh

numb='2013'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 1.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 15 --keyint 260 --lookahead-threads 3 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.6,1.4,1.6,0.2,0.9,0.2,2,0,8,15,260,3,25,0,3,4,61,28,2,1000,-2:-2,umh,crop,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"