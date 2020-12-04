#!/bin/sh

numb='2443'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 20 --keyint 270 --lookahead-threads 4 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.4,1.0,3.8,0.6,0.9,0.6,2,2,4,20,270,4,24,0,4,4,60,18,5,2000,1:1,hex,show,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"