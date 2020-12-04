#!/bin/sh

numb='2121'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 35 --keyint 290 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 5 --qpmin 2 --qpmax 69 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.1,1.4,3.8,0.4,0.7,0.4,2,0,8,35,290,0,30,10,5,2,69,28,4,1000,1:1,umh,show,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"