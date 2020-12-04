#!/bin/sh

numb='543'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 50 --keyint 210 --lookahead-threads 2 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 0 --qpmax 67 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.3,1.0,2.0,0.3,0.7,0.0,0,1,2,50,210,2,23,30,4,0,67,38,2,2000,1:1,umh,crop,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"