#!/bin/sh

numb='383'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 25 --keyint 260 --lookahead-threads 2 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.5,1.6,1.2,1.4,0.6,0.6,0.1,1,1,8,25,260,2,26,50,4,4,65,48,3,2000,1:1,dia,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"