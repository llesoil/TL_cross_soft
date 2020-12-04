#!/bin/sh

numb='1247'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 1.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 50 --keyint 290 --lookahead-threads 1 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 3 --qpmax 68 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.2,1.4,1.6,0.3,0.9,0.0,2,0,16,50,290,1,23,40,3,3,68,18,2,2000,-2:-2,hex,show,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"