#!/bin/sh

numb='821'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 25 --keyint 290 --lookahead-threads 1 --min-keyint 30 --qp 0 --qpstep 5 --qpmin 1 --qpmax 62 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.4,1.2,3.2,0.6,0.8,0.6,1,2,12,25,290,1,30,0,5,1,62,18,1,1000,-1:-1,hex,crop,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"