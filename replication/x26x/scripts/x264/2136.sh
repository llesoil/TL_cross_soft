#!/bin/sh

numb='2137'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 10 --keyint 300 --lookahead-threads 0 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.6,1.1,2.4,0.2,0.9,0.2,1,2,6,10,300,0,27,0,3,3,65,48,3,2000,-1:-1,umh,crop,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"