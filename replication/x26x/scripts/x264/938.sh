#!/bin/sh

numb='939'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 40 --keyint 260 --lookahead-threads 0 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.2,1.2,0.8,0.6,0.9,0.9,1,1,14,40,260,0,23,40,4,2,62,18,1,2000,-2:-2,dia,show,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"