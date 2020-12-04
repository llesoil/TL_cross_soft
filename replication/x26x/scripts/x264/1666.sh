#!/bin/sh

numb='1667'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 15 --keyint 250 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset placebo --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.6,1.3,3.8,0.6,0.6,0.6,1,2,4,15,250,2,30,40,3,0,66,48,1,1000,-1:-1,dia,show,placebo,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"