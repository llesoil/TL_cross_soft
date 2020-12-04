#!/bin/sh

numb='36'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 45 --keyint 300 --lookahead-threads 2 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.4,1.1,3.6,0.2,0.7,0.2,2,0,6,45,300,2,21,40,5,4,64,38,4,2000,1:1,umh,show,medium,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"