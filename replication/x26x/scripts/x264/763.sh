#!/bin/sh

numb='764'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 50 --keyint 220 --lookahead-threads 2 --min-keyint 22 --qp 50 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.0,1.3,4.8,0.5,0.8,0.1,0,2,12,50,220,2,22,50,5,2,67,38,5,1000,-1:-1,dia,crop,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"