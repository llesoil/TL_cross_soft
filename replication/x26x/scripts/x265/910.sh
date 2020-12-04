#!/bin/sh

numb='911'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 20 --keyint 240 --lookahead-threads 0 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.0,1.3,1.2,0.3,0.7,0.6,0,1,2,20,240,0,24,10,5,3,65,18,2,1000,1:1,umh,show,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"