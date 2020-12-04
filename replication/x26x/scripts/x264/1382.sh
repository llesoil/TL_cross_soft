#!/bin/sh

numb='1383'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 5 --keyint 250 --lookahead-threads 1 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.5,1.0,1.2,0.6,0.7,0.1,3,1,10,5,250,1,21,20,3,4,65,28,3,1000,-1:-1,dia,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"