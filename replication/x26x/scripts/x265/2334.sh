#!/bin/sh

numb='2335'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 2.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 35 --keyint 200 --lookahead-threads 4 --min-keyint 20 --qp 50 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.5,1.0,1.0,2.8,0.2,0.6,0.5,3,2,10,35,200,4,20,50,4,1,65,38,2,2000,-2:-2,umh,show,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"