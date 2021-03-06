#!/bin/sh

numb='1506'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 25 --keyint 210 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.4,1.3,3.2,0.2,0.9,0.6,2,2,14,25,210,1,27,10,4,1,63,48,6,2000,1:1,umh,show,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"