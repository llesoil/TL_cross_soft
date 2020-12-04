#!/bin/sh

numb='1194'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 50 --keyint 300 --lookahead-threads 3 --min-keyint 26 --qp 30 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.5,1.3,2.6,0.6,0.9,0.0,2,1,8,50,300,3,26,30,3,3,65,28,6,2000,-1:-1,umh,crop,faster,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"