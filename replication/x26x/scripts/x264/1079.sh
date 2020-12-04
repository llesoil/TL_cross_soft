#!/bin/sh

numb='1080'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 0 --keyint 230 --lookahead-threads 3 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.6,1.4,3.8,0.3,0.7,0.0,0,1,8,0,230,3,29,0,4,3,68,38,2,2000,-2:-2,dia,crop,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"