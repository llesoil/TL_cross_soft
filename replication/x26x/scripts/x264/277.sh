#!/bin/sh

numb='278'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 10 --keyint 300 --lookahead-threads 4 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.4,1.0,2.8,0.6,0.9,0.8,1,1,8,10,300,4,22,0,4,1,64,38,2,1000,-2:-2,hex,crop,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"