#!/bin/sh

numb='2080'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 1.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 35 --keyint 250 --lookahead-threads 1 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.3,1.2,1.8,0.5,0.7,0.1,1,2,8,35,250,1,26,10,4,3,66,18,2,2000,-2:-2,dia,show,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"