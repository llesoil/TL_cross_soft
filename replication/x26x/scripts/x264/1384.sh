#!/bin/sh

numb='1385'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 35 --keyint 300 --lookahead-threads 2 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.2,1.2,4.4,0.6,0.9,0.0,3,2,10,35,300,2,28,0,5,4,67,38,2,2000,1:1,umh,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"