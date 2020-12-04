#!/bin/sh

numb='2838'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 10 --keyint 300 --lookahead-threads 3 --min-keyint 26 --qp 0 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.0,1.3,0.8,0.6,0.6,0.0,1,0,12,10,300,3,26,0,5,2,68,38,5,1000,-2:-2,dia,show,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"