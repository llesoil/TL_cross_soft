#!/bin/sh

numb='1212'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 0 --keyint 210 --lookahead-threads 2 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.1,1.1,2.2,0.2,0.9,0.5,2,1,12,0,210,2,23,40,4,3,60,28,2,2000,-1:-1,hex,show,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"