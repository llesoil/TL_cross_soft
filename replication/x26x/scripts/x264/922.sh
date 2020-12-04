#!/bin/sh

numb='923'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 2.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 0 --keyint 230 --lookahead-threads 3 --min-keyint 28 --qp 40 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.1,1.2,2.0,0.2,0.6,0.5,2,2,4,0,230,3,28,40,3,2,67,28,1,1000,-2:-2,dia,crop,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"