#!/bin/sh

numb='2299'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 0.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 35 --keyint 300 --lookahead-threads 3 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.4,1.1,0.8,0.2,0.9,0.3,0,2,16,35,300,3,21,40,5,3,64,48,1,1000,-2:-2,hex,show,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"