#!/bin/sh

numb='272'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 0.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 25 --keyint 210 --lookahead-threads 0 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.6,1.3,0.2,0.6,0.8,0.9,2,0,14,25,210,0,21,30,5,2,60,38,3,2000,-1:-1,dia,crop,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"