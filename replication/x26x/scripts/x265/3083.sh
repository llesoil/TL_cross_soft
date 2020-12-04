#!/bin/sh

numb='3084'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 5.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 20 --keyint 220 --lookahead-threads 3 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.1,1.1,5.0,0.2,0.9,0.4,1,0,4,20,220,3,29,10,3,0,67,38,6,2000,-2:-2,dia,show,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"