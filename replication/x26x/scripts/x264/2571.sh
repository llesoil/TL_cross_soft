#!/bin/sh

numb='2572'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 40 --keyint 220 --lookahead-threads 2 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.3,1.1,1.6,0.3,0.8,0.3,2,1,12,40,220,2,26,50,3,1,63,48,1,2000,-1:-1,dia,show,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"