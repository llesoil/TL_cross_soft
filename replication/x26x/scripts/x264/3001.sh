#!/bin/sh

numb='3002'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 20 --keyint 300 --lookahead-threads 1 --min-keyint 21 --qp 30 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.0,1.6,1.2,2.2,0.5,0.9,0.1,1,1,16,20,300,1,21,30,4,1,65,28,4,1000,-2:-2,umh,crop,slow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"