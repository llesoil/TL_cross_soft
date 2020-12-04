#!/bin/sh

numb='1402'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 5.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 20 --keyint 210 --lookahead-threads 1 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.1,1.0,5.0,0.3,0.7,0.0,0,2,12,20,210,1,23,20,5,1,65,38,4,2000,-2:-2,hex,crop,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"