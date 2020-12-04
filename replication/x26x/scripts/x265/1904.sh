#!/bin/sh

numb='1905'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 35 --keyint 300 --lookahead-threads 2 --min-keyint 21 --qp 10 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.4,1.3,4.6,0.3,0.9,0.0,0,2,8,35,300,2,21,10,3,3,62,18,1,1000,1:1,hex,show,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"