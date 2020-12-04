#!/bin/sh

numb='2532'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 5.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 40 --keyint 200 --lookahead-threads 0 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.2,1.2,5.0,0.6,0.7,0.1,2,2,10,40,200,0,22,20,4,2,69,18,1,2000,1:1,hex,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"