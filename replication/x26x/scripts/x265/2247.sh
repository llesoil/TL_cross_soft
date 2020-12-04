#!/bin/sh

numb='2248'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 20 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.1,1.1,0.8,0.2,0.9,0.7,1,2,16,20,230,2,30,50,3,0,65,18,4,2000,-2:-2,umh,crop,superfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"