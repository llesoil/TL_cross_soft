#!/bin/sh

numb='8'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 50 --keyint 260 --lookahead-threads 2 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.2,1.0,2.4,0.5,0.9,0.1,3,0,10,50,260,2,24,10,5,1,61,48,2,1000,1:1,hex,show,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"