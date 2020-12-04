#!/bin/sh

numb='1344'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 3.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 50 --keyint 240 --lookahead-threads 3 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.1,1.1,3.6,0.6,0.8,0.2,1,1,12,50,240,3,30,50,5,4,67,48,4,2000,1:1,hex,show,slower,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"