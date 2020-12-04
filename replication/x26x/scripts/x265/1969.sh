#!/bin/sh

numb='1970'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 0 --keyint 250 --lookahead-threads 3 --min-keyint 22 --qp 10 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset superfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.1,1.1,0.4,0.2,0.8,0.2,3,2,14,0,250,3,22,10,4,4,66,18,5,2000,1:1,umh,show,superfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"