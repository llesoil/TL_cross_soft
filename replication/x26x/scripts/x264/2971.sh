#!/bin/sh

numb='2972'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 0.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 40 --keyint 220 --lookahead-threads 1 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.2,1.3,0.6,0.6,0.7,0.6,3,1,0,40,220,1,24,50,5,4,64,18,6,2000,-1:-1,umh,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"