#!/bin/sh

numb='1191'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 40 --keyint 290 --lookahead-threads 3 --min-keyint 21 --qp 50 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.3,1.2,4.2,0.6,0.9,0.7,3,0,10,40,290,3,21,50,3,1,60,38,4,1000,-1:-1,hex,show,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"