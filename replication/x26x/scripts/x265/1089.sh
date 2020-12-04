#!/bin/sh

numb='1090'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 0.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 50 --keyint 200 --lookahead-threads 3 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.3,1.1,0.8,0.3,0.7,0.6,0,0,6,50,200,3,30,30,5,1,69,38,5,1000,-2:-2,hex,crop,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"