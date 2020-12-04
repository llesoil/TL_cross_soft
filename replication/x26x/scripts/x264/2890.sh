#!/bin/sh

numb='2891'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 35 --keyint 270 --lookahead-threads 1 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.0,1.0,3.4,0.6,0.7,0.9,3,1,0,35,270,1,24,40,3,0,64,18,4,1000,-2:-2,hex,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"