#!/bin/sh

numb='998'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 25 --keyint 270 --lookahead-threads 4 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.0,1.2,2.2,0.3,0.9,0.8,2,2,0,25,270,4,30,30,3,1,62,48,3,2000,-1:-1,dia,show,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"