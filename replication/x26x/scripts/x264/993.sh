#!/bin/sh

numb='994'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 35 --keyint 210 --lookahead-threads 2 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset fast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.0,1.3,1.4,0.2,0.9,0.5,1,1,6,35,210,2,20,30,5,1,69,18,3,1000,1:1,dia,crop,fast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"