#!/bin/sh

numb='1098'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 35 --keyint 220 --lookahead-threads 3 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 0 --qpmax 61 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.5,1.3,4.6,0.3,0.8,0.3,0,2,12,35,220,3,25,50,5,0,61,38,1,2000,-2:-2,umh,show,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"