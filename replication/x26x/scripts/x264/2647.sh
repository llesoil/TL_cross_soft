#!/bin/sh

numb='2648'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 40 --keyint 200 --lookahead-threads 4 --min-keyint 21 --qp 50 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.3,1.2,2.8,0.4,0.9,0.1,0,2,14,40,200,4,21,50,5,2,67,28,6,2000,1:1,dia,crop,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"