#!/bin/sh

numb='2069'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 0 --keyint 300 --lookahead-threads 4 --min-keyint 25 --qp 20 --qpstep 5 --qpmin 4 --qpmax 65 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.4,1.6,0.4,0.8,0.1,0,1,0,0,300,4,25,20,5,4,65,38,5,1000,1:1,dia,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"