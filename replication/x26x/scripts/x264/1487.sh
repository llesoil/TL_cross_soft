#!/bin/sh

numb='1488'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 25 --keyint 290 --lookahead-threads 1 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.5,1.2,0.8,0.3,0.8,0.2,1,0,10,25,290,1,21,30,5,0,60,18,4,2000,1:1,umh,show,slower,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"