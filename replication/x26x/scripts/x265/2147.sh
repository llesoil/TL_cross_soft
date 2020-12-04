#!/bin/sh

numb='2148'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 35 --keyint 260 --lookahead-threads 2 --min-keyint 22 --qp 50 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.6,1.2,1.4,0.5,0.9,0.4,0,1,0,35,260,2,22,50,5,2,64,38,3,1000,1:1,hex,crop,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"