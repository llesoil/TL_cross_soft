#!/bin/sh

numb='2154'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 15 --keyint 210 --lookahead-threads 2 --min-keyint 20 --qp 0 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.0,1.4,3.8,0.4,0.6,0.1,0,0,6,15,210,2,20,0,4,3,65,48,1,2000,-1:-1,umh,show,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"