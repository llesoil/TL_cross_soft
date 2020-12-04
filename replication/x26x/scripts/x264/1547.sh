#!/bin/sh

numb='1548'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 1.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 10 --keyint 270 --lookahead-threads 1 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.2,1.4,1.4,0.2,0.7,0.2,1,1,8,10,270,1,25,30,3,3,61,28,5,2000,-2:-2,hex,show,fast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"