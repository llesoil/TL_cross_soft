#!/bin/sh

numb='2016'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 3.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 40 --keyint 240 --lookahead-threads 3 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.2,1.4,3.0,0.4,0.8,0.9,1,1,14,40,240,3,26,20,3,3,61,28,3,2000,1:1,hex,crop,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"