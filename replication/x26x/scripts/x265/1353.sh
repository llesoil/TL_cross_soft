#!/bin/sh

numb='1354'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 20 --keyint 270 --lookahead-threads 2 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,3.0,1.5,1.1,2.4,0.6,0.8,0.1,0,1,6,20,270,2,21,50,4,2,60,48,5,2000,1:1,umh,crop,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"