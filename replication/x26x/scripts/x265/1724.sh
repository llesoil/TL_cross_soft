#!/bin/sh

numb='1725'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 2.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 0 --keyint 220 --lookahead-threads 2 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.0,1.0,2.4,0.2,0.7,0.8,2,1,4,0,220,2,25,50,4,4,65,28,4,2000,1:1,dia,show,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"