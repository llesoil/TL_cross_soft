#!/bin/sh

numb='2093'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 0 --keyint 250 --lookahead-threads 4 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.5,1.2,4.0,0.6,0.6,0.6,3,1,10,0,250,4,24,40,4,4,66,28,1,2000,1:1,hex,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"