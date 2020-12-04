#!/bin/sh

numb='1210'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 0 --keyint 290 --lookahead-threads 0 --min-keyint 26 --qp 0 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset ultrafast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.0,1.2,4.8,0.4,0.6,0.8,3,0,4,0,290,0,26,0,3,2,67,28,1,2000,1:1,dia,show,ultrafast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"