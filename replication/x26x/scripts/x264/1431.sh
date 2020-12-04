#!/bin/sh

numb='1432'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 20 --keyint 250 --lookahead-threads 4 --min-keyint 20 --qp 0 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.5,1.5,1.3,2.2,0.2,0.6,0.2,3,0,2,20,250,4,20,0,4,3,68,48,5,1000,-2:-2,hex,crop,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"