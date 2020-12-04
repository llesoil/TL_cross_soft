#!/bin/sh

numb='1097'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 5.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 15 --keyint 220 --lookahead-threads 4 --min-keyint 22 --qp 0 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.0,1.4,1.3,5.0,0.3,0.7,0.7,3,1,0,15,220,4,22,0,5,2,65,48,6,2000,1:1,dia,crop,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"