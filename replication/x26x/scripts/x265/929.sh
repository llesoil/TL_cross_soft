#!/bin/sh

numb='930'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 0 --keyint 210 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.6,1.1,4.4,0.3,0.7,0.0,0,0,4,0,210,2,29,20,3,4,61,28,3,2000,1:1,hex,crop,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"