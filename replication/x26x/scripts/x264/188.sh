#!/bin/sh

numb='189'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 30 --keyint 230 --lookahead-threads 0 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.5,1.5,1.1,4.0,0.2,0.9,0.6,2,2,14,30,230,0,25,20,3,2,62,18,3,1000,-1:-1,hex,crop,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"