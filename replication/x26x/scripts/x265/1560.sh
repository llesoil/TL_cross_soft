#!/bin/sh

numb='1561'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 20 --keyint 280 --lookahead-threads 2 --min-keyint 23 --qp 20 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.1,1.3,3.8,0.3,0.7,0.1,1,2,16,20,280,2,23,20,4,1,66,38,6,2000,-2:-2,dia,show,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"