#!/bin/sh

numb='1797'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 45 --keyint 280 --lookahead-threads 3 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.4,1.4,2.8,0.4,0.8,0.6,0,1,10,45,280,3,26,10,4,0,65,18,4,1000,-1:-1,dia,crop,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"