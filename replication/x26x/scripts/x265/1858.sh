#!/bin/sh

numb='1859'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 15 --keyint 240 --lookahead-threads 2 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.4,1.2,0.2,0.4,0.6,0.9,2,1,6,15,240,2,27,10,5,3,66,48,6,1000,-2:-2,hex,show,slower,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"