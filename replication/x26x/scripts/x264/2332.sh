#!/bin/sh

numb='2333'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 5 --keyint 300 --lookahead-threads 2 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 4 --qpmax 69 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.5,1.1,1.2,0.2,0.3,0.9,0.1,3,1,16,5,300,2,21,40,5,4,69,38,1,1000,-2:-2,hex,crop,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"