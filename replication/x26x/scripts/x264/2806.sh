#!/bin/sh

numb='2807'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 50 --keyint 280 --lookahead-threads 2 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.5,1.1,1.2,0.2,0.4,0.6,0.3,2,0,6,50,280,2,21,40,4,3,67,38,6,2000,-2:-2,hex,crop,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"