#!/bin/sh

numb='2215'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 3.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 50 --keyint 240 --lookahead-threads 0 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.2,1.1,3.4,0.3,0.6,0.7,0,1,2,50,240,0,29,0,4,4,65,48,3,2000,-1:-1,umh,show,ultrafast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"