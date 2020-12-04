#!/bin/sh

numb='2988'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 10 --keyint 270 --lookahead-threads 4 --min-keyint 24 --qp 0 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.3,1.4,1.4,0.4,0.6,0.2,2,1,2,10,270,4,24,0,3,4,68,48,5,1000,1:1,umh,show,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"