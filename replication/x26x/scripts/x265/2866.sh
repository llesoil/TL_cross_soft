#!/bin/sh

numb='2867'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 25 --keyint 210 --lookahead-threads 0 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.3,1.0,3.4,0.4,0.8,0.4,1,0,0,25,210,0,20,40,3,4,61,38,3,1000,-2:-2,umh,crop,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"