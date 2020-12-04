#!/bin/sh

numb='1754'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --intra-refresh --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 45 --keyint 280 --lookahead-threads 4 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,None,--slow-firstpass,--no-weightb,1.5,1.0,1.3,2.8,0.6,0.7,0.1,0,1,4,45,280,4,29,20,5,1,67,18,1,2000,-2:-2,dia,show,superfast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"