#!/bin/sh

numb='786'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 5 --keyint 290 --lookahead-threads 0 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.4,1.1,4.6,0.3,0.9,0.7,2,0,12,5,290,0,27,40,4,3,69,38,5,1000,-2:-2,umh,crop,veryfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"