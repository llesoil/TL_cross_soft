#!/bin/sh

numb='44'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 20 --keyint 210 --lookahead-threads 3 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,3.0,1.0,1.4,0.2,0.5,0.8,0.9,2,2,16,20,210,3,23,50,5,1,64,18,1,1000,-1:-1,hex,show,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"