#!/bin/sh

numb='2173'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 25 --keyint 200 --lookahead-threads 2 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.2,1.0,3.6,0.6,0.8,0.5,0,0,10,25,200,2,30,10,3,3,69,38,6,1000,-1:-1,dia,crop,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"