#!/bin/sh

numb='400'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 15 --keyint 300 --lookahead-threads 1 --min-keyint 24 --qp 10 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.0,1.3,1.8,0.2,0.7,0.1,3,2,14,15,300,1,24,10,4,3,63,38,2,1000,-2:-2,hex,crop,placebo,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"