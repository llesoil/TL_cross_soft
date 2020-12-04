#!/bin/sh

numb='1672'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 30 --keyint 260 --lookahead-threads 0 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 4 --qpmax 65 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.1,1.3,2.8,0.6,0.8,0.3,3,2,12,30,260,0,29,20,5,4,65,38,2,2000,1:1,hex,show,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"