#!/bin/sh

numb='2531'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 45 --keyint 260 --lookahead-threads 3 --min-keyint 29 --qp 10 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.5,1.4,1.2,3.8,0.5,0.8,0.2,3,1,2,45,260,3,29,10,4,4,60,28,1,2000,-1:-1,umh,show,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"