#!/bin/sh

numb='2643'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 0 --keyint 250 --lookahead-threads 2 --min-keyint 20 --qp 10 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.0,1.3,2.2,0.6,0.8,0.7,3,1,0,0,250,2,20,10,5,3,63,18,6,1000,-1:-1,umh,show,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"