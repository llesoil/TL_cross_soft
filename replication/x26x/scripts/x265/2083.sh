#!/bin/sh

numb='2084'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 5 --keyint 250 --lookahead-threads 0 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.0,1.3,2.2,0.2,0.8,0.5,1,0,10,5,250,0,22,0,4,2,60,38,1,1000,-2:-2,dia,show,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"