#!/bin/sh

numb='2874'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 0 --keyint 260 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.2,1.1,1.6,0.3,0.9,0.8,3,2,4,0,260,0,30,10,4,1,67,28,3,1000,-1:-1,dia,crop,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"