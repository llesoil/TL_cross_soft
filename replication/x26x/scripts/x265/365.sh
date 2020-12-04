#!/bin/sh

numb='366'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 30 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.5,1.0,1.2,4.0,0.3,0.8,0.6,2,0,8,30,230,2,30,50,5,3,66,38,5,2000,-2:-2,dia,crop,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"