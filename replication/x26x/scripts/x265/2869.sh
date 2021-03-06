#!/bin/sh

numb='2870'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 5 --keyint 270 --lookahead-threads 3 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.4,1.0,3.4,0.3,0.6,0.0,2,2,10,5,270,3,22,20,4,3,66,38,4,2000,-2:-2,hex,show,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"