#!/bin/sh

numb='2410'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 15 --keyint 300 --lookahead-threads 4 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.2,1.2,0.6,0.3,0.8,0.4,3,2,0,15,300,4,22,50,4,1,60,38,1,2000,-1:-1,dia,crop,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"