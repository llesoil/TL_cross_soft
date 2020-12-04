#!/bin/sh

numb='79'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 35 --keyint 270 --lookahead-threads 3 --min-keyint 20 --qp 40 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.6,1.0,2.0,0.2,0.6,0.2,3,0,6,35,270,3,20,40,5,4,67,48,2,2000,1:1,dia,crop,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"