#!/bin/sh

numb='1015'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 30 --keyint 280 --lookahead-threads 3 --min-keyint 20 --qp 10 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.3,1.2,4.2,0.3,0.8,0.4,3,0,16,30,280,3,20,10,5,2,60,38,5,2000,-1:-1,dia,show,veryfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"