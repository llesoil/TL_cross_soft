#!/bin/sh

numb='250'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 4.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 15 --keyint 230 --lookahead-threads 4 --min-keyint 22 --qp 30 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.0,1.0,4.6,0.6,0.7,0.1,3,1,14,15,230,4,22,30,4,2,66,48,4,2000,-1:-1,dia,crop,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"