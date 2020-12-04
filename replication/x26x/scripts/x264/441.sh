#!/bin/sh

numb='442'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 0 --keyint 270 --lookahead-threads 2 --min-keyint 26 --qp 30 --qpstep 4 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.4,1.2,4.6,0.5,0.7,0.7,3,0,8,0,270,2,26,30,4,4,63,48,2,1000,1:1,hex,show,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"