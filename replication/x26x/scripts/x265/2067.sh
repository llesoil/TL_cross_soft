#!/bin/sh

numb='2068'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 50 --keyint 210 --lookahead-threads 3 --min-keyint 25 --qp 0 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.0,1.2,4.8,0.3,0.9,0.4,2,2,0,50,210,3,25,0,5,0,67,18,1,2000,1:1,hex,crop,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"