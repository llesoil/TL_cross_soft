#!/bin/sh

numb='65'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 15 --keyint 300 --lookahead-threads 3 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset superfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.1,1.3,4.6,0.5,0.6,0.1,1,0,2,15,300,3,25,20,3,1,68,38,4,2000,1:1,hex,crop,superfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"