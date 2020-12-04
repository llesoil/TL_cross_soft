#!/bin/sh

numb='1957'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 10 --keyint 280 --lookahead-threads 1 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.6,1.0,1.4,0.3,0.7,0.2,1,2,0,10,280,1,29,30,5,0,67,28,3,2000,1:1,umh,crop,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"