#!/bin/sh

numb='121'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 45 --keyint 210 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.6,1.0,2.0,0.5,0.6,0.3,3,1,0,45,210,0,30,10,4,0,60,18,3,1000,1:1,hex,crop,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"