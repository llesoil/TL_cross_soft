#!/bin/sh

numb='1686'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 0 --keyint 260 --lookahead-threads 3 --min-keyint 24 --qp 50 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.2,1.3,1.0,0.2,0.7,0.7,1,0,2,0,260,3,24,50,4,0,68,18,2,1000,-2:-2,umh,show,slower,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"