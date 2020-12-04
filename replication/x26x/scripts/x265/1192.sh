#!/bin/sh

numb='1193'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 50 --keyint 290 --lookahead-threads 1 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset veryfast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.6,1.0,4.4,0.3,0.7,0.0,3,1,16,50,290,1,30,10,3,2,66,18,6,2000,1:1,hex,show,veryfast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"