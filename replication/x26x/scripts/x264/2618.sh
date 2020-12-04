#!/bin/sh

numb='2619'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 45 --keyint 300 --lookahead-threads 3 --min-keyint 20 --qp 20 --qpstep 5 --qpmin 2 --qpmax 69 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.0,1.0,1.3,0.6,0.3,0.7,0.8,1,1,6,45,300,3,20,20,5,2,69,48,3,1000,-2:-2,umh,show,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"