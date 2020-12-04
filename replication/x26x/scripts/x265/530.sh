#!/bin/sh

numb='531'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 45 --keyint 240 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.3,1.0,1.2,0.4,0.7,0.2,2,1,12,45,240,4,27,40,4,2,60,48,5,1000,-2:-2,hex,show,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"