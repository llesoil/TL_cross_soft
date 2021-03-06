#!/bin/sh

numb='1783'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 3.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 20 --keyint 240 --lookahead-threads 4 --min-keyint 24 --qp 0 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.1,1.1,3.8,0.4,0.6,0.4,3,1,8,20,240,4,24,0,5,0,62,48,6,1000,1:1,hex,crop,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"