#!/bin/sh

numb='896'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 20 --keyint 270 --lookahead-threads 4 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.3,1.1,4.6,0.5,0.8,0.0,3,2,8,20,270,4,24,40,3,3,65,38,2,2000,-1:-1,umh,crop,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"