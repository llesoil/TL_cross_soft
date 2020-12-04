#!/bin/sh

numb='2489'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 0 --keyint 210 --lookahead-threads 4 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.3,1.0,4.2,0.2,0.9,0.7,1,1,14,0,210,4,29,0,3,0,64,18,6,2000,-2:-2,dia,crop,ultrafast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"