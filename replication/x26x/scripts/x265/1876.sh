#!/bin/sh

numb='1877'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 30 --keyint 250 --lookahead-threads 3 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 1 --qpmax 62 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.1,1.2,3.8,0.2,0.9,0.0,3,1,16,30,250,3,24,10,5,1,62,38,4,1000,1:1,hex,show,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"