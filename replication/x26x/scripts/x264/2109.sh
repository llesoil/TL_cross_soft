#!/bin/sh

numb='2110'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 0 --keyint 210 --lookahead-threads 1 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.0,1.5,1.0,4.6,0.2,0.9,0.1,1,0,16,0,210,1,29,50,4,0,65,18,1,1000,-1:-1,hex,crop,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"