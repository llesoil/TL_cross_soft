#!/bin/sh

numb='2599'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 50 --keyint 270 --lookahead-threads 1 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.0,1.3,0.4,0.5,0.6,0.6,2,0,4,50,270,1,23,30,3,4,67,38,5,1000,1:1,umh,crop,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"