#!/bin/sh

numb='3034'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 4.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 50 --keyint 240 --lookahead-threads 2 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.6,1.4,4.6,0.5,0.6,0.5,3,1,10,50,240,2,22,0,4,4,67,28,4,1000,1:1,dia,show,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"