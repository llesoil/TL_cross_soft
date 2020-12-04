#!/bin/sh

numb='2889'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --intra-refresh --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 15 --keyint 240 --lookahead-threads 0 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset placebo --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,--no-asm,--slow-firstpass,--weightb,0.0,1.6,1.3,2.2,0.5,0.6,0.8,1,1,12,15,240,0,23,40,3,0,61,38,1,2000,-2:-2,umh,show,placebo,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"