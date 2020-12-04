#!/bin/sh

numb='2475'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 5 --keyint 300 --lookahead-threads 2 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.5,1.0,4.8,0.2,0.9,0.0,1,0,16,5,300,2,28,0,5,1,69,28,2,2000,-1:-1,dia,crop,placebo,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"