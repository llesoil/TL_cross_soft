#!/bin/sh

numb='266'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 45 --keyint 210 --lookahead-threads 3 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.0,1.3,0.8,0.4,0.6,0.9,3,0,0,45,210,3,24,20,5,4,66,18,4,1000,-1:-1,hex,show,veryfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"