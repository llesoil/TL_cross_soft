#!/bin/sh

numb='2064'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 40 --keyint 200 --lookahead-threads 3 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.0,1.5,1.0,0.6,0.5,0.9,0.1,3,1,12,40,200,3,29,50,3,2,62,48,2,2000,-2:-2,hex,show,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"