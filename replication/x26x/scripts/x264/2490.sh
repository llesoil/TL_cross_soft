#!/bin/sh

numb='2491'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 15 --keyint 240 --lookahead-threads 2 --min-keyint 28 --qp 30 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.0,1.4,3.6,0.4,0.6,0.6,2,1,14,15,240,2,28,30,3,4,68,38,1,2000,1:1,hex,crop,veryfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"