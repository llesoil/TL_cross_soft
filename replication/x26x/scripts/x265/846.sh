#!/bin/sh

numb='847'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 30 --keyint 200 --lookahead-threads 0 --min-keyint 20 --qp 40 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.1,1.4,2.4,0.3,0.7,0.6,3,0,0,30,200,0,20,40,5,2,67,48,5,1000,-2:-2,hex,crop,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"