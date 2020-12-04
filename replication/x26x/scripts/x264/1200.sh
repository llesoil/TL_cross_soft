#!/bin/sh

numb='1201'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 30 --keyint 240 --lookahead-threads 1 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.3,1.4,1.8,0.4,0.6,0.0,0,1,2,30,240,1,21,30,5,2,64,48,2,2000,-2:-2,dia,crop,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"