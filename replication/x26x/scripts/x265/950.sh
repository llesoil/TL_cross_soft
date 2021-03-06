#!/bin/sh

numb='951'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 45 --keyint 200 --lookahead-threads 2 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.5,1.1,2.6,0.5,0.9,0.7,0,0,10,45,200,2,25,0,3,3,62,18,4,2000,-2:-2,dia,crop,veryfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"