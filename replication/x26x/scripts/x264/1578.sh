#!/bin/sh

numb='1579'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 1.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 50 --keyint 290 --lookahead-threads 1 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.6,1.1,1.0,0.5,0.8,0.0,0,0,6,50,290,1,30,20,5,1,65,28,3,2000,1:1,umh,crop,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"