#!/bin/sh

numb='1307'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --intra-refresh --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 5 --keyint 220 --lookahead-threads 4 --min-keyint 21 --qp 50 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset ultrafast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,None,--slow-firstpass,--weightb,1.5,1.6,1.3,3.6,0.4,0.6,0.0,1,0,12,5,220,4,21,50,3,3,62,38,1,1000,1:1,dia,show,ultrafast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"