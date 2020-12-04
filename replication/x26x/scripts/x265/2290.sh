#!/bin/sh

numb='2291'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 50 --keyint 200 --lookahead-threads 2 --min-keyint 22 --qp 0 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.6,1.2,1.8,0.4,0.6,0.9,1,2,12,50,200,2,22,0,3,3,60,48,2,2000,1:1,hex,show,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"