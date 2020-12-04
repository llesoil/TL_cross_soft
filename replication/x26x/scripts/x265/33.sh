#!/bin/sh

numb='34'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 40 --keyint 270 --lookahead-threads 1 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.0,1.3,4.6,0.5,0.9,0.0,3,0,0,40,270,1,30,40,3,0,65,48,2,2000,-2:-2,dia,crop,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"