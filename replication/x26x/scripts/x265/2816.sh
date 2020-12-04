#!/bin/sh

numb='2817'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 15 --keyint 230 --lookahead-threads 2 --min-keyint 25 --qp 30 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.6,1.1,4.6,0.3,0.8,0.1,1,0,14,15,230,2,25,30,5,3,69,28,4,2000,1:1,dia,crop,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"