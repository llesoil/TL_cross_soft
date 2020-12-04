#!/bin/sh

numb='1170'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 5.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 25 --keyint 270 --lookahead-threads 1 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.0,1.0,1.0,5.0,0.3,0.7,0.4,1,1,8,25,270,1,23,40,4,1,64,18,3,2000,-2:-2,hex,show,veryslow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"