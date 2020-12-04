#!/bin/sh

numb='2324'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 15 --keyint 250 --lookahead-threads 0 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset faster --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.6,1.2,4.2,0.4,0.6,0.6,1,1,8,15,250,0,29,20,4,4,64,38,6,1000,-2:-2,umh,crop,faster,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"