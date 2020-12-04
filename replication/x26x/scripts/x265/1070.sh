#!/bin/sh

numb='1071'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 0 --keyint 300 --lookahead-threads 4 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.5,1.3,1.4,0.5,0.8,0.3,3,2,0,0,300,4,20,40,4,2,66,48,6,1000,-2:-2,dia,crop,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"