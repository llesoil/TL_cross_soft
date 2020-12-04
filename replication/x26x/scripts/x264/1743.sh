#!/bin/sh

numb='1744'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 10 --keyint 280 --lookahead-threads 3 --min-keyint 21 --qp 20 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.0,1.0,1.0,1.6,0.6,0.9,0.2,2,2,10,10,280,3,21,20,5,1,61,18,4,1000,-2:-2,umh,show,veryslow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"