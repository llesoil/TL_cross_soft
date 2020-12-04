#!/bin/sh

numb='1844'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 10 --keyint 270 --lookahead-threads 3 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.2,1.0,4.4,0.2,0.6,0.5,0,2,12,10,270,3,28,40,5,0,67,28,1,1000,1:1,dia,show,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"