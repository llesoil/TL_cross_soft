#!/bin/sh

numb='2122'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 20 --keyint 290 --lookahead-threads 2 --min-keyint 29 --qp 40 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.1,1.4,1.8,0.6,0.8,0.1,2,1,0,20,290,2,29,40,5,0,67,48,3,1000,1:1,umh,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"