#!/bin/sh

numb='1887'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 5.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 35 --keyint 220 --lookahead-threads 2 --min-keyint 23 --qp 40 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.0,1.0,1.0,5.0,0.4,0.8,0.3,0,0,10,35,220,2,23,40,4,2,63,48,2,2000,1:1,umh,show,veryslow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"