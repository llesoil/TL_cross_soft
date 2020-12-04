#!/bin/sh

numb='1568'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 25 --keyint 300 --lookahead-threads 3 --min-keyint 30 --qp 0 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.1,1.4,2.0,0.5,0.7,0.7,2,0,4,25,300,3,30,0,5,0,67,18,3,1000,-1:-1,hex,crop,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"