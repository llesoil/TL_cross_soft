#!/bin/sh

numb='662'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 50 --keyint 270 --lookahead-threads 4 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.6,1.1,0.6,0.5,0.8,0.5,0,0,8,50,270,4,24,40,4,4,69,48,1,1000,-2:-2,hex,show,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"