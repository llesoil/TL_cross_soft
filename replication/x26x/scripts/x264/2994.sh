#!/bin/sh

numb='2995'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 30 --keyint 270 --lookahead-threads 1 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.3,1.2,4.2,0.3,0.6,0.2,0,1,12,30,270,1,25,0,3,3,67,48,1,2000,-1:-1,dia,show,veryfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"