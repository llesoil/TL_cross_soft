#!/bin/sh

numb='2555'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 25 --keyint 300 --lookahead-threads 2 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.0,1.1,3.8,0.6,0.9,0.5,0,1,16,25,300,2,25,40,3,2,60,48,6,2000,-1:-1,umh,show,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"