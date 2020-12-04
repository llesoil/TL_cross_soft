#!/bin/sh

numb='2117'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 35 --keyint 200 --lookahead-threads 2 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.5,1.3,2.0,0.3,0.7,0.5,0,2,0,35,200,2,25,40,5,2,68,48,3,1000,-1:-1,hex,show,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"