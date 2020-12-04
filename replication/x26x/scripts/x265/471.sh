#!/bin/sh

numb='472'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 10 --keyint 260 --lookahead-threads 4 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.6,1.3,4.8,0.2,0.8,0.4,0,0,16,10,260,4,30,0,4,4,67,48,1,2000,-2:-2,hex,show,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"