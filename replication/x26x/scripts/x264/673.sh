#!/bin/sh

numb='674'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 1.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 30 --keyint 200 --lookahead-threads 3 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.6,1.1,1.6,0.6,0.7,0.3,3,2,8,30,200,3,28,10,5,1,69,48,1,1000,1:1,dia,show,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"