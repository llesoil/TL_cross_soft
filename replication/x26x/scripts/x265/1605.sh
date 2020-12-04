#!/bin/sh

numb='1606'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 5 --keyint 200 --lookahead-threads 3 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.3,1.3,2.0,0.2,0.6,0.9,2,1,14,5,200,3,25,50,4,0,69,28,6,1000,-2:-2,dia,show,superfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"