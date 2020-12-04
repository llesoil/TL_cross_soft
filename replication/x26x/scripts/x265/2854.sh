#!/bin/sh

numb='2855'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 45 --keyint 300 --lookahead-threads 1 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.2,1.4,0.4,0.3,0.9,0.7,3,2,8,45,300,1,28,0,5,0,67,48,4,1000,-2:-2,hex,show,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"