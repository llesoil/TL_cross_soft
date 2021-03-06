#!/bin/sh

numb='2106'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 30 --keyint 260 --lookahead-threads 2 --min-keyint 25 --qp 0 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.1,1.4,3.0,0.2,0.9,0.4,2,2,10,30,260,2,25,0,5,3,69,48,3,2000,1:1,dia,show,faster,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"