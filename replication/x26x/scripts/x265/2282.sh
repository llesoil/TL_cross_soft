#!/bin/sh

numb='2283'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 30 --keyint 200 --lookahead-threads 1 --min-keyint 21 --qp 40 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset ultrafast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.5,1.6,1.2,1.4,0.4,0.7,0.2,2,1,12,30,200,1,21,40,3,4,68,48,1,1000,-2:-2,umh,crop,ultrafast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"