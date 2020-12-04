#!/bin/sh

numb='2591'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 45 --keyint 290 --lookahead-threads 1 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.6,1.1,0.2,0.5,0.6,0.3,1,2,6,45,290,1,22,50,4,2,64,38,6,2000,-2:-2,umh,crop,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"