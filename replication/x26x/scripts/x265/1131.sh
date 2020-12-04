#!/bin/sh

numb='1132'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 15 --keyint 290 --lookahead-threads 4 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.0,1.0,1.2,2.8,0.5,0.7,0.6,3,2,12,15,290,4,25,20,4,1,67,18,1,2000,-1:-1,dia,crop,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"