#!/bin/sh

numb='550'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 35 --keyint 210 --lookahead-threads 4 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.5,1.0,2.8,0.3,0.8,0.1,3,0,8,35,210,4,23,10,3,0,63,38,2,1000,1:1,hex,show,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"