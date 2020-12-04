#!/bin/sh

numb='2979'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 2.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 35 --keyint 210 --lookahead-threads 2 --min-keyint 24 --qp 50 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.0,1.0,2.6,0.3,0.6,0.6,3,2,8,35,210,2,24,50,4,0,68,18,4,2000,-1:-1,umh,crop,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"