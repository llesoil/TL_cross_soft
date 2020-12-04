#!/bin/sh

numb='850'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 45 --keyint 240 --lookahead-threads 0 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.5,1.5,1.0,0.4,0.3,0.8,0.8,0,1,6,45,240,0,28,0,4,4,68,48,1,1000,-1:-1,hex,show,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"