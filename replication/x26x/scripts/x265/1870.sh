#!/bin/sh

numb='1871'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 15 --keyint 200 --lookahead-threads 0 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset superfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.4,1.0,3.2,0.4,0.9,0.1,3,0,14,15,200,0,26,20,4,0,69,18,2,1000,-2:-2,dia,crop,superfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"