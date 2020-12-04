#!/bin/sh

numb='2428'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 5.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 40 --keyint 250 --lookahead-threads 1 --min-keyint 25 --qp 30 --qpstep 4 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.1,1.4,5.0,0.2,0.8,0.9,1,0,8,40,250,1,25,30,4,4,63,38,4,1000,-2:-2,umh,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"