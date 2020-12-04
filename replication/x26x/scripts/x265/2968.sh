#!/bin/sh

numb='2969'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 10 --keyint 240 --lookahead-threads 1 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.1,1.3,2.6,0.4,0.6,0.3,0,1,16,10,240,1,29,10,5,3,66,48,4,1000,-2:-2,hex,show,placebo,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"