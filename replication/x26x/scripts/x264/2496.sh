#!/bin/sh

numb='2497'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 2.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 45 --keyint 210 --lookahead-threads 1 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.0,1.4,2.2,0.3,0.8,0.1,3,0,4,45,210,1,23,10,3,3,69,38,6,2000,-1:-1,umh,show,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"