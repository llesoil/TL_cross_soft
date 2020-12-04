#!/bin/sh

numb='1309'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 20 --keyint 290 --lookahead-threads 3 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.6,1.2,1.4,0.6,0.7,0.4,2,2,10,20,290,3,26,10,4,1,62,18,3,1000,-1:-1,hex,show,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"