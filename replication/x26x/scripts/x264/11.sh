#!/bin/sh

numb='12'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 30 --keyint 230 --lookahead-threads 1 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.5,1.4,1.4,0.2,0.7,0.5,1,2,4,30,230,1,28,40,5,0,61,48,5,2000,-2:-2,hex,show,medium,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"