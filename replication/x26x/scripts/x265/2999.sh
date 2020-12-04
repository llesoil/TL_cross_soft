#!/bin/sh

numb='3000'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 10 --keyint 230 --lookahead-threads 1 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.3,1.1,3.4,0.6,0.6,0.6,1,1,8,10,230,1,26,50,4,2,67,48,3,2000,1:1,umh,crop,ultrafast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"